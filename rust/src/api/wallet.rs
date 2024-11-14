use super::Error;

use super::price::PriceGetter;
use super::state::{State};
use super::structs::DateTime;
use super::state::Field;
use super::pub_structs::{SATS, Sats, Usd};

use simple_database::SqliteStore;

use bdk::{TransactionDetails, KeychainKind, SyncOptions, SignOptions};
use bdk::bitcoin::consensus::{Encodable, Decodable};
use bdk::blockchain::electrum::ElectrumBlockchain;
use bdk::blockchain::esplora::EsploraBlockchain;
use bdk::esplora_client::{Builder, blocking::BlockingClient};
use bdk::bitcoin::blockdata::script::Script;
use bdk::bitcoin::bip32::ExtendedPrivKey;
use bdk::bitcoin::TxOut;
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
use bdk::{BlockTime, FeeRate};
use bdk::bitcoin::psbt::PartiallySignedTransaction as PSBT;
use bdk::Wallet as BDKWallet;
use bdk::blockchain::GetTx;

use tokio::sync::Mutex;
use std::sync::Arc;

use serde::{Serialize, Deserialize};
use secp256k1::rand::RngCore;
use secp256k1::rand;

use std::path::PathBuf;
use std::convert::TryInto;
use std::collections::BTreeMap;
use std::str::FromStr;

const NO_INTERNET: &str = "failed to lookup address information: No address associated with hostname";
const CLIENT_URI: &str = "ssl://electrum.blockstream.info:50002";

