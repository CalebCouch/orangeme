use rust_on_rails::prelude::*;
use serde::{Serialize, Deserialize};
use std::sync::{Arc, Mutex, MutexGuard};
use std::time::Duration;
use std::str::FromStr;

use bdk_wallet::{Wallet, KeychainKind, ChangeSet, Update, LoadParams};
use bdk_wallet::descriptor::template::Bip86;
use bdk_wallet::bitcoin::bip32::Xpriv;
// use bdk_wallet::bitcoin::FeeRate;
pub use bdk_wallet::bitcoin::{Amount, Network, Address, Txid};
use bdk_wallet::{PersistedWallet, WalletPersister};
use bdk_wallet::chain::{Merge, ChainPosition, Anchor};
use bdk_esplora::esplora_client::Builder;
use bdk_esplora::EsploraExt;
use chrono::{TimeZone, Utc};
use serde_json::Value; // for getting bitcoin price from coinbase.com
use reqwest::Client;
use chrono::NaiveDateTime;
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
        println!("Getting price");
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
    transactions: Arc<Mutex<Vec<BDKTransaction>>>,
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
        // println!("Getting wallet");
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

    pub fn get_transactions(&mut self) -> Vec<BDKTransaction> {
        let txs = self.transactions.lock().unwrap().to_vec();
        println!("transactions {:?}", txs);
        txs
    }

    pub fn get_balance(&mut self) -> Amount {
        let mut wallet = self.get_wallet();
        let balance = wallet.as_mut().unwrap().balance().total();
        // println!("balance: {:?}", balance);
        balance
    }

    pub fn get_new_address(&mut self) -> Address {
        let mut persister = self.persister.lock().unwrap();
        let mut wallet = self.get_wallet();
        let mut wallet = wallet.as_mut().unwrap();
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
        println!("Creating new bdk plugin");
        let persister = Self::create_wallet(&mut h_ctx.cache).await;
        let persister = Arc::new(Mutex::new(persister));
        let price = Arc::new(Mutex::new(0.0));
        let transactions = Arc::new(Mutex::new(Vec::new()));
        println!("Created variables");
        (BDKPlugin{
            persister: persister.clone(), 
            price: price.clone(), 
            recipient_address: Arc::new(Mutex::new(None)),
            wallet: Arc::new(Mutex::new(None)),
            transactions: transactions.clone(),
        }, tasks![CachePersister(persister), GetPrice(price), GetTransactions(transactions)])
    }
}

pub struct WalletSync(MemoryPersister);
#[async_trait]
impl Task for WalletSync {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(5))}

    async fn run(&mut self, h_ctx: &mut HeadlessContext) {
        println!("Syncing...");
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

pub struct GetTransactions(Arc<Mutex<Vec<BDKTransaction>>>);
#[async_trait]
impl Task for GetTransactions {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(10))}

    async fn run(&mut self, h_ctx: &mut HeadlessContext) {
        println!("Running transactinos");
        let mut persister = h_ctx.cache.get::<MemoryPersister>().await;
        let mut wallet = PersistedWallet::load(&mut persister, LoadParams::new()).expect("Could not load wallet").expect("Wallet was none.");

        let txs = wallet.transactions_sort_by(|tx1, tx2| tx2.chain_position.cmp(&tx1.chain_position));
        let mut transactions = Vec::new();

        for canonical_tx in txs {
            let tx_node = &canonical_tx.tx_node;
            let txid = tx_node.txid;
            let tx = &tx_node.tx;

            let (confirmation_time, btc_price) = match &canonical_tx.chain_position {
                ChainPosition::Confirmed { anchor, .. } => {
                    let block_id = anchor.anchor_block();
                    let hash = block_id.hash.to_string();
            
                    let unix_timestamp = match get_block_time(&hash).await {
                        Ok(ts) => ts,
                        Err(_) => 0,
                    };

                    println!("Getting price");
                    let dt = Utc.timestamp_opt(unix_timestamp as i64, 0).unwrap();
                    let timestamp = dt.format("%Y-%m-%d %H:%M:%S").to_string();

                    let btc_price = get_btc_price_at(&timestamp).await.expect("Expected some dang money!");
                    println!("F^$: {:?}", btc_price);

                    let confirmation_time = format!("Confirmed at UNIX time: {}", timestamp);
            
                    (confirmation_time, btc_price)
                }
                _ => {
                    println!("NOT CONFIRMED"); // Get current price
                    ("Unconfirmed".to_string(), 0.0)
                }
            };
            
            let received: u64 = tx
                .output
                .iter()
                .filter(|out| wallet.is_mine(out.script_pubkey.clone()))
                .map(|out| out.value.to_sat())
                .sum();

            let input_sum: u64 = tx
                .input
                .iter()
                .filter_map(|input| wallet.get_utxo(input.previous_output))
                .map(|utxo| utxo.txout.value.to_sat())
                .sum();

            let sent = input_sum.saturating_sub(received);

            let fee = if input_sum > 0 {
                Some(input_sum.saturating_sub(tx.output.iter().map(|o| o.value.to_sat()).sum()))
            } else {
                None
            };

            let is_received = received > sent;

            let address = if is_received {
                tx.output
                    .iter()
                    .find_map(|out| {
                        if wallet.is_mine(out.script_pubkey.clone()) {
                            Address::from_script(&out.script_pubkey, wallet.network()).ok()
                        } else {
                            None
                        }
                    })
            } else {
                tx.input
                    .iter()
                    .find_map(|input| {
                        wallet.get_utxo(input.previous_output).and_then(|utxo| {
                            Address::from_script(&utxo.txout.script_pubkey, wallet.network()).ok()
                        })
                    })
            };

            transactions.push(BDKTransaction {
                txid,
                confirmation_time,
                is_received,
                amount_btc: Amount::from_sat(received.max(sent)),
                price: btc_price,
                fee: fee.map(Amount::from_sat),
                address,
            });
        }

        *self.0.lock().unwrap() = transactions;
    }
}

