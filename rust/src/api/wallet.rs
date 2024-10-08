use super::Error;

use super::price::PriceGetter;

use web5_rust::common::traits::KeyValueStore;
use web5_rust::common::structs::DateTime;

use bdk::{TransactionDetails, KeychainKind, SyncOptions, SignOptions};
use bdk::bitcoin::consensus::{Encodable, Decodable};
use bdk::blockchain::electrum::ElectrumBlockchain;
use bdk::blockchain::esplora::EsploraBlockchain;
use bdk::esplora_client::{Builder, blocking::BlockingClient};
use bdk::bitcoin::blockdata::script::Script;
use bdk::bitcoin::bip32::ExtendedPrivKey;
use bdk::electrum_client::ElectrumApi;
use bdk::template::DescriptorTemplate;
use bdk::bitcoin::{Network, Address};
use bdk::bitcoin::hash_types::Txid;
use bdk::database::SqliteDatabase;
use bdk::database::MemoryDatabase;
use bdk::electrum_client::Client;
use bdk::wallet::{AddressIndex};
use bdk::template::Bip86;
use bdk::sled::Tree;
use bdk::FeeRate;
use bdk::Wallet as BDKWallet;

use tokio::sync::Mutex;
use std::sync::Arc;

use serde::{Serialize, Deserialize};
use secp256k1::rand::RngCore;
use secp256k1::rand;

use std::path::PathBuf;
use std::convert::TryInto;
use std::collections::BTreeMap;

const NO_INTERNET: &str = "failed to lookup address information: No address associated with hostname";
const CLIENT_URI: &str = "https://blockstream.info/api/";
const SATS: f64 = 100_000_000.0;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Seed{
    inner: Vec<u8>
}

impl Seed {
    pub fn new() -> Self {
        let mut inner: [u8; 64] = [0; 64];
        rand::thread_rng().fill_bytes(&mut inner);
        Seed{inner: inner.to_vec()}
    }

    pub fn get(&self) -> [u8; 64] {self.inner.clone().try_into().unwrap()}
}

impl Default for Seed {
    fn default() -> Self {
        Self::new()
    }
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct DescriptorSet {
    pub external: String,
    pub internal: String
}

impl DescriptorSet {
    pub fn from_seed(seed: &Seed) -> Result<Self, Error> {
        let xpriv = ExtendedPrivKey::new_master(Network::Bitcoin, &seed.get())?;
        let ex_desc = Bip86(xpriv, KeychainKind::External).build(Network::Bitcoin)?;
        let external = ex_desc.0.to_string_with_secret(&ex_desc.1);
        let in_desc = Bip86(xpriv, KeychainKind::Internal).build(Network::Bitcoin)?;
        let internal = in_desc.0.to_string_with_secret(&in_desc.1);
        Ok(DescriptorSet{external, internal})
    }
}

//  fn from_details(details: TransactionDetails, price: f64, isMine: impl Fn(&Script) -> bool) -> Result<Self, Error> {
//      let p = serde_json::to_string(&details)?;
//      let error = || Error::parse("Transaction", &p);
//      let is_send = details.sent > 0;
//      let transaction = details.transaction.ok_or(error())?;
//      let datetime = details.confirmation_time.map(|ct| Ok::<DateTime<Utc>, Error>(DateTime::from_timestamp(ct.timestamp as i64, 0).ok_or(error())?)).transpose()?;
//      let net = ((details.received as f64)-(details.sent as f64)) / SATS;
//      Ok(Transaction{
//          isReceive: !is_send,
//          sentAddress: if is_send {Some(Address::from_script(
//              transaction.output.iter().map(
//                      |out| out.script_pubkey.as_script()
//                  ).find(
//                      |s| isMine(*s)
//                  ).ok_or(error())?,
//              Network::Bitcoin
//          )?.to_string())} else {None},
//          txid: details.txid.to_string(),
//          btc: net,
//          usd: price * net,
//          fee: price * (details.fee.ok_or(error())? as f64 / SATS),
//          price,
//          date: datetime.map(|dt| dt.format("%Y-%m-%d").to_string()),
//          time: datetime.map(|dt| dt.format("%l:%M %p").to_string())
//      })

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Transaction {
    pub btc: f64,
    pub usd: f64,
    pub is_withdraw: bool,
    pub confirmation_time: Option<(u32, DateTime)>,
    pub fee: Option<f64>,
}

impl Transaction {
    pub async fn from_details(details: TransactionDetails) -> Result<Self, Error> {
        let btc = if details.sent >= details.received {
            details.sent as i64 - details.received as i64
        } else {
            details.received as i64 - details.sent as i64
        } as f64 / SATS;
        let is_withdraw = details.sent > 0;
        let confirmation_time = details.confirmation_time.map(|ct|
            Ok::<(u32, DateTime), Error>((ct.height, DateTime::from_timestamp(ct.timestamp)?))
        ).transpose()?;
        let usd = if let Some(ref ct) = confirmation_time.as_ref() {
            PriceGetter::get(Some(&ct.1)).await?
        } else {0.0};
        let fee = details.fee.map(|f| f as f64 / SATS);
        let error = || Error::bad_request("Transaction::from_details", "Missing Sent Address");
        Ok(Transaction{btc, usd, is_withdraw, confirmation_time, fee})
    }
}

#[derive(Clone)]
pub struct Wallet{
    inner: Arc<Mutex<BDKWallet<SqliteDatabase>>>,
    store: Box<dyn KeyValueStore>,
    price_getter: PriceGetter,
    descriptors: DescriptorSet,
    path: PathBuf
}

impl Wallet {
    pub fn new<KVS: KeyValueStore + 'static>(
        descriptors: DescriptorSet,
        price_getter: PriceGetter,
        path: PathBuf
    ) -> Result<Self, Error> {
        let inner = Self::inner_wallet(&descriptors, path.clone())?;
        Ok(Wallet{
            inner: Arc::new(Mutex::new(inner)),
            store: Box::new(KVS::new(path.clone())?),
            price_getter,
            descriptors,
            path
        })
    }