pub type Transactions = BTreeMap<Txid, Transaction>;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Seed{
    pub inner: Vec<u8>
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

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
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

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct Transaction {
    pub btc: f64,
    pub usd: f64,
    pub price: f64,
    pub address: String,
    pub is_withdraw: bool,
    pub confirmation_time: Option<(u32, DateTime)>,
    pub fee: f64,
    pub fee_usd: f64,
}

impl Transaction {
    pub fn from_details(details: TransactionDetails, price: f64, is_mine: impl Fn(&Script) -> bool) -> Result<Self, Error> {
        let ec = "Transaction::from_details";
        let btc = if details.sent >= details.received {
            details.sent as i64 - details.received as i64
        } else {
            details.received as i64 - details.sent as i64
        } as f64 / SATS;
        let is_withdraw = details.sent > 0;
        let details_tx = details.transaction.ok_or(Error::bad_request(ec, "Missing Transaction"))?;
        let address = if is_withdraw {
            details_tx.output.clone().into_iter().find_map(|txout| {
                if !is_mine(txout.script_pubkey.as_script()) {
                    Some(Address::from_script(txout.script_pubkey.as_script(), Network::Bitcoin).ok()?.to_string())
                } else {None}
            }).unwrap_or("Redoposit".to_string())
        } else {
            let txout = details_tx.output.clone().into_iter().find(|txout| is_mine(txout.script_pubkey.as_script())).ok_or(Error::bad_request(ec, "No Output is_mine"))?;
            Address::from_script(txout.script_pubkey.as_script(), Network::Bitcoin)?.to_string()
        };
        let confirmation_time = details.confirmation_time.map(|ct|
            Ok::<(u32, DateTime), Error>((ct.height, DateTime::from_timestamp(ct.timestamp)?))
        ).transpose()?;
        let usd = btc*price;
        let fee = details.fee.ok_or(Error::bad_request(ec, "Missing Fee"))? as f64 / SATS;
        let fee_usd = fee*price;
        Ok(Transaction{btc, usd, price, address, is_withdraw, confirmation_time, fee, fee_usd})
    }
}

pub struct Wallet{
    inner: Arc<Mutex<BDKWallet<SqliteDatabase>>>,
    descriptors: DescriptorSet,
    path: PathBuf
}

impl Wallet {
    pub fn new(
        descriptors: DescriptorSet,
        path: PathBuf,
    ) -> Result<Self, Error> {
        Ok(Wallet{
            inner: Self::inner_wallet(&descriptors, path.clone())?,
            descriptors,
            path
        })
    }

    fn inner_wallet(
        descriptors: &DescriptorSet,
        path: PathBuf
    ) -> Result<Arc<Mutex<BDKWallet<SqliteDatabase>>>, Error> {
        std::fs::create_dir_all(path.clone())?;
        Ok(Arc::new(Mutex::new(BDKWallet::new(
            &descriptors.external,
            Some(&descriptors.internal),
            Network::Bitcoin,
            SqliteDatabase::new(path.join("bdk.db"))
        )?)))
    }

    pub async fn get_new_address(&self) -> Result<String, Error> {
        Ok(self.inner.lock().await.get_address(AddressIndex::New)?.address.to_string())
    }

    fn estimate_fee(blocks: usize) -> Result<Sats, Error> {
        Ok(ElectrumBlockchain::from(Client::new(CLIENT_URI)?).estimate_fee(blocks)? as Sats)
    }

    async fn sats_to_usd(sats: Sats) -> Result<Usd, Error> {
        let price = PriceGetter::get(None).await?;
        Ok((sats * SATS) * price)
    }

    pub async fn get_fees(&self, address: &str, amount: Sats, price: Usd) -> Result<(Usd, Usd), Error> {
        let one = Self::estimate_fee(1)?;
        let three = Self::estimate_fee(3)?;
        let kvb = self.tx_builder(address, amount, three)?.0.extract_tx().vsize() / 1000;
        Ok((
            Self::sats_to_usd(one * kvb),
            Self::sats_to_usd(three * kvb)
        ))
    }

    async fn tx_builder(&self, address: &str, amount: Sats, fee: Sats) -> Result<(PSBT, bdk::TransactionDetails), Error> {
        let inner = self.inner.lock().await;
        let mut builder = inner.build_tx();
        let address = Address::from_str(address)?.require_network(Network::Bitcoin)?;
        builder.add_recipient(address.script_pubkey(), amount);
        builder.fee_rate(FeeRate::from_sat_per_kvb(fee));
        Ok(builder.finish()?)
    }


  //pub async fn build_transaction(&self, address: &str, amount: f64, blocks: usize) -> Result<(PSBT, Transaction), Error> {
  //    let (psbt, mut tx_details) = self.tx_builder(address, amount, blocks).await?;
  //    let tx = psbt.clone().extract_tx();
  //    tx_details.transaction = Some(tx);
  //    let price = Self::get_price(tx_details.confirmation_time.as_ref()).await?;
  //    let inner = self.inner.lock().await;
  //    let transaction = Transaction::from_details(tx_details, price, |s: &Script| -> bool {inner.is_mine(s).unwrap_or_default()})?;
  //    Ok((psbt, transaction))
  //}

//  pub async fn build_transaction(&mut self) -> Result<String, Error> {
//      let ec = "Main.create_transaction";
//      let error = || Error::bad_request(ec, "Invalid parameters");
//      let blockchain = ElectrumBlockchain::from(Client::new(CLIENT_URI)?);

//      let address_str = self.state.get::<String>(Field::Address).await?;
//      let address = Address::from_str(&address_str)?.require_network(Network::Bitcoin);

//      let amount_btc = self.state.get::<f64>(Field::AmountBTC).await?;
//      let priority = self.state.get::<u8>(Field::Priority).await?;

//      let price = self.state.get::<f64>(Field::Price).await?;

//      let is_mine = |s: &Script| self.inner.is_mine(s).unwrap_or(false);
//      let amount = (amount_btc * SATS) as u64;

//      let selected_fee = if priority == 0 {
//          blockchain.estimate_fee(3)? as f64 / 1000.0
//      } else {
//          blockchain.estimate_fee(1)? as f64 / 1000.0
//      };

//      let (mut psbt, mut tx_details) = {
//          let mut builder = self.inner.build_tx();
//          builder.add_recipient(address?.script_pubkey(), amount);
//          builder.fee_rate(FeeRate::from_sat_per_vb(selected_fee as f32));
//          builder.finish()?
//      };

//      let finalized = self.inner.sign(&mut psbt, SignOptions::default())?;
//      if !finalized { return Err(Error::err(ec, "Could not sign std tx"));}

//      let tx = psbt.clone().extract_tx();
//      self.state.set(Field::CurrentRawTx, &tx).await?;

//      tx_details.transaction = Some(tx);

//      let tx = Transaction::from_details(tx_details.clone(), price, |s: &Script| {self.inner.is_mine(s).unwrap_or(false)})?;
//      self.state.set(Field::CurrentTx, &tx).await?;
//      Ok(serde_json::to_string(&tx)?)
//  }

    fn get_blockchain() -> Result<ElectrumBlockchain, Error> {
        let client = bdk::electrum_client::Client::new(CLIENT_URI)?;
        Ok(ElectrumBlockchain::from(client))
    }

    pub async fn sync(&self) -> Result<(), Error> {
        let blockchain = Self::get_blockchain()?;
        if let Err(e) = self.inner.lock().await.sync(&blockchain, SyncOptions::default()) {
           if !format!("{:?}", e).contains(NO_INTERNET) {
               return Err(e.into());
            }
        }
        Ok(())
    }

    pub async fn refresh_state(&self, state: &State) -> Result<(), Error> {
        let inner = self.inner.lock().await;
        //Transactions
        let mut txs = state.get_or_default::<Transactions>(&Field::Transactions(None)).await?;
        for tx in inner.list_transactions(true)? {
            if let Some(transaction) = txs.get(&tx.txid) {
                if transaction.confirmation_time.is_some() {continue;}
                if tx.confirmation_time.is_none() {continue;}
            }

            let price = Self::get_price(tx.confirmation_time.as_ref()).await?;
            let price = if let Some(ct) = confirmation_time {
                PriceGetter::get(Some(&DateTime::from_timestamp(ct.timestamp)?)).await?
            } else {
                state.get_or_default::<f64>(Field::Price(None))?
            };
            txs.insert(tx.txid, Transaction::from_details(tx, price, |s: &Script| -> bool {inner.is_mine(s).unwrap_or_default()})?);
        }
        state.set(Field::Transactions(Some(txs))).await?;

        //Balance
        state.set(Field::Balance(Some(inner.get_balance()?.get_total() as f64 / SATS))).await?;
        Ok(())
    }
}

impl Clone for Wallet {
    fn clone(&self) -> Self {
        Wallet{
            inner: Wallet::inner_wallet(&self.descriptors, self.path.clone()).unwrap(),
            descriptors: self.descriptors.clone(),
            path: self.path.clone()
        }
    }
}
