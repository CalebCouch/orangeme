use rust_on_rails::prelude::*;
use serde::{Serialize, Deserialize};
use std::sync::{Arc, Mutex, MutexGuard};
use std::time::Duration;
use std::str::FromStr;

use bdk_wallet::{Wallet, KeychainKind, ChangeSet, Update, LoadParams, WalletTx};
use bdk_wallet::descriptor::template::Bip86;
use bdk_wallet::bitcoin::bip32::Xpriv;
use bdk_wallet::bitcoin::FeeRate;
pub use bdk_wallet::bitcoin::{Amount, Network, Address};
use bdk_wallet::{PersistedWallet, WalletPersister};
use bdk_wallet::chain::Merge;
use bdk_esplora::esplora_client::Builder;
use bdk_esplora::EsploraExt;

use serde_json::Value; // for getting bitcoin price from coinbase.com

const SATS: u64 = 1_000_000;

// store price in the cache, pull it out on startup

#[derive(Serialize, Deserialize, Default, Clone, Debug)]
pub struct WalletKey(Option<Xpriv>);

#[derive(Serialize, Deserialize, Default, Debug, Clone)]
pub struct MemoryPersister(ChangeSet);
impl WalletPersister for MemoryPersister {
    type Error = ();
    fn initialize(persister: &mut Self) -> Result<ChangeSet, Self::Error> {Ok(persister.0.clone())}
    fn persist(persister: &mut Self, changeset: &ChangeSet) -> Result<(), Self::Error> {persister.0.merge(changeset.clone()); Ok(())}
}

pub struct CachePersister(Arc<Mutex<MemoryPersister>>);
#[async_trait]
impl Task for CachePersister {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(1))}

    async fn run(&mut self, h_ctx: &mut HeadlessContext) {
        println!("persisting");
        let mut persister = h_ctx.cache.get::<MemoryPersister>().await;
        {
            let mut amcs = self.0.lock().unwrap();
            amcs.0.merge(persister.0);
            persister = (*amcs).clone();
        }
        h_ctx.cache.set(&persister).await;
    }
}

pub struct GetPrice(Arc<Mutex<f32>>);
#[async_trait]
impl Task for GetPrice {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(10))}

    async fn run(&mut self, _h_ctx: &mut HeadlessContext) {
        let url = "https://api.coinbase.com/v2/prices/spot?currency=USD";
        let body = reqwest::get(url).await.expect("Could not get url").text().await.expect("Could not get text");
        let json: Value = serde_json::from_str(&body).expect("Could not serde to string");
        let price_str = json["data"]["amount"].as_str().expect("Could not serde to str");
        let price: f32 = price_str.parse().expect("Could not parse as f32");
        *self.0.lock().unwrap() = price;
    }
}

pub struct BDKPlugin {
    persister: Arc<Mutex<MemoryPersister>>,
    recipient_address: Arc<Mutex<Option<Address>>>,
    wallet: Arc<Mutex<Option<PersistedWallet<MemoryPersister>>>>,
    price: Arc<Mutex<f32>>,
}
impl BDKPlugin {
    pub async fn _init(&mut self) {//Include theme
        println!("Initialized BDK");
    }

    pub async fn get_descriptors(cache: &mut Cache) -> (Bip86<Xpriv>, Bip86<Xpriv>) {
        //TODO: from web 5 normally
        let key = cache.get::<WalletKey>().await.0.unwrap_or(
            Xpriv::new_master(Network::Bitcoin, &secp256k1::SecretKey::new(&mut secp256k1::rand::thread_rng()).secret_bytes()).unwrap()
        );
        println!("key: {}", hex::encode(key.private_key.secret_bytes()));
        cache.set(&WalletKey(Some(key))).await;
        (Bip86(key, KeychainKind::External), 
         Bip86(key, KeychainKind::Internal))
    }