    fn inner_wallet(
        descriptors: &DescriptorSet,
        path: PathBuf
    ) -> Result<BDKWallet<SqliteDatabase>, Error> {
        std::fs::create_dir_all(path.clone())?;
        Ok(BDKWallet::new(
            &descriptors.external,
            Some(&descriptors.internal),
            Network::Bitcoin,
            SqliteDatabase::new(path.join("bdk.db"))
        )?)
    }

    pub async fn get_new_address(&self) -> Result<String, Error> {
        Ok(self.inner.lock().await.get_address(AddressIndex::New)?.address.to_string())
    }

    pub fn list_unspent(&self) -> Result<Vec<Transaction>, Error> {
        Ok(self.get_txs()?.into_iter().map(|(_, tx)| tx).collect())
    }

    pub fn get_balance(&self) -> Result<(f64, f64), Error> {
        let btc = self.get_bal()?;
        let price = self.price_getter.get_current_price()?;
        Ok((btc, btc*price))
    }

    fn get_txs(&self) -> Result<BTreeMap<Txid, Transaction>, Error> {
        Ok(self.store.get(b"transactions")?.map(|b|
            serde_json::from_slice(&b)
        ).transpose()?.unwrap_or_default())
    }

    fn get_bal(&self) -> Result<f64, Error> {
        Ok(self.store.get(b"balanace")?.map(|b|
            serde_json::from_slice(&b)
        ).transpose()?.unwrap_or_default())
    }

    pub async fn sync(&mut self) -> Result<(), Error> {
        let client = Builder::new(CLIENT_URI).build_blocking()?;
        let bc = EsploraBlockchain::from_client(client, 100);
        if let Err(e) = self.inner.lock().await.sync(&bc, SyncOptions::default()) {
            if !format!("{:?}", e).contains(NO_INTERNET) {
                return Err(e.into());
            }
        }
        self.post_sync().await?;
        Ok(())
    }

    async fn post_sync(&mut self) -> Result<(), Error> {
        let wallet = self.inner.lock().await;
        let mut txs = self.get_txs()?;
        for tx in wallet.list_transactions(true)? {
            if let Some(transaction) = txs.get(&tx.txid) {
                if transaction.confirmation_time.is_some() {continue;}
                if tx.confirmation_time.is_none() {continue;}
            }
            txs.insert(tx.txid, Transaction::from_details(tx).await?);
        }
        self.store.set(b"transactions", &serde_json::to_vec(&txs)?)?;
        let balance = self.get_bal()?;
        let btc = wallet.get_balance()?.get_total() as f64 / SATS;
        if balance != btc {
            self.store.set(b"balance", &serde_json::to_vec(&btc)?)?;
        }
        Ok(())
    }
}

//  impl Clone for Wallet {
//      fn clone(&self) -> Self {
//          let descriptors = self.descriptors.clone();
//          let inner = Wallet::inner_wallet(&descriptors, self.path.clone()).unwrap();
//          Wallet{
//              inner: Arc::new(Mutex::new(inner)),
//              store: self.store.clone(),
//              price_getter: self.price_getter.clone(),
//              descriptors,
//              path: self.path.clone()
//          }
//      }
//  }