#[derive(Debug, Deserialize)]
struct BlockResponse {
    timestamp: u64,
    height: u32,
    id: String,
}

async fn get_block_time(block_hash: &str) -> Result<u64, Box<dyn std::error::Error>> {
    let url = format!("https://mempool.space/api/block/{}", block_hash);
    let res: BlockResponse = Client::new()
        .get(&url)
        .send()
        .await?
        .json()
        .await?;

    Ok(res.timestamp)
}

async fn get_btc_price_at(timestamp: &String) -> Result<f64, Box<dyn std::error::Error>> {
    let datetime = NaiveDateTime::parse_from_str(timestamp, "%Y-%m-%d %H:%M:%S")?;
    let target_timestamp = Utc.from_utc_datetime(&datetime).timestamp();

    let from = target_timestamp - 300;
    let to = target_timestamp + 300;

    // Construct the API URL
    let url = format!(
        "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart/range?vs_currency=usd&from={}&to={}",
        from, to
    );

    // Send the GET request
    let resp: Value = reqwest::get(&url).await?.json().await?;

    // Extract the prices array
    let prices = resp["prices"]
        .as_array()
        .ok_or("Missing 'prices' array in response")?;

    // Find the price closest to the target timestamp
    let closest_price = prices
        .iter()
        .filter_map(|entry| {
            let arr = entry.as_array()?;
            let ts = arr[0].as_f64()? as i64 / 1000; // Convert ms to seconds
            let price = arr[1].as_f64()?;
            Some((ts, price))
        })
        .min_by_key(|(ts, _)| (ts - target_timestamp).abs())
        .map(|(_, price)| price)
        .ok_or("No price data found in the specified range")?;

    Ok(closest_price)
}

#[derive(Debug, Clone)]
pub struct BDKTransaction {
    pub confirmation_time: String,
    pub txid: Txid,
    pub is_received: bool,
    pub amount_btc: Amount,
    pub price: f64,
    pub fee: Option<Amount>,
    pub address: Option<Address>
}

// pub struct DateTime {
//     pub date: &'static str,
//     pub time: &'static str,
// }

// impl DateTime {
//     pub fn from_unix(time: &Unix) -> Self {
//         DateTime {
//             date: "11/15/24",
//             time: "11:48pm",
//         }
//     }

//     pub fn shorthand(&self) -> str {
//         "Yesterday"
//     }
// }

// pub fn _add_password(&self, password: &str) {
//     use objc2_core_foundation::CFDictionary;
//     use objc2_core_foundation::CFString;
//     use objc2_core_foundation::CFData;
//     use objc2_core_foundation::CFType;
//     // use objc2_security::SecItemAdd;
//     use objc2_security::SecItemDelete;
//     use objc2_security::kSecAttrService;
//     use objc2_security::kSecValueData;
//     use objc2_security::kSecClassGenericPassword;
//     use objc2_security::kSecAttrAccount;
//     use objc2_security::kSecClass;

//     use std::ptr;
//     let account_cf = CFString::from_str("did::nym::happyduckyforeverrrrrr");
//     let service_cf = CFString::from_str("orange.me");
//     let password_data = CFData::from_bytes(password.as_bytes());
//     let keys: [&CFType; 4] = unsafe { [
//         kSecClass.as_ref(),
//         kSecAttrAccount.as_ref(),
//         kSecAttrService.as_ref(),
//         kSecValueData.as_ref(),
//     ]};

//     let values: [&CFType; 4] = unsafe { [
//         kSecClassGenericPassword.as_ref(),
//         account_cf.as_ref(),
//         service_cf.as_ref(),
//         password_data.as_ref(),
//     ] };

//     let key_callbacks = ptr::null();
//     let value_callbacks = ptr::null();

//     let query = unsafe {
//         CFDictionary::new(
//             None,
//             keys.as_ptr() as *mut *const std::ffi::c_void,
//             values.as_ptr() as *mut *const std::ffi::c_void,
//             keys.len() as isize,
//             key_callbacks,
//             value_callbacks,
//         )
//     };

//     if let Some(query_dict) = query {
//         unsafe { SecItemDelete(query_dict.as_ref()) };
//     } else {
//         println!("Failed to create CFDictionary.");
//     }
// }