    pub fn get_wallet(&self) -> MutexGuard<Option<PersistedWallet<MemoryPersister>>> {
        let mut wallet_guard = self.wallet.lock().unwrap();
    
        if wallet_guard.is_none() {
            println!("Wallet was none");
            let mut db = self.persister.lock().unwrap();
            let wallet = PersistedWallet::load(&mut *db, LoadParams::new())
                .expect("Could not load wallet")
                .expect("Wallet was none.");
            *wallet_guard = Some(wallet);
        }
    
        wallet_guard
    }    
    pub async fn create_wallet(cache: &mut Cache) -> MemoryPersister {
        let mut db = cache.get::<MemoryPersister>().await; 
        let (ext, int) = Self::get_descriptors(cache).await;
        let network = Network::Bitcoin;
        let wallet_opt = Wallet::load()
            .descriptor(KeychainKind::External, Some(ext.clone()))
            .descriptor(KeychainKind::Internal, Some(int.clone()))
            .extract_keys()
            .check_network(network)
            .load_wallet(&mut db)
            .expect("wallet");
        match wallet_opt {
            Some(wallet) => wallet,
            None => {
                println!("created: {:?}", db.0.indexer);
                Wallet::create(ext, int)
                .network(network)
                .create_wallet(&mut db)
                .expect("wallet")
            }
        };
        db
    }

    pub fn get_transactions(&mut self) {
        use chrono::NaiveDateTime;
        use std::collections::HashSet;

        let mut wallet = self.get_wallet();
        let wallet = wallet.as_mut().unwrap();

        let txs = wallet.transactions_sort_by(|tx1, tx2| tx2.chain_position.cmp(&tx1.chain_position));

        for canonical_tx in txs {
            let tx_node = canonical_tx.tx_node;
            let txid = tx_node.txid;
            let tx = &tx_node.tx;

            // Calculate received amount by checking which outputs are ours
            let received: u64 = tx
                .output
                .iter()
                .filter(|out| wallet.is_mine(out.script_pubkey.clone()))
                .map(|out| out.value.to_sat())
                .sum();

            let mut input_sum = 0;
            for input in &tx.input {
                if let Some(prevout) = wallet.get_utxo(input.previous_output) {
                    input_sum += prevout.txout.value.to_sat();
                }
            }
    
            let sent = if received <= input_sum {
                input_sum - received
            } else {
                0 // Self-transfer or edge case
            };
    
            let fee = if input_sum > 0 && tx.output.iter().map(|o| o.value.to_sat()).sum::<u64>() < input_sum {
                Some(input_sum - tx.output.iter().map(|o| o.value.to_sat()).sum::<u64>())
            } else {
                None
            };

            // if let Some(last_seen) = tx_node.last_seen_unconfirmed {
            //     println!("Last seen as unconfirmed at Unix timestamp: {}", last_seen);
            // } else {
            //     println!("Transaction not seen as unconfirmed");
            // }
    
            let direction = if sent > 0 && received == 0 {
                "Sent"
            } else if received > 0 && sent == 0 {
                "Received"
            } else {
                "Self-transfer or mixed"
            };
    
            // println!("TXID: {}", txid);
            // // println!("Date/time: {:?}", timestamp);
            // println!("Direction: {}", direction);
            // println!("Received: {} sats", received);
            // println!("Sent: {} sats", sent);
            // println!("Fee: {:?}", fee.map(|f| format!("{} sats", f)));
            // println!("-----------------------------");
        }
    }


    pub fn get_balance(&mut self) -> Amount {
        let mut wallet = self.get_wallet();
        wallet.as_mut().unwrap().balance().total()
    }

    pub fn get_new_address(&mut self) -> Address {
        let mut persister = self.persister.lock().unwrap();
        let mut wallet: PersistedWallet<MemoryPersister> = self.wallet.lock().unwrap().take().expect("wallet was none");
        let address = wallet.reveal_next_address(KeychainKind::External);
        wallet.persist(&mut persister).expect("write is okay");
        address.address
    }

    pub fn get_price(&self) -> f32 {
        *self.price.lock().unwrap()
    }

    pub fn set_recipient_address(&mut self, address: String) -> bool {
        if let Ok(add) = Address::from_str(&address) {
            *self.recipient_address.lock().unwrap() = add.require_network(Network::Bitcoin).ok();
            true
        } else { false }
    }

    pub fn get_recipient_address(&self) -> Option<Address> {
        self.recipient_address.lock().unwrap().clone()
    }

    pub fn get_fees(&mut self, btc: f64) -> (f32, f32) {
        // println!("RUNNING GET FEES");
        // let address = self.get_recipient_address().expect("Address not found.");
        // println!("GOT ADDRESS");
        // let mut wallet = self.get_wallet();
        // let mut tx_builder = wallet.build_tx();
        // println!("BUILD TX BUILDER");
        // tx_builder
        //     .add_recipient(address.script_pubkey(), Amount::from_btc(btc).expect("Could not parse"))
        //     .fee_rate(FeeRate::from_sat_per_vb(5).expect("valid feerate"));
        // println!("BEFORE");
        // let psbt = tx_builder.finish().expect("HUh?");
        // println!("AFTER: psdbt {:?}", psbt);
        (0.0, 0.0)
    }

