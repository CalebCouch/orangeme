use super::Error;

//use super::protocols::{SocialProtocol, ProfileProtocol};

use flutter_rust_bridge::DartFnFuture;
use flutter_rust_bridge::frb;

use std::convert::TryInto;
use std::{thread, time};
use std::str::FromStr;
use std::path::{Path, PathBuf};
use std::sync::{Arc, Mutex};
use std::sync::mpsc::channel;

//  use web5_rust::dwn::interfaces::{ProtocolsConfigureOptions, RecordsWriteOptions};
//  use web5_rust::dwn::structs::DataInfo;
//  use web5_rust::common::traits::KeyValueStore;
//  use web5_rust::common::structs::{Url, DataFormat};
//  use web5_rust::common::{SqliteStore, Cache};
//  use web5_rust::agent::Agent;

//  pub use web5_rust::dwn::protocol::{
//      ProtocolPath,
//      ProtocolUri,
//      Protocol,
//  };

use bdk::{TransactionDetails, Wallet, KeychainKind, SyncOptions, SignOptions};
use bdk::bitcoin::consensus::{Encodable, Decodable};
use bdk::blockchain::electrum::ElectrumBlockchain;
use bdk::blockchain::esplora::EsploraBlockchain;
use bdk::bitcoin::blockdata::script::Script;
use bdk::bitcoin::bip32::ExtendedPrivKey;
use bdk::electrum_client::ElectrumApi;
use bdk::template::DescriptorTemplate;
use bdk::bitcoin::{Network, Address};
use serde::{Serialize, Deserialize};
use bdk::database::SqliteDatabase;
use bdk::database::MemoryDatabase;
use chrono::{Utc, Date, DateTime};
use bdk::electrum_client::Client;
use bdk::wallet::{AddressIndex};
use secp256k1::rand::RngCore;
use serde_json::to_string;
use bdk::template::Bip86;
use futures::future::ok;
use secp256k1::rand;
use bdk::sled::Tree;
use bdk::FeeRate;

const STORAGE_SPLIT: &str = "\u{0000}";

