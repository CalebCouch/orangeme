use super::Error;

use super::price::PriceGetter;
use super::state::{State, Field};

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
        let usd = if let Some(ct) = confirmation_time.as_ref() {
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
    descriptors: DescriptorSet,
    state: State,
    path: PathBuf
}

impl Wallet {
    pub fn new(
        descriptors: DescriptorSet,
        state: State,
        path: PathBuf
    ) -> Result<Self, Error> {
        let inner = Self::inner_wallet(&descriptors, path.clone())?;
        Ok(Wallet{
            inner: Arc::new(Mutex::new(inner)),
            descriptors,
            state,
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
        let mut txs = self.state.get::<BTreeMap<Txid, Transaction>>(Field::Transactions)?;
        for tx in wallet.list_transactions(true)? {
            if let Some(transaction) = txs.get(&tx.txid) {
                if transaction.confirmation_time.is_some() {continue;}
                if tx.confirmation_time.is_none() {continue;}
            }
            txs.insert(tx.txid, Transaction::from_details(tx).await?);
        }
        self.state.set(Field::Transactions, &txs)?;
        let balance = self.state.get::<f64>(Field::Balance)?;
        let btc = wallet.get_balance()?.get_total() as f64 / SATS;
        if balance != btc {
            self.state.set(Field::Balance, &btc)?;
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