    pub fn get_dust_limit(&self) -> f32 {(546 / SATS) as f32}

    pub fn _add_password(&self, password: &str) {
        use objc2_core_foundation::CFDictionary;
        use objc2_core_foundation::CFString;
        use objc2_core_foundation::CFData;
        use objc2_core_foundation::CFType;
        // use objc2_security::SecItemAdd;
        use objc2_security::SecItemDelete;
        use objc2_security::kSecAttrService;
        use objc2_security::kSecValueData;
        use objc2_security::kSecClassGenericPassword;
        use objc2_security::kSecAttrAccount;
        use objc2_security::kSecClass;

        use std::ptr;
        let account_cf = CFString::from_str("did::nym::happyduckyforeverrrrrr");
        let service_cf = CFString::from_str("orange.me");
        let password_data = CFData::from_bytes(password.as_bytes());
        let keys: [&CFType; 4] = unsafe { [
            kSecClass.as_ref(),
            kSecAttrAccount.as_ref(),
            kSecAttrService.as_ref(),
            kSecValueData.as_ref(),
        ]};

        let values: [&CFType; 4] = unsafe { [
            kSecClassGenericPassword.as_ref(),
            account_cf.as_ref(),
            service_cf.as_ref(),
            password_data.as_ref(),
        ] };

        let key_callbacks = ptr::null();
        let value_callbacks = ptr::null();

        let query = unsafe {
            CFDictionary::new(
                None,
                keys.as_ptr() as *mut *const std::ffi::c_void,
                values.as_ptr() as *mut *const std::ffi::c_void,
                keys.len() as isize,
                key_callbacks,
                value_callbacks,
            )
        };

        if let Some(query_dict) = query {
            unsafe { SecItemDelete(query_dict.as_ref()) };
        } else {
            println!("Failed to create CFDictionary.");
        }
    }

    // pub fn get_transactions(&self) -> Vec<WalletTx<'_>> {
    //     self.wallet.transactions_sort_by(|tx1, tx2| {
    //         tx1.chain_position.cmp(&tx2.chain_position)
    //     })
    // }

    // get bitcoin price
    // set recipient address
    // get recipient address
    // set send amount
    // get send amount
    // set priority
    // get priority
    // get_fee (priority) -> (f32, f32)
    // build transaction
    // submit transaction
    // get all transactions

}

impl Plugin for BDKPlugin {
    async fn background_tasks(ctx: &mut HeadlessContext) -> Tasks {
        let persister = Self::create_wallet(&mut ctx.cache).await;
        tasks![WalletSync(persister)]
    }

    async fn new(_ctx: &mut Context, h_ctx: &mut HeadlessContext) -> (Self, Tasks) {
        let persister = Self::create_wallet(&mut h_ctx.cache).await;
        let persister = Arc::new(Mutex::new(persister));
        let price = Arc::new(Mutex::new(0.0));
        (BDKPlugin{
            persister: persister.clone(), 
            price: price.clone(), 
            recipient_address: Arc::new(Mutex::new(None)),
            wallet: Arc::new(Mutex::new(None)),
        }, tasks![CachePersister(persister), GetPrice(price)])
    }
}

pub struct WalletSync(MemoryPersister);
#[async_trait]
impl Task for WalletSync {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(5))}

    async fn run(&mut self, h_ctx: &mut HeadlessContext) {
        let mut persister = h_ctx.cache.get::<MemoryPersister>().await;
        let mut wallet = PersistedWallet::load(&mut persister, LoadParams::new()).expect("Could not load wallet").expect("Wallet was none.");

        let scan_request = wallet.start_full_scan().build();

        let builder = Builder::new("https://blockstream.info/api");
        let blocking_client = builder.build_blocking();
        let res = blocking_client.full_scan(scan_request, 10, 1).unwrap();
        wallet.apply_update(Update::from(res)).unwrap();

        wallet.persist(&mut persister).expect("write is okay");
        let persister2 = h_ctx.cache.get::<MemoryPersister>().await;
        self.0.0.merge(persister2.0);
        h_ctx.cache.set(&persister).await;
    }
}