//INTERNAL
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct DescriptorSet {
    pub external: String,
    pub internal: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct DartCommand {
    pub method: String,
    pub data: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RustCommand {
    pub uid: String,
    pub method: String,
    pub data: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RustResponse {
    pub uid: String,
    pub data: String
}

//PRICE FETCH
#[derive(Deserialize)]
struct PriceRes {data: Price}
#[derive(Deserialize)]
struct Price {amount: String, currency: String}
#[derive(Deserialize)]
struct Spot {amount: String, currency: String, base: String}
#[derive(Deserialize)]
struct SpotRes {data: Spot}
//PRICE FETCH

async fn invoke(dartCallback: impl Fn(String) -> DartFnFuture<String>, method: &str, data: &str) -> Result<String, Error> {
    let res = dartCallback(serde_json::to_string(&DartCommand{method: method.to_string(), data: data.to_string()})?).await;
    if res.contains("Error") {
        return Err(Error::DartError(res.to_string()))
    }
    Ok(res)
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Transaction {
    pub isReceive: bool,
    pub sentAddress: Option<String>,
    pub txid: String,
    pub usd: f64,
    pub btc: f64,
    pub price: f64,
    pub fee: Option<f64>,
    pub date: Option<String>,
    pub time: Option<String>
}

impl Transaction {
    fn from_details(details: TransactionDetails, price: f64, isMine: impl Fn(&Script) -> bool) -> Result<Self, Error> {
        let error = || Error::parse("Transaction", "TransactionDetails");
        let is_send = details.sent > 0;
        let transaction = details.transaction.ok_or(error())?;
        let datetime = details.confirmation_time.map(|ct| Ok::<DateTime<Utc>, Error>(DateTime::from_timestamp(ct.timestamp as i64, 0).ok_or(error())?)).transpose()?;
        let net = ((details.received as f64)-(details.sent as f64)) / 10_000_000.0;
        Ok(Transaction{
            isReceive: !is_send,
            sentAddress: if is_send {Some(Address::from_script(
                transaction.output.iter().map(
                        |out| out.script_pubkey.as_script()
                    ).find(
                        |s| isMine(*s)
                    ).ok_or(error())?,
                Network::Bitcoin
            )?.to_string())} else {None},
            txid: serde_json::to_string(&details.txid)?,
            btc: net,
            usd: price * net,
            fee: details.fee.map(|fee| price * (fee as f64 / 10_000_000.0)),
            price,
            date: datetime.map(|dt| dt.format("%Y-%m-%d").to_string()),
            time: datetime.map(|dt| dt.format("%l:%M %P").to_string()),
        })
    }
}


#[derive(Serialize, Deserialize, Debug, Default)]
pub struct DartState {
    currentPrice: f64,
    usdBalance: f64,
    btcBalance: f64,
    transactions: Vec<Transaction>
}

async fn get_descriptors(callback: impl Fn(String) -> DartFnFuture<String>) -> Result<DescriptorSet, Error> {
    let descriptors = invoke(&callback, "secure_get", "descriptors").await?;
    let descriptors = if descriptors.is_empty() {
        let mut seed: [u8; 64] = [0; 64];
        rand::thread_rng().fill_bytes(&mut seed);
        invoke(&callback, "secure_set", &format!("{}{}{}", "seed", STORAGE_SPLIT, &serde_json::to_string(&seed.to_vec())?)).await?;
        let xpriv = ExtendedPrivKey::new_master(Network::Bitcoin, &seed)?;
        let ex_desc = Bip86(xpriv, KeychainKind::External).build(Network::Bitcoin)?;
        let external = ex_desc.0.to_string_with_secret(&ex_desc.1);
        let in_desc = Bip86(xpriv, KeychainKind::Internal).build(Network::Bitcoin)?;
        let internal = in_desc.0.to_string_with_secret(&in_desc.1);
        let set = DescriptorSet{external, internal};

        invoke(&callback, "secure_set", &format!("{}{}{}", "descriptors", STORAGE_SPLIT, &serde_json::to_string(&set)?)).await?;
        set
    } else {serde_json::from_str::<DescriptorSet>(&descriptors)?};
    Ok(descriptors)
}

//  pub struct State {
//      pub path: String,
//  //  store: SqliteStore,
//  //  cache: Cache,
//  //  client_uri: String,
//  //  wallet: Arc<Mutex<Wallet<SqliteDatabase>>>,
//  //  descriptors: DescriptorSet
//  }

//  impl State {
//      fn merr() -> Error {Error::error("State::refresh_dart", "Poisoned mutex")}
//      pub async fn new(path: &str, callback: impl Fn(String) -> DartFnFuture<String>) -> Result<Self, Error> {
//          //let store = SqliteStore::new()?;
//  //      if let Some(old_state) = store.get(b"state")? {
//  //          invoke(&callback, "set_state", std::str::from_utf8(&old_state)?).await?;
//  //      }
//  //      let descriptors = get_descriptors(&callback).await?;
//  //      invoke(&callback, "print", &serde_json::to_string(&descriptors)?).await?;

//          let db = SqliteDatabase::new(Path::new(&format!("{}/BDK/database", path)));
//          let wallet = Wallet::new(&descriptors.external, Some(&descriptors.internal), Network::Bitcoin, db)?;
//          let uri = "ssl://electrum.blockstream.info:50002".to_string();
//          let client = Client::new(&uri)?;

//          Ok(State{
//              path: format!("{}/STATE/store", path),
//  //          store,
//  //          cache: Cache::new_cache::<SqliteStore>(&format!("{}/STATE/cache", path), Some(600000))?,
//  //          client_uri: uri,
//  //          wallet: Arc::new(Mutex::new(wallet)),
//  //          descriptors
//          })
//      }

//      async fn refresh_price(&mut self, callback: impl Fn(String) -> DartFnFuture<String>) -> Result<(), Error> {
//          invoke(&callback, "print", "setting").await?;
//          loop {
//              let mut store = SqliteStore::new(&self.path)?;
//              invoke(&callback, "print", "set").await?;
//              store.set(b"test", &(store.get(b"test")?.map(|b| f64::from_le_bytes(b.try_into().unwrap())).unwrap_or(0.0) + 1.0).to_le_bytes())?;
//          }
//          Ok(())
//      }



//  //  async fn sync(&mut self) -> Result<(), Error> {
//  //      let blockchain = ElectrumBlockchain::from(Client::new(&self.client_uri)?);
//  //      self.wallet.lock().or(Err(Self::merr()))?.sync(&blockchain, )?;
//  //      Ok(())
//  //  }

//  //  async fn current_price(&mut self) -> Result<f64, Error> {
//  //      Ok(match self.cache.get(b"price")? {
//  //          Some(pb) => f64::from_le_bytes(pb.try_into().or(Err(Error::error("Prices.get_price", "price found but not le bytes of f64")))?),
//  //          None => {
//  //              let price = reqwest::get("https://api.coinbase.com/v2/prices/BTC-USD/buy").await?.json::<PriceRes>().await?.data.amount.parse::<f64>()?;
//  //              self.cache.set(b"price", &price.to_le_bytes())?;
//  //              price
//  //          }
//  //      })
//  //  }

//  //  async fn get_price(&mut self, timestamp: u64, callback: impl Fn(String) -> DartFnFuture<String>) -> Result<f64, Error> {
//  //      Ok(match self.store.get(&timestamp.to_le_bytes())? {
//  //          Some(price) => f64::from_le_bytes(price.try_into().or(Err(Error::error("Prices.get_price", "price found but not le bytes of f64")))?),
//  //          None => {
//  //              let error = Error::bad_request("Prices.get_price", "Invalid timestamp");
//  //              let base_url = "https://api.coinbase.com/v2/prices/BTC-USD/spot";
//  //              let date = DateTime::from_timestamp(timestamp as i64, 0).ok_or(error)?.format("%Y-%m-%d").to_string();
//  //              let url = format!("{}?date={}", base_url, date);
//  //              let spot_res: SpotRes = reqwest::get(&url).await?.json().await?;
//  //              let price = spot_res.data.amount.parse::<f64>()?;
//  //              self.store.set(&timestamp.to_le_bytes(), &price.to_le_bytes())?;
//  //              price
//  //          }
//  //      })
//  //  }

//  //  async fn refresh_dart(&mut self, callback: impl Fn(String) -> DartFnFuture<String>) -> Result<(), Error> {
//  //      let (wallet_transactions, balance) = {
//  //          let wallet = self.wallet.lock().or(Err(Self::merr()))?;
//  //          (wallet.list_transactions(true)?, wallet.get_balance()?)
//  //      };

//  //      let current_price = self.current_price().await?;
//  //      let btc = balance.get_total() as f64 / 100_000_000.0;
//  //      let mut transactions: Vec<Transaction> = Vec::new();
//  //      for tx in wallet_transactions {
//  //          let price = match tx.confirmation_time.as_ref() {
//  //              Some(ct) => self.get_price(ct.timestamp, &callback).await?,
//  //              None => current_price
//  //          };
//  //          let wallet = self.wallet.lock().or(Err(Self::merr()))?;
//  //          transactions.push(Transaction::from_details(tx, price, |s: &Script| {wallet.is_mine(s).unwrap_or(false)})?);
//  //      }
//  //      let state = DartState{
//  //          currentPrice: current_price,
//  //          btcBalance: btc,
//  //          usdBalance: ((current_price * btc) * 100.0).round() / 100.0,
//  //          transactions
//  //      };
//  //      self.store.set(b"state", &serde_json::to_vec(&state)?)?;
//  //      invoke(&callback, "set_state", &serde_json::to_string(&state)?).await?;
//  //      Ok(())
//  //  }

//  //  async fn handle_commands(&mut self, callback: impl Fn(String) -> DartFnFuture<String>) -> Result<(), Error> {
//  //      let res = invoke(&callback, "get_commands", "").await?;
//  //      let commands = serde_json::from_str::<Vec<RustCommand>>(&res)?;
//  //      for command in commands {
//  //          let result: Result<String, Error> = match command.method.as_str() {
//  //              "get_new_address" => {
//  //                  let wallet = self.wallet.lock().or(Err(Self::merr()))?;
//  //                  Ok(wallet.get_address(AddressIndex::New)?.address.to_string())
//  //              },
//  //              "break" => {
//  //                  return Err(Error::Exited("Break Requested".to_string()));
//  //              },
//  //              _ => {
//  //                  return Err(Error::bad_request("rust_start", &format!("Unknown method: {}", command.method)));
//  //              }
//  //          };
//  //          let data = result?;
//  //          let resp = RustResponse{uid: command.uid.to_string(), data};
//  //          invoke(&callback, "post_response", &serde_json::to_string(&resp)?).await?;
//  //      }
//  //      Ok(())
//  //  }
//  }

#[derive(Serialize, Deserialize)]
struct Data {
    markdown: String
}

//  async fn start_rust(path: String, callback: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send) -> Result<(), Error> {
//      let mut path = path;
//      path.pop();

//      let descriptors = get_descriptors(&callback).await?;

//      invoke(&callback, "print", "se").await?;

//      let path1 = path.clone();
//      let descriptors1 = descriptors.clone();
//      let wallet_sync = tokio::spawn(async move {
//          invoke(&callback, "print", "testo").await?;
//          let db = SqliteDatabase::new(Path::new(&format!("{}/BDK/database", path1)));
//          let wallet = Wallet::new(&descriptors1.external, Some(&descriptors1.internal), Network::Bitcoin, db)?;
//          let blockchain = ElectrumBlockchain::from(Client::new("ssl://electrum.blockstream.info:50002")?);
//          loop {wallet.sync(&blockchain, SyncOptions::default())?;}
//          Err::<(), Error>(Error::Exited("Wallet Sync Exited".to_string()))
//      });

//      let path2 = path.clone();
//      let price_fetch = tokio::spawn(async move {
//          let mut db = SqliteStore::new(&format!("{}/STATE/price", path2))?;
//          loop {
//              db.set(b"price", &reqwest::get("https://api.coinbase.com/v2/prices/BTC-USD/buy").await?.json::<PriceRes>().await?.data.amount.parse::<f64>()?.to_le_bytes())?;
//              thread::sleep(time::Duration::from_millis(600_000));
//          }
//          Err::<(), Error>(Error::Exited("Current Price Fetch Exited".to_string()))
//      });
//  //  let loop_path3 = path.clone();
//  //  tokio::spawn(async move {
//  //      loop {
//  //          let mut store = SqliteStore::new(&format!("{}/STATE/store", loop_path3))?;
//  //          store.set(b"test", &(store.get(b"test")?.map(|b| f64::from_le_bytes(b.try_into().unwrap())).unwrap_or(0.0) + 1.0).to_le_bytes())?;
//  //      }
//  //      Ok::<(), Error>(())
//  //  });
//  //  let loop_path4 = path.clone();
//  //  tokio::spawn(async move {
//  //      loop {
//  //          let mut store = SqliteStore::new(&format!("{}/STATE/store", loop_path4))?;
//  //          store.set(b"test", &(store.get(b"test")?.map(|b| f64::from_le_bytes(b.try_into().unwrap())).unwrap_or(0.0) + 1.0).to_le_bytes())?;
//  //      }
//  //      Ok::<(), Error>(())
//  //  });



//      //state.refresh_price(&callback).await?;
//      loop {
//          let mut store = SqliteStore::new(&format!("{}/STATE/store", path))?;
//          invoke(&callback, "print", &store.get(b"test")?.map(|b| f64::from_le_bytes(b.try_into().unwrap())).unwrap_or(0.2).to_string()).await?;
//        //state.refresh_dart(&callback).await?;
//        //state.handle_commands(&callback).await?;
//        //state.sync();
//      }

//      wallet_sync.await?;
//      price_fetch.await?;
//  }


//Sync takes 3-4 seconds and blocks wallet uses,
//Most data can be refreshed and recalculated regardless of wallet

//Create new address
//Create transaction
//Broad cast transaction

//Price



    //let mut prices = Prices::new(&format!("{}/PRICE", path))?;

//  let mut agent = Agent::new::<SqliteStore>(Some(&format!("{}/AGENT", path)), vec![Url::from_str("http://localhost:3000")?]).await?;
//  let res = agent.protocols_configure(true, ProtocolsConfigureOptions::new(None, SocialProtocol::get()?, None)).await?;
//  let res = agent.protocols_configure(true, ProtocolsConfigureOptions::new(None, ProfileProtocol::get()?, None)).await?;

//  let markdown = "# YOUR TITLE HERE\n\n\n- You can use markdown\n- Add a hero image to your story\n- Have fun!\n".to_string();
//  let data = Data{markdown};
//  let data = serde_json::to_string(&data).unwrap().as_bytes().to_vec();
//  let data_info = DataInfo::from_data(&data, &DataFormat::AppJson)?;
//  let protocol = Protocol::new(
//      ProtocolUri::from_str("https://areweweb5yet.com/protocols/social")?,
//      ProtocolPath::from_str("story")?,
//      None
//  );

//  let mut options = RecordsWriteOptions::default(protocol, data_info);
//  options.schema = Some(ProtocolUri::from_str("https://areweweb5yet.com/protocols/social/schemas/story").unwrap());
//  let res = agent.records_write(&data, true, options).await?;


//  let db = SqliteDatabase::new(Path::new(&format!("{}/BDK/database", path)));
//  let wallet = Wallet::new(&descriptors.external, Some(&descriptors.internal), Network::Bitcoin, db)?;
//  let sync_options = SyncOptions::default();
//  let client_uri = "ssl://electrum.blockstream.info:50002";
//  let client = Client::new(client_uri)?;
//  let blockchain = ElectrumBlockchain::from(Client::new(client_uri)?);
//  wallet.sync(&blockchain, sync_options)?;
//  invoke(&dartCallback, "synced", "").await?;
//  loop {

//      let res = invoke(&dartCallback, "get_commands", "").await?;
//      let commands = serde_json::from_str::<Vec<RustCommand>>(&res)?;
//      for command in commands {
//          //let resp = handle(&command, &dartCallback, &wallet).await?;
//          let result: Result<String, Error> = match command.method.as_str() {
//              "get_balance" => {
//                  let btc: f64 = wallet.get_balance()?.get_total() as f64 / 100_000_000.0;
//                  //let usd: f64 = ((prices.get_current_price().await? * btc) * 100.0).round() / 100.0;
//                  let usd = 9.3;
//                  Ok(serde_json::to_string(&Balance{btc, usd})?)
//              },
//              "get_home_transactions" => {
//                  Ok(serde_json::to_string(&wallet.list_transactions(false)?.into_iter().map(|txd| {
//                      let error = Error::bad_request("Prices.get_price", "Invalid timestamp");
//                      Ok(HomeTx {
//                          txid: txd.txid.to_string(),
//                          is_receive: txd.sent == 0,
//                          date: txd.confirmation_time.map(|dt| Ok::<String, Error>(DateTime::from_timestamp_millis(dt.timestamp as i64).ok_or(error)?.format("%Y-%m-%d").to_string())).transpose()?,
//                          amount: txd.received as i64 - txd.sent as i64
//                      })
//                  }).collect::<Result<Vec<HomeTx>, Error>>()?)?)
//              }
//              "messages" => {
//                  let messages = vec![Message {
//                      text: "my message i sent to stupid".to_string()
//                  }];
//                  Ok(serde_json::to_string(&messages)?)
//              },
//              "get_price" => {
//                  let amount = reqwest::get("https://api.coinbase.com/v2/prices/BTC-USD/buy").await?.json::<PriceRes>().await?.data.amount;
//                  Ok(amount)
//              },
//              "get_historical_price" => {
//                  let base_url = "https://api.coinbase.com/v2/prices/BTC-USD/spot";
//                  let date = chrono::Utc::today().format("%Y-%m-%d").to_string();
//                  let url = format!("{}?date={}", base_url, date);
//                  let spot_res: SpotRes = reqwest::get(&url).await?.json().await?;
//                  Ok(spot_res.data.amount)
//              },
//              "get_new_address" => {
//                  Ok(wallet.get_address(AddressIndex::New)?.address.to_string())
//              },
//              "check_address" => {
//                  let result = Address::from_str(&command.data).map(|a| 
//                      a.require_network(Network::Bitcoin).is_ok()
//                  ).unwrap_or(false);
//                  Ok(serde_json::to_string(&result)?) 
//              },
//              "get_transactions" => {
//                  let transactions = wallet.list_transactions(false)?.into_iter().map(|txd| {
//                  TransactionDetails{
//                      isReceived: txd.sent > 0,
//                      date: String,
//                      time: String,
//                      address: String,
//                      btcValueSent: f32,
//                      bitcoinPrice: Option<f32>,
//                      value: Option<f32>,
//                      fee: Option<f32>,
//                      prority: Option<bool>
//                  }
//                  //          receiver: None,
//          sender: None,
//          txid: serde_json::to_string(&details.txid)?,
//          net: (details.received as i64)-(details.sent as i64),
//          fee: details.fee,
//          timestamp: if details.confirmation_time.is_some() { Some(details.confirmation_time.unwrap().timestamp) } else { None },
//          raw: None

//                     

//                  }).collect::<Result<Vec<TransactionDetails>, Error>>()?;
//                  Ok(serde_json::to_string(&transactions)?)
//                },
//              "create_transaction" => {
//                  let input = serde_json::from_str::<CreateTransactionInput>(&command.data)?;
//                  invoke(&dartCallback, "print", "Json good").await?;
//                  let sats = input.sats;
//                  let address = Address::from_str(&input.address)?.require_network(Network::Bitcoin)?;
//                  let fee_rate: bdk::FeeRate = FeeRate::from_btc_per_kvb(blockchain.estimate_fee(input.block_target as usize)? as f32);
//                  
//                  let (mut psbt, tx_details) = {
//                      let mut builder = wallet.build_tx();
//                      builder.fee_rate(fee_rate);
//                      builder.add_recipient(address.script_pubkey(), sats);
//                      builder.finish()?
//                  };
//          
//                  let finalized = wallet.sign(&mut psbt, SignOptions::default())?;

//          
//                  let tx = psbt.clone().extract_tx();
//                  let mut stream: Vec<u8> = Vec::new();
//                  tx.consensus_encode(&mut stream)?;
//                  let raw = hex::encode(&stream);
//          
//                  let mut transaction: Transaction = Transaction::from_details(tx_details)?;
//                  transaction.raw = Some(raw);
//          
//                  Ok(serde_json::to_string(&transaction)?)
//              },
//              "broadcast_transaction" => {
//                  //let tx = serde_json::from_str::<bdk::bitcoin::Transaction>(&command.data)?;
//                  invoke(&dartCallback, "print", &format!("commandData: {}", &command.data)).await?;

//                  let mut reader = std::io::BufReader::new(command.data.as_bytes());
//                  let tx = bdk::bitcoin::Transaction::consensus_decode(&mut reader)?;
//                  Ok(serde_json::to_string(&client.transaction_broadcast(&tx)?)?)
//              },
//              "drop_descs" => {
//                  invoke(&dartCallback, "secure_set", &format!("{}{}{}", "descriptors", STORAGE_SPLIT, ""));
//                  Ok("Ok".to_string())
//              },

//              "break" => {
//                  return Err(Error::Exited("Break Requested".to_string()));
//              },
//              _ => {
//                  return Err(Error::bad_request("rust_start", &format!("Unknown method: {}", command.method)));
//              }
//          };
//          let data = result?;
//          let resp = RustResponse{uid: command.uid.to_string(), data};
//          invoke(&dartCallback, "post_response", &serde_json::to_string(&resp)?).await?;
//      }
//  }
//  Err(Error::Exited("Unknown".to_string()))
//}

async fn get_price(prices: &mut SqliteStore, timestamp: u64) -> Result<f64, Error> {
    Ok(match prices.get(&timestamp.to_le_bytes())? {
        Some(price) => f64::from_le_bytes(price.try_into().or(Err(Error::error("get_price", "Price not f64 bytes")))?),
        None => {
            let error = Error::bad_request("Prices.get_price", "Invalid timestamp");
            let base_url = "https://api.coinbase.com/v2/prices/BTC-USD/spot";
            let date = DateTime::from_timestamp(timestamp as i64, 0).ok_or(error)?.format("%Y-%m-%d").to_string();
            let url = format!("{}?date={}", base_url, date);
            let spot_res: SpotRes = reqwest::get(&url).await?.json().await?;
            let price = spot_res.data.amount.parse::<f64>()?;
            prices.set(&timestamp.to_le_bytes(), &price.to_le_bytes())?;
            price
        }
    })
}

pub async fn rustStart (
    path: String,
    callback: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send,
    callback3: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send,
    callback1: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send
) -> String {
    let err_catch = tokio::spawn(async move {
        let mut path = path;
        path.pop();

        //INIT
        let descriptors = get_descriptors(&callback).await?;
        let wallet = Wallet::new(&descriptors.external, Some(&descriptors.internal), Network::Bitcoin, SqliteDatabase::new(Path::new(&format!("{}/BDK/database", path))))?;
        let mut store = SqliteStore::new(PathBuf::from(&format!("{}/STATE/store", path)))?;
        if let Some(old_state) = store.get(b"state")? {
            invoke(&callback, "set_state", std::str::from_utf8(&old_state)?).await?;
        }
        store.set(b"new_address", &wallet.get_address(AddressIndex::New)?.address.to_string().as_bytes())?;
        invoke(&callback, "print", "se").await?;

        let path1 = path.clone();
        let descriptors1 = descriptors.clone();
        tokio::spawn(async move {
            let wallet = Wallet::new(&descriptors1.external, Some(&descriptors1.internal), Network::Bitcoin, SqliteDatabase::new(Path::new(&format!("{}/BDK/database", path1))))?;
            let blockchain = ElectrumBlockchain::from(Client::new("ssl://electrum.blockstream.info:50002")?);
            let mut init_sync = true;
            loop {
                wallet.sync(&blockchain, SyncOptions::default())?;
                if init_sync {invoke(&callback1, "synced", "").await?; init_sync = false;}
                thread::sleep(time::Duration::from_millis(250));
            }
            Err::<(), Error>(Error::Exited("Wallet Sync Exited".to_string()))
        });

        let path2 = path.clone();
        tokio::spawn(async move {
            let mut db = SqliteStore::new(PathBuf::from(&format!("{}/STATE/price", path2)))?;
            loop {
                db.set(b"price", &reqwest::get("https://api.coinbase.com/v2/prices/BTC-USD/buy").await?.json::<PriceRes>().await?.data.amount.parse::<f64>()?.to_le_bytes())?;
                thread::sleep(time::Duration::from_millis(600_000));
            }
            Err::<(), Error>(Error::Exited("Current Price Fetch Exited".to_string()))
        });
        let path3 = path.clone();
        let descriptors3 = descriptors.clone();
        tokio::spawn(async move {
            let mut store = SqliteStore::new(PathBuf::from(&format!("{}/STATE/store", path3)))?;
            let mut price = SqliteStore::new(PathBuf::from(&format!("{}/STATE/price", path3)))?;
            let wallet = Wallet::new(&descriptors3.external, Some(&descriptors3.internal), Network::Bitcoin, SqliteDatabase::new(Path::new(&format!("{}/BDK/database", path3))))?;
            loop {
                let wallet_transactions = wallet.list_transactions(true)?;
                let balance = wallet.get_balance()?;
                let current_price = price.get(b"price")?.map(|b| Ok::<f64, Error>(f64::from_le_bytes(b.try_into().or(Err(Error::error("Main", "Price not f64 bytes")))?))).unwrap_or(Ok(0.0))?;
                let btc = balance.get_total() as f64 / 1000_000_000.0;
                let mut transactions: Vec<Transaction> = Vec::new();
                for tx in wallet_transactions {
                    let price = match tx.confirmation_time.as_ref() {
                        Some(ct) => get_price(&mut price, ct.timestamp).await?,
                        None => current_price
                    };
                    transactions.push(Transaction::from_details(tx, price, |s: &Script| {wallet.is_mine(s).unwrap_or(false)})?);
                }
                let state = DartState{
                    currentPrice: current_price,
                    btcBalance: btc,
                    usdBalance: current_price * btc,
                    transactions
                };
                store.set(b"state", &serde_json::to_vec(&state)?)?;
                invoke(&callback3, "set_state", &serde_json::to_string(&state)?).await?;
                thread::sleep(time::Duration::from_millis(1000));
            }
            Err::<(), Error>(Error::Exited("Refresh Dart State Exited".to_string()))
        });

        loop {
            let res = invoke(&callback, "get_commands", "").await?;
            let commands = serde_json::from_str::<Vec<RustCommand>>(&res)?;
            for command in commands {
                let result: Result<String, Error> = match command.method.as_str() {
                    "get_new_address" => {
                        Ok(String::from_utf8(store.get(b"new_address")?.ok_or(Error::error("Main", "No new address"))?)?)
                    },
                    "break" => {
                        return Err(Error::Exited("Break Requested".to_string()));
                    },
                    _ => {
                        return Err(Error::bad_request("rust_start", &format!("Unknown method: {}", command.method)));
                    }
                };
                let data = result?;
                let resp = RustResponse{uid: command.uid.to_string(), data};
                invoke(&callback, "post_response", &serde_json::to_string(&resp)?).await?;

                //POST PROCESSES
                match command.method.as_str() {
                    "get_new_address" => {
                        store.set(b"new_address", &wallet.get_address(AddressIndex::New)?.address.to_string().as_bytes())?;
                    },
                    _ => {}
                }
            }
        }
        Err(Error::Exited("Main Exited".to_string()))
    });
    match err_catch.await {
        Ok(Ok(())) => "Ok".to_string(),
        Ok(Err(e)) => format!("Err: {:?}", e),
        Err(e) => format!("Err: {:?}", e)
    }
}




//  #[derive(Serialize, Deserialize, Debug)]
//  struct Message {
//      text: String,
//  }

//  // #[derive(Seserialize)]
//  struct Fees {
//      priority_fee: FeeRate,
//      standard_fee: FeeRate
//  }

//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct Transaction {
//      pub receiver: Option<String>,
//      pub sender: Option<String>,
//      pub txid: String,
//      pub net: i64,
//      pub fee: Option<u64>,
//      pub timestamp: Option<u64>, 
//      pub raw: Option<String>
//  }

//  impl Transaction {
//      fn from_details(details: TransactionDetails) -> Result<Self, Error> {
//          Ok(Transaction{
//              receiver: Some("some random address".to_string()),
//              sender: None,
//              txid: serde_json::to_string(&details.txid)?,
//              net: (details.received as i64)-(details.sent as i64),
//              fee: details.fee,
//              timestamp: if details.confirmation_time.is_some() { Some(details.confirmation_time.unwrap().timestamp) } else { None },
//              raw: None
//          })
//      }
//  }

//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct CreateTransactionInput {
//      pub address: String,
//      pub sats: u64,
//      pub block_target: u64
//  }




//async fn handle(command: &RustCommand, dartCallback: impl Fn(String) -> DartFnFuture<String>, wallet: &Wallet<Tree>) -> Result<RustResponse, Error> {
//    }



//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct Transaction {
//      pub receiver: Option<String>,
//      pub sender: Option<String>,
//      pub txid: String,
//      pub net: i64,
//      pub fee: Option<u64>,
//      pub timestamp: Option<u64>,
//      pub raw: Option<String>
//  }

//  fn from_details(details: TransactionDetails) -> Result<Transaction, Error> {
//      Ok(Transaction{
//          receiver: None,
//          sender: None,
//          txid: serde_json::to_string(&details.txid)?,
//          net: (details.received as i64)-(details.sent as i64),
//          fee: details.fee,
//          timestamp: if details.confirmation_time.is_some() { Some(details.confirmation_time.unwrap().timestamp) } else { None },
//          raw: None
//      })
//  }



//  pub struct Response{
//      pub status: i32,
//      pub message: String,
//  }

//  impl Response {
//      pub fn new(status: i32, message: String) -> Response {
//          Response{status, message}
//      }

//      pub fn bad_request(method: String) -> Response {
//          Response{status: 400, message: format!("Incorrect Arguments For Method({})", method)}
//      }

//      pub fn error(message: String) -> Response {
//          Response{status: 500, message}
//      }
//  }

//  //  fn generate_singlesig_descriptor() -> Result<String, Error> {
//  //  }

//  pub fn dropdb(path: String, descriptors: String) {
//      let descs: DescriptorSet = serde_json::from_str(&descriptors).unwrap();
//      let db = bdk::sled::open(path).unwrap().open_tree("wallet").unwrap();
//      //let db = SqliteDatabase::new(path);
//      let wallet = Wallet::new(&descs.external, Some(&descs.internal), Network::Bitcoin, db).unwrap();
//      //let _ = db.connection.close();
//      //db.clear().unwrap();
//      //db.drop_tree("wallet").unwrap();
//  }

//  fn get_database(db_path: String) -> Result<Tree, Error> {
//      //Ok(SqliteDatabase::new(db_path))
//      Ok(bdk::sled::open(db_path)?.open_tree("wallet")?)
//  }

//  fn get_wallet(db_path: String, descs: DescriptorSet) -> Result<Wallet<Tree>, Error> {
//      Ok(Wallet::new(&descs.external, Some(&descs.internal), Network::Bitcoin, get_database(db_path)?)?)
//  }

//  fn get_mnemonic(descs: DescriptorSet) -> Result<String, Error> {
//  //  let wallet = get_wallet(db_path, descs)?;
//  //  Ok(wallet.get_address(AddressIndex::New)?.address.to_string())
//      Ok("to_string".to_string())
//  }

//  fn get_new_address(db_path: String, descs: DescriptorSet) -> Result<String, Error> {
//      let wallet = get_wallet(db_path, descs)?;
//      Ok(wallet.get_address(AddressIndex::New)?.address.to_string())
//  }

//  fn get_balance(db_path: String, descs: DescriptorSet) -> Result<String, Error> {
//      let wallet = get_wallet(db_path, descs)?;
//      Ok(wallet.get_balance()?.get_total().to_string())
//      //Err(Error::OutOfBounds());
//  }

//  fn get_transactions(db_path: String, descs: DescriptorSet) -> Result<String, Error> {
//      let wallet = get_wallet(db_path, descs)?;
//      let transactions: Vec<Transaction> = wallet.list_transactions(false)?.into_iter().map(from_details).collect::<Result<Vec<Transaction>, Error>>()?;
//      Ok(serde_json::to_string(&transactions)?)
//  }


//  // fn create_transaction(sats: u64) -> Result<String, Error> {
//  fn create_transaction(db_path: String, descs: DescriptorSet, addr: Address, sats: u64) -> Result<String, Error> {
//      let wallet = get_wallet(db_path, descs)?;
//      let (mut psbt, tx_details) = {
//          let mut builder = wallet.build_tx();
//          builder.add_recipient(addr.script_pubkey(), sats);
//          builder.finish()?
//      };
//      let finalized = wallet.sign(&mut psbt, SignOptions::default())?;
//      if !finalized { return Err(Error::CouldNotSign());}

//      let tx = psbt.clone().extract_tx();
//      let mut stream: Vec<u8> = Vec::new();
//      tx.consensus_encode(&mut stream)?;
//      let raw = hex::encode(&stream);
//       
//      let mut transaction: Transaction = from_details(tx_details)?;
//      transaction.receiver = Some(addr.to_string());
//      transaction.raw = Some(raw);

//      Ok(serde_json::to_string(&transaction)?)
//  }

//  fn estimate_fees() -> Result<String, Error> {
//      let client = get_client()?;
//      let blockchain = ElectrumBlockchain::from(client);

//      let priority_target: usize = 1;

//      Ok(serde_json::to_string(&blockchain.estimate_fee(priority_target)?)?)}

//  fn broadcast_transaction(db_path: String, descs: DescriptorSet, tx: bdk::bitcoin::Transaction) -> Result<String, Error> {
//      let client = get_client()?;
//      Ok(serde_json::to_string(&client.transaction_broadcast(&tx)?)?)
//  }

//  fn get_client() -> Result<Client, Error> {
//      Ok(Client::new("ssl://electrum.blockstream.info:50002")?)
//  }

//  fn sync_wallet(db_path: String, descs: DescriptorSet) -> Result<String, Error>{
//      let wallet = get_wallet(db_path, descs)?;
//      let sync_options = SyncOptions::default(); 
//      let client = get_client()?;
//      let blockchain = ElectrumBlockchain::from(client);
//      wallet.sync(&blockchain, sync_options)?;
//      Ok("Finished".to_string())
//  }



//  #[derive(Deserialize)]
//  struct Spot {
//      amount: String,
//      currency: String,
//      base: String
//  }

//  #[derive(Deserialize)]
//  struct SpotRes {
//      data: Spot
//  }



//  // #[derive(Serialize)]
//  struct Fees {
//      priority_fee: FeeRate,
//      standard_fee: FeeRate
//  }

//  fn get_price() -> Result<String, Error> {
//      Ok(reqwest::blocking::get("https://api.coinbase.com/v2/prices/BTC-USD/buy")?.json::<PriceRes>()?.data.amount)
//  }

//  fn get_historical_price(date: String) -> Result<String, Error> {
//      let base_url = "https://api.coinbase.com/v2/prices/BTC-USD/spot";
//      let url = format!("{}?date={}", base_url, date);
//      
//      
//      Ok(reqwest::blocking::get(&url)?.json::<SpotRes>()?.data.amount)
//  }

//  fn handle_error(result: Result<String, Error>) -> Result<Response, Error> {
//      Ok(match result {
//          Ok(s) => Response::new(200, s),
//          Err(err) => Response::error(err.to_string())
//      })
//  }

//  //Returns a Response or an Error that occurred during the parsing of the request
//  fn handle_request(method: String, args: Vec<String>) -> Result<Response, Error> {
//      match method.as_str() {
//  //      "get_new_singlesig_descriptor" => {
//  //          handle_error(generate_singlesig_descriptor())
//  //      },
//          "sync_wallet" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              handle_error(sync_wallet(db_path, descs))
//          }
//          "get_price" => handle_error(get_price()),
//          "get_historical_price" => handle_error(get_historical_price(args.first().ok_or(Error::OutOfBounds())?.to_string())),
//          "throw_error" => Ok(Response::error("RustErrorMsg".to_string())),
//          "get_balance" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              handle_error(get_balance(db_path, descs))
//          },
//          "get_transactions" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              handle_error(get_transactions(db_path, descs))
//          },
//          "get_new_address" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              handle_error(get_new_address(db_path, descs))
//          },
//          "get_mnemonic" => {
//              let descs: DescriptorSet = serde_json::from_str(args.first().ok_or(Error::OutOfBounds())?)?;
//              handle_error(get_mnemonic(descs))
//          },
//          "check_address" => {
//              let addr = args.first().ok_or(Error::OutOfBounds())?;
//              match Address::from_str(addr) {
//                  Ok(address) => match address.require_network(Network::Bitcoin) {
//                      Ok(_) => Ok(Response::new(200, "true".to_owned())),
//                      Err(_) => Ok(Response::new(200, "false1".to_owned()))
//                  },
//                  Err(_) => Ok(Response::new(200, "false2".to_owned()))
//              }
//          },
//          "create_transaction" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              let addr: Address = Address::from_str(args.get(2).ok_or(Error::OutOfBounds())?)?.require_network(Network::Bitcoin)?;
//              let sats: u64 = args.get(3).ok_or(Error::OutOfBounds())?.parse()?;
//              handle_error(create_transaction(db_path, descs, addr, sats))
//          }
//          "broadcast_transaction" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              let mut stream: Vec<u8> = hex::decode(args.get(2).ok_or(Error::OutOfBounds())?)?;
//              let tx = bdk::bitcoin::Transaction::consensus_decode(&mut stream.as_slice())?;
//              handle_error(broadcast_transaction(db_path, descs, tx))
//          }
//          "estimate_fees" =>{
//              handle_error(estimate_fees())
//          }
//          unknown_method => Ok(Response::new(404, format!("Method Not Found({})", unknown_method)))
//      }
//  }

//  //  pub fn invoke(method: String, args: Vec<String>) -> Response {
//  //      handle_request(method.clone(), args).unwrap_or(Response::bad_request(method))
//  //  }
