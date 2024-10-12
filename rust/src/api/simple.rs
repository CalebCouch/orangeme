use super::Error;

use super::structs::{Platform, DartCommand, Storage, DartCallback};
use super::wallet::{Wallet, DescriptorSet, Seed};
//use super::callback::RustCallback;
use super::price::PriceGetter;
use super::state::{StateManager, State, Field};
use super::usb::UsbInfo;

use web5_rust::common::SqliteStore;
use web5_rust::common::traits::KeyValueStore;

use bdk::blockchain::Progress;
use bdk::SyncOptions;

use tokio::task::JoinHandle;

use flutter_rust_bridge::DartFnFuture;
use flutter_rust_bridge::frb;

use std::fs::File;
use std::str::FromStr;
use std::{thread, time};
use std::convert::TryInto;
use std::path::{Path, PathBuf};
//use std::sync::{Arc, Mutex};
//use std::sync::mpsc::channel;


//  use bdk::{TransactionDetails, KeychainKind, SyncOptions, SignOptions};
//  use bdk::bitcoin::consensus::{Encodable, Decodable};
//  use bdk::blockchain::electrum::ElectrumBlockchain;
//  use bdk::blockchain::esplora::EsploraBlockchain;
//  use bdk::bitcoin::blockdata::script::Script;
//  use bdk::bitcoin::bip32::ExtendedPrivKey;
//  use bdk::electrum_client::ElectrumApi;
//  use bdk::template::DescriptorTemplate;
//  use bdk::bitcoin::{Network, Address};
//  use serde::{Serialize, Deserialize};
//  use bdk::database::SqliteDatabase;
//  use bdk::database::MemoryDatabase;
//  use chrono::{Utc, Date, DateTime};
//  use bdk::electrum_client::Client;
//  use bdk::wallet::{AddressIndex};
//  use secp256k1::rand::RngCore;
//  use serde_json::to_string;
//  use bdk::template::Bip86;
//  use futures::future::ok;
//  use secp256k1::rand;
//  use bdk::sled::Tree;
//  use bdk::FeeRate;

//  const KVBYTE: f64 = 0.15;

//  //INTERNAL
//  #[derive(Serialize, Deserialize, Debug, Clone)]
//  pub struct DescriptorSet {
//      pub legacy_spending_external: String,
//      pub legacy_spending_internal: String,
//      pub premium_spending_internal: Option<String>,
//      pub premium_spending_external: Option<String>,
//      pub savings_internal: Option<String>,
//      pub savings_external: Option<String>
//  }

//  #[derive(Serialize, Deserialize, Debug, Clone)]
//  pub struct SeedSet {
//      pub legacy: Vec<u8>,
//      pub premium_mobile_spending: Option<Vec<u8>>,
//      pub premium_mobile_savings: Option<Vec<u8>>,
//      pub premium_desktop_spending: Option<Vec<u8>>,
//      pub premium_desktop_savings: Option<Vec<u8>>,
//  }

//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct DartCommand {
//      pub method: String,
//      pub data: String
//  }

//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct RustCommand {
//      pub uid: String,
//      pub method: String,
//      pub data: String
//  }

//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct RustResponse {
//      pub uid: String,
//      pub data: String
//  }

//  //PRICE FETCH
//  #[derive(Deserialize)]
//  struct PriceRes {data: Price}
//  #[derive(Deserialize)]
//  struct Price {amount: String, currency: String}
//  #[derive(Deserialize)]
//  struct Spot {amount: String, currency: String, base: String}
//  #[derive(Deserialize)]
//  struct SpotRes {
//      data: Option<Spot>,
//  }
//  //PRICE FETCH



//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct Transaction {
//      pub isReceive: bool,
//      pub sentAddress: Option<String>,
//      pub txid: String,
//      pub usd: f64,
//      pub btc: f64,
//      pub price: f64,
//      pub fee: f64,
//      pub date: Option<String>,
//      pub time: Option<String>
//  }

//  impl Transaction {
//      fn from_details(details: TransactionDetails, price: f64, isMine: impl Fn(&Script) -> bool) -> Result<Self, Error> {
//          let p = serde_json::to_string(&details)?;
//          let error = || Error::parse("Transaction", &p);
//          let is_send = details.sent > 0;
//          let transaction = details.transaction.ok_or(error())?;
//          let datetime = details.confirmation_time.map(|ct| Ok::<DateTime<Utc>, Error>(DateTime::from_timestamp(ct.timestamp as i64, 0).ok_or(error())?)).transpose()?;
//          let net = ((details.received as f64)-(details.sent as f64)) / SATS;
//          Ok(Transaction{
//              isReceive: !is_send,
//              sentAddress: if is_send {Some(Address::from_script(
//                  transaction.output.iter().map(
//                          |out| out.script_pubkey.as_script()
//                      ).find(
//                          |s| isMine(*s)
//                      ).ok_or(error())?,
//                  Network::Bitcoin
//              )?.to_string())} else {None},
//              txid: details.txid.to_string(),
//              btc: net,
//              usd: price * net,
//              fee: price * (details.fee.ok_or(error())? as f64 / SATS),
//              price,
//              date: datetime.map(|dt| dt.format("%Y-%m-%d").to_string()),
//              time: datetime.map(|dt| dt.format("%l:%M %p").to_string())
//          })
//      }
//  }




//  #[derive(Serialize, Deserialize, Debug, Clone, Default)]
//  pub struct Contact {
//      pub name: String,
//      pub did: String,
//      pub pfp: Option<String>,
//      pub abtme: Option<String>,
//  }

//  impl Contact {
//      fn from_details() -> Result<Self, Error> {
//          Ok(Contact {
//              name: "John Doe".to_string(),
//              did: "did:example:1234567890abcdef".to_string(),
//              pfp: Some("yeeeeeeeeeet".to_string()), 
//              abtme: Some("About me description".to_string()),
//          })
//      }
//  }

//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct Conversation {
//      pub messages: Vec<Message>,
//      pub members: Vec<Contact>,
//  }

//  impl Conversation {
//      fn from_details() -> Result<Self, Error> {
//          Ok(Conversation{
//              messages: vec![ Message { sender: Contact{name:"Josh Thayer".to_string(), did:"VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA".to_string(), pfp: None, abtme: None}, message: "What's the plan?".to_string(), date: "8/4/24".to_string(), time: "1:36 PM".to_string(), is_incoming: true },],
//              members: vec![Contact{name:"Josh Thayer".to_string(), did:"VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA".to_string(), pfp: None, abtme: None}],
//          })
//      }
//  }

//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct Message {
//      pub sender: Contact,
//      pub message: String,
//      pub date: String,
//      pub time: String,
//      pub is_incoming: bool,
//  }

//  impl Message {
//      fn from_details() -> Result<Self, Error> {
//          Ok(Message{
//              sender: Contact{name:"name".to_string(), did:"did".to_string(), pfp: None, abtme: None},
//              message: "".to_string(),
//              date: "".to_string(),
//              time: "".to_string(),
//              is_incoming: true,
//          })
//      }
//  }


//  #[derive(Serialize, Deserialize, Debug, Default)]
//  pub struct DartState {
//      pub currentPrice: f64,
//      pub usdBalance: f64,
//      pub btcBalance: f64,
//      pub transactions: Vec<Transaction>,
//      pub fees: Vec<f64>,
//      pub conversations: Vec<Conversation>,
//      pub users: Vec<Contact>,
//      pub personal: Contact,
//  }

//  async fn get_os(callback: impl Fn(String) -> DartFnFuture<String>) -> Result<String, Error>{
//      let os = invoke(&callback, "check_os", "").await?;
//      Ok(os)
//  }

//  async fn generate_seed() -> [u8; 64] {
//      let mut seed: [u8; 64] = [0; 64];
//      rand::thread_rng().fill_bytes(&mut seed);
//      seed
//  }

//  async fn generate_legacy_descriptor(callback: impl Fn(String) -> DartFnFuture<String>, os: String) -> Result<DescriptorSet, Error>{
//      let mut seed = generate_seed().await;
//      invoke(&callback, "print", &serde_json::to_string(&seed.to_vec())?);
//      let action = if os == "IOS"{
//          "ios_set"
//      }
//      else if os == "Android"{
//          "android_set"
//      }
//      else{
//          "unknown"
//      };
//      let seed_set = SeedSet{legacy: seed.to_vec(), premium_desktop_savings: None, premium_desktop_spending: None, premium_mobile_savings: None, premium_mobile_spending: None};
//      let seed_set_json = serde_json::to_string(&seed_set)?;
//      invoke(&callback, action, &format!("{}{}{}", "seed_set", STORAGE_SPLIT, seed_set_json)).await?;
//      let xpriv = ExtendedPrivKey::new_master(Network::Bitcoin, &seed)?;
//      let ex_desc = Bip86(xpriv, KeychainKind::External).build(Network::Bitcoin)?;
//      let external = ex_desc.0.to_string_with_secret(&ex_desc.1);
//      let in_desc = Bip86(xpriv, KeychainKind::Internal).build(Network::Bitcoin)?;
//      let internal = in_desc.0.to_string_with_secret(&in_desc.1);
//      let desc_set = DescriptorSet{legacy_spending_external:external, legacy_spending_internal:internal, premium_spending_external:None, premium_spending_internal:None, savings_external:None, savings_internal:None};
//      invoke(&callback, action, &format!("{}{}{}", "descriptors", STORAGE_SPLIT, &serde_json::to_string(&desc_set)?)).await?;
//      return Ok(desc_set)
//  }

//  async fn get_descriptors(callback: impl Fn(String) -> DartFnFuture<String>) -> Result<DescriptorSet, Error> {
//      let os = get_os(&callback).await?;
//      let descriptors: String;
//      match os.as_str() {
//          "IOS" => {
//              descriptors = invoke(&callback, "ios_get", "descriptors").await?;
//              if descriptors.is_empty() {
//              let set = generate_legacy_descriptor(&callback, os).await?;
//              Ok(set)
//              } else {Ok(serde_json::from_str::<DescriptorSet>(&descriptors)?)}
//          }
//          "Android" =>{
//              descriptors = invoke(&callback, "android_get", "descriptors").await?;
//              invoke(&callback, "print", &descriptors).await?;
//              if descriptors.is_empty() {
//              let set = generate_legacy_descriptor(&callback, os).await?;
//              Ok(set)
//              } else {Ok(serde_json::from_str::<DescriptorSet>(&descriptors)?)}
//          }
//          "Linux" | "Windows" | "MacOS" => {
//              //TODO may need different get logic
//              descriptors = invoke(&callback, "android_get", "descriptors").await?;
//              let descriptors = serde_json::from_str::<DescriptorSet>(&descriptors)?;
//              Ok(descriptors)
//          }
//          _ => {
//              return Err(Error::Exited("Unsupported OS".to_string()));
//          }
//      }
//  }

//  #[derive(Serialize, Deserialize)]
//  struct Data {
//      markdown: String
//  }


//  async fn get_price(callback: impl Fn(String) -> DartFnFuture<String>, prices: &mut SqliteStore, timestamp: u64) -> Result<f64, Error> {
//      Ok(match prices.get(&timestamp.to_le_bytes())? {
//          Some(price) => f64::from_le_bytes(price.try_into().or(Err(Error::err("get_price", "Price not f64 bytes")))?),
//          None => {
//              //invoke(&callback, "print", "get_price:NONE").await?;
//              let error = Error::bad_request("Prices.get_price", "Invalid timestamp");
//              let base_url = "https://api.coinbase.com/v2/prices/BTC-USD/spot";
//              let date = DateTime::from_timestamp(timestamp as i64, 0).ok_or(error)?.format("%Y-%m-%d").to_string();
//              let url = format!("{}?date={}", base_url, date);
//              //invoke(&callback, "print", &format!("get_price:PRE{}", url)).await?;
//              let reqwest = reqwest::get(&url).await?;
//              //invoke(&callback, "print", "reqwest").await?;
//              
//              let value: serde_json::Value = reqwest.json().await?;
//              let spot_res: SpotRes = serde_json::from_value(value.clone())?;
//              
//              //let spot_res: SpotRes = reqwest.json().await?;
//              let price = spot_res.data.ok_or(Error::err("Fetching price from coinbases api", &serde_json::to_string(&value)?))?.amount.parse::<f64>()?;
//              //invoke(&callback, "print", "xyzj").await?;
//              prices.set(&timestamp.to_le_bytes(), &price.to_le_bytes())?;
//              price
//          }
//      })
//  }

//  async fn sync_thread(callback: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send, wallet_path: PathBuf, descriptors: DescriptorSet, client_uri: String) -> Result<(), Error> {
//      let legacy_spending_wallet = Wallet::new(&descriptors.legacy_spending_external, Some(&descriptors.legacy_spending_internal), Network::Bitcoin, SqliteDatabase::new(wallet_path.join("bdk.db")))?;
//      let blockchain = ElectrumBlockchain::from(Client::new(&client_uri)?);
//      let mut init_sync = true;
//      loop {
//          legacy_spending_wallet.sync(&blockchain, SyncOptions::default())?;
//          if init_sync {invoke(&callback, "synced", "").await?; init_sync = false;}
//          thread::sleep(time::Duration::from_millis(250));
//      }
//      Err(Error::Exited("Wallet Sync Exited".to_string()))
//  }

//  async fn price_thread(callback: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send, price_path: PathBuf) -> Result<(), Error> {
//      let mut price = SqliteStore::new(price_path)?;
//      loop {
//          price.set(b"price", &reqwest::get("https://api.coinbase.com/v2/prices/BTC-USD/buy").await?.json::<PriceRes>().await?.data.amount.parse::<f64>()?.to_le_bytes())?;
//          thread::sleep(time::Duration::from_millis(600_000));
//      }
//      Err(Error::Exited("Current Price Fetch Exited".to_string()))
//  }

//  async fn state_thread(callback: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send, wallet_path: PathBuf, store_path: PathBuf, price_path: PathBuf, descriptors: DescriptorSet, client_uri: String) -> Result<(), Error> {
//      //invoke(&callback, "print", "a").await?;
//      let mut store = SqliteStore::new(store_path)?;
//      let mut price = SqliteStore::new(price_path)?;
//      let legacy_spending_wallet = Wallet::new(&descriptors.legacy_spending_external, Some(&descriptors.legacy_spending_internal), Network::Bitcoin, SqliteDatabase::new(wallet_path.join("bdk.db")))?;
//      let blockchain = ElectrumBlockchain::from(Client::new(&client_uri)?);
//      loop {
//         //invoke(&callback, "print", "b").await?;
//         // invoke(&callback, "print", "State Thread Looping").await?;
//          let wallet_transactions = legacy_spending_wallet.list_transactions(true)?;
//          let balance = legacy_spending_wallet.get_balance()?;
//          let current_price = price.get(b"price")?.map(|b| Ok::<f64, Error>(f64::from_le_bytes(b.try_into().or(Err(Error::err("Main", "Price not f64 bytes")))?))).unwrap_or(Ok(0.0))?;
//          let btc = balance.get_total() as f64 / SATS;
//          let mut transactions: Vec<Transaction> = Vec::new();

//          let josh_thayer = Contact{name:"Josh Thayer".to_string(), did:"Y7yOvxxua4EsGdsFvhIuAC4sDjc7judq".to_string(), pfp: Some("assets/images/josh_thayer.png".to_string()), abtme: None};
//          let jw_weatherman = Contact{name:"JW Weatherman".to_string(), did:"VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA".to_string(), pfp: Some("assets/images/panda.jpeg".to_string()), abtme: None};
//          let ella_couch = Contact{name: "Ella Couch".to_string(), did: "62iDUrvk5xfUN4UccYd9sfxiQ0PCbMNo".to_string(), pfp: Some("assets/images/cat.jpg".to_string()), abtme: None};
//          let chris_slaughter = Contact {name: "Chris Slaughter".to_string(),did: "XXr4LjMCNG4xgwe0z141IDV4f3g4jr5n".to_string(),pfp: None, abtme: None,};
//          let josh_thayer_alt = Contact{name:"Josh Thayer Alt".to_string(), did:"eCKCHvzJfQn277bHxuW6VDsFXHJu820h".to_string(), pfp: Some("assets/images/josh_thayer.png".to_string()), abtme: None};
//          let jw_weatherman_alt = Contact{name:"JW Weatherman Alt".to_string(), did:"xj74clpteEvSzdoAPyLTkLVlgyZ08iD2".to_string(), pfp: Some("assets/images/panda.jpeg".to_string()), abtme: None};
//          let ella_couch_alt = Contact{name: "Ella Couch Alt".to_string(), did: "yuRYAS3KeaBeUXD4zkRbfmoj0PL0LgW9".to_string(), pfp: Some("assets/images/cat.jpg".to_string()), abtme: None};
//          let chris_slaughter_alt = Contact {name: "Chris Slaughter Alt".to_string(),did: "4r32wmOHriTmZ2cMnYtRvdBz6yNHwnKg".to_string(),pfp: None, abtme: None,};
//          let conversations: Vec<Conversation> = vec![
//              Conversation {
//                  messages: vec![
//                      Message { sender: josh_thayer.clone(), message: "What's the plan?".to_string(), date: "8/4/24".to_string(), time: "1:36 PM".to_string(), is_incoming: true },
//                      Message { sender: ella_couch.clone(), message: "I'm going to send you guys invites through email later this week".to_string(), date: "8/4/24".to_string(), time: "1:37 PM".to_string(), is_incoming: false },
//                      Message { sender: josh_thayer.clone(), message: "I guess we can".to_string(), date: "8/4/24".to_string(), time: "1:38 PM".to_string(), is_incoming: true },
//                      Message { sender: josh_thayer.clone(), message: "Keep me posted and I will update the schedule book".to_string(), date: "8/4/24".to_string(), time: "1:39 PM".to_string(), is_incoming: true },
//                  ],
//                  members: vec![josh_thayer.clone()]
//              },
//              Conversation {
//                  messages: vec![
//                      Message { sender: josh_thayer.clone(), message: "What's the plan?".to_string(), date: "8/4/24".to_string(), time: "1:36 PM".to_string(), is_incoming: true },
//                      Message { sender: josh_thayer.clone(), message: "I'm going to send you guys invites through email later this week".to_string(), date: "8/4/24".to_string(), time: "1:36 PM".to_string(), is_incoming: true },
//                      Message { sender: josh_thayer.clone(), message: "I guess we can".to_string(), date: "8/4/24".to_string(), time: "1:39 PM".to_string(), is_incoming: true },
//                      Message { sender: ella_couch.clone(), message: "Keep me posted and I will update the schedule book".to_string(), date: "8/4/24".to_string(), time: "1:39 PM".to_string(), is_incoming: false },
//                      Message { sender: josh_thayer.clone(), message: "What's the plan?".to_string(), date: "8/4/24".to_string(), time: "1:40 PM".to_string(), is_incoming: true },
//                      Message { sender: chris_slaughter.clone(), message: "I'm going to send you guys invites through email later this week".to_string(), date: "8/4/24".to_string(), time: "1:45 PM".to_string(), is_incoming: true },
//                      Message { sender: chris_slaughter.clone(), message: "I guess we can".to_string(), date: "8/4/24".to_string(), time: "1:45 PM".to_string(), is_incoming: true },
//                      Message { sender: ella_couch.clone(), message: "Keep me posted and I will update the schedule book".to_string(), date: "8/4/24".to_string(), time: "1:45 PM".to_string(), is_incoming: false },
//                  ],
//                  members: vec![josh_thayer.clone(), chris_slaughter.clone(), ella_couch.clone()]
//              }
//          ];
//         //invoke(&callback, "print", "c").await?;
//          let users: Vec<Contact> = vec![josh_thayer.clone(), ella_couch.clone(), chris_slaughter.clone(), jw_weatherman.clone(), josh_thayer_alt.clone(), ella_couch_alt.clone(), chris_slaughter_alt.clone(), jw_weatherman_alt.clone()];

//          let personal: Contact = ella_couch.clone();

//          for tx in wallet_transactions {
//             // invoke(&callback, "print", "tx a").await?;
//              let price = match tx.confirmation_time.as_ref() {
//                  Some(ct) => get_price(&callback, &mut price, ct.timestamp).await?,
//                  None => current_price
//              };
//             // invoke(&callback, "print", "tx c").await?;
//              transactions.push(Transaction::from_details(tx, price, |s: &Script| {legacy_spending_wallet.is_mine(s).unwrap_or(false)})?);
//          }

//          let fees = vec![current_price * (blockchain.estimate_fee(3)? * KVBYTE), current_price * (blockchain.estimate_fee(1)? * KVBYTE)];
//          let state = DartState{
//              currentPrice: current_price,
//              btcBalance: btc,
//              usdBalance: current_price * btc,
//              transactions,
//              fees,
//              conversations,
//              users,
//              personal,
//          };
//         // invoke(&callback, "print", "d").await?;
//          store.set(b"state", &serde_json::to_vec(&state)?)?;
//          invoke(&callback, "set_state", &serde_json::to_string(&state)?).await?;
//          thread::sleep(time::Duration::from_millis(1000));
//      }
//      invoke(&callback, "print", "e").await?;
//      Err(Error::Exited(format!("Refresh Dart State Exited")))
//  }

//  async fn command_thread(callback: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send, wallet_path: PathBuf, store_path: PathBuf, price_path: PathBuf, descriptors: DescriptorSet, client_uri: String) -> Result<(), Error> {
//      let legacy_spending_wallet = Wallet::new(&descriptors.legacy_spending_external, Some(&descriptors.legacy_spending_internal), Network::Bitcoin, SqliteDatabase::new(wallet_path.join("bdk.db")))?;
//      let blockchain = ElectrumBlockchain::from(Client::new(&client_uri)?);
//      let mut store = SqliteStore::new(store_path.clone())?;
//      let price = SqliteStore::new(price_path.clone())?;
//      let client = Client::new(&client_uri)?;
//      loop {
//          let res = invoke(&callback, "get_commands", "").await?;
//          let commands = serde_json::from_str::<Vec<RustCommand>>(&res)?;
//          for command in commands {
//              let result: Result<String, Error> = match command.method.as_str() {
//                  "get_new_address" => {
//                      Ok(String::from_utf8(store.get(b"new_address")?.ok_or(Error::err("Main.get_new_address", "No new address"))?)?)
//                  },
//                  "check_address" => {
//                      Ok(Address::from_str(&command.data).map(|a|
//                          a.require_network(Network::Bitcoin).is_ok()
//                      ).unwrap_or(false).to_string())
//                  },
//                  "create_legacy_transaction" => {
//                      let ec = "Main.create_transaction";
//                      let error = || Error::bad_request(ec, "Invalid parameters");

//                      invoke(&callback, "print", &format!("split {}", command.data.clone())).await?;
//                      let split: Vec<&str> = command.data.split("|").collect();
//                      let address = Address::from_str(split.first().ok_or(error())?)?.require_network(Network::Bitcoin)?;
//                      let amount = (f64::from_str(split.get(1).ok_or(error())?)? * SATS) as u64;
//                      let priority = u8::from_str(split.get(2).ok_or(error())?)? as u8;
//                      let price_error = || Error::not_found(ec, "Cannot get price");
//                      let current_price = f64::from_le_bytes(price.get(b"price")?.ok_or(price_error())?.try_into().or(Err(price_error()))?);
//                      let is_mine = |s: &Script| legacy_spending_wallet.is_mine(s).unwrap_or(false);
//                      invoke(&callback, "print", &format!("amount: {}", amount)).await?;
//                      let fees = vec![blockchain.estimate_fee(3)?, blockchain.estimate_fee(1)?];
//                      let (mut psbt, mut tx_details) = {
//                          let mut builder = legacy_spending_wallet.build_tx();
//                          builder.add_recipient(address.script_pubkey(), amount);
//                          builder.fee_rate(FeeRate::from_btc_per_kvb(fees[priority as usize] as f32));
//                          builder.finish()?
//                      };
//                      let finalized = legacy_spending_wallet.sign(&mut psbt, SignOptions::default())?;
//                      if !finalized { return Err(Error::err(ec, "Could not sign std tx"));}

//                      let tx = psbt.clone().extract_tx();
//                      let mut stream: Vec<u8> = Vec::new();
//                      tx.consensus_encode(&mut stream)?;
//                      store.set(&tx_details.txid.to_string().as_bytes(), &stream)?;

//                      tx_details.transaction = Some(tx);
//                      let tx = Transaction::from_details(tx_details, current_price, |s: &Script| {legacy_spending_wallet.is_mine(s).unwrap_or(false)})?;

//                      Ok(serde_json::to_string(&tx)?)
//                  },
//                  "broadcast_transaction" => {
//                      let ec = "Main.broadcast_transaction";
//                      let error = || Error::bad_request(ec, "Invalid parameters");

//                      let stream = store.get(&command.data.as_bytes())?.ok_or(error())?;
//                      let tx = bdk::bitcoin::Transaction::consensus_decode(&mut stream.as_slice())?;
//                      client.transaction_broadcast(&tx)?;
//                      Ok("Ok".to_string())
//                  },
//                  "break" => {
//                      return Err(Error::Exited("Break Requested".to_string()));
//                  },
//                  _ => {
//                      return Err(Error::bad_request("rust_start", &format!("Unknown method: {}", command.method)));
//                  }
//              };
//              let data = result?;
//              let resp = RustResponse{uid: command.uid.to_string(), data};
//              invoke(&callback, "post_response", &serde_json::to_string(&resp)?).await?;

//              //POST PROCESSES
//              match command.method.as_str() {
//                  "get_new_address" => {
//                      store.set(b"new_address", &legacy_spending_wallet.get_address(AddressIndex::New)?.address.to_string().as_bytes())?;
//                  },
//                  _ => {}
//              }
//          }
//      }
//      Err(Error::Exited("Main Exited".to_string()))
//  }

//  async fn flatten(handle: JoinHandle<Result<(), Error>>) -> Result<(), Error> {
//      match handle.await {
//          Ok(Ok(o)) => Ok(o),
//          Ok(Err(err)) => Err(err),
//          Err(e) => match e.try_into_panic() {
//              Ok(panic) => match panic.downcast_ref::<Box<dyn Send + 'static + std::fmt::Debug>>() {
//                  Some(p) => Err(Error::Exited(format!("{:?}", p))),
//                  None => match panic.downcast_ref::<Box<dyn Send + 'static + std::fmt::Display>>() {
//                      Some(p) => Err(Error::Exited(p.to_string())),
//                      None => Err(Error::Exited(format!("Cannot convert panic with type id {:?} to string via Debug or Display", panic.type_id()))),
//                  }
//              },
//              Err(e) => Err(Error::Exited(e.to_string()))
//          }
//      }
//  }

//  fn handle(handle: JoinHandle) -> Result<(), Error> {
//      match handle.block_on() {
//          Ok(Ok(o)) => Ok(o),
//          Ok(Err(err)) => Err(err),
//          Err(e) => match e.try_into_panic() {
//              Ok(panic) => match panic.downcast_ref::<Box<dyn Send + 'static + std::fmt::Debug>>() {
//                  Some(p) => Err(Error::Exited(format!("{:?}", p))),
//                  None => match panic.downcast_ref::<Box<dyn Send + 'static + std::fmt::Display>>() {
//                      Some(p) => Err(Error::Exited(p.to_string())),
//                      None => Err(Error::Exited(format!("Cannot convert panic with type id {:?} to string via Debug or Display", panic.type_id()))),
//                  }
//              },
//              Err(e) => Err(Error::Exited(e.to_string()))
//          }
//      }
//  }

//  fn spawn<T>(task: T) -> Result<JoinHandle<Result<(), Error>>, Error>
//      where
//          T: std::future::Future<Output = Result<(), Error>> + Send + 'static
//  {
//      Ok(tokio::runtime::Builder::new_multi_thread()
//      .enable_all()
//      .build()?
//      .spawn(task))
//  }

async fn spawn<T>(task: T) -> Result<(), Error>
    where
        T: std::future::Future<Output = Result<(), Error>> + Send + 'static
{
    match tokio::spawn(task).await {
        Ok(Ok(o)) => Ok(o),
        Ok(Err(err)) => Err(err),
        Err(e) => match e.try_into_panic() {
            Ok(panic) => match panic.downcast_ref::<Box<dyn Send + 'static + std::fmt::Debug>>() {
                Some(p) => Err(Error::Exited(format!("{:?}", p))),
                None => match panic.downcast_ref::<Box<dyn Send + 'static + std::fmt::Display>>() {
                    Some(p) => Err(Error::Exited(p.to_string())),
                    None => Err(Error::Exited(format!("Cannot convert panic with type id {:?} to string via Debug or Display", panic.type_id()))),
                }
            },
            Err(e) => Err(Error::Exited(e.to_string()))
        }
    }
}

async fn async_rust (
    path: String,
    platform: String,
    thread: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send,
) -> Result<(), Error> {
    let mut dart_callback = DartCallback::new();
    dart_callback.add_thread(thread);
    let path = PathBuf::from(&path);
    let mut state = State::new::<SqliteStore>(path.clone())?;
    state.set(Field::Path, &path)?;
    let platform = Platform::from_str(&platform)?;

    let storage = Storage::new(dart_callback.clone());

    let mut wallet = if !platform.is_desktop() {
         let seed: Seed = if let Some(seed) = storage.get("legacy_seed").await? {
            serde_json::from_str(&seed)?
        } else {
            let seed = Seed::new();
            storage.set("legacy_seed", &serde_json::to_string(&seed)?).await?;
            seed
        };
        let descriptors = DescriptorSet::from_seed(&seed)?;
        dart_callback.call("print", &descriptors.internal).await?;
        state.set(Field::DescriptorSet, &descriptors)?;

        Some(Wallet::new(
            descriptors,
            path.clone()
        )?)
    } else {None};

    let mut state_thread1 = state.clone();
    let mut state_thread2 = state.clone();

    tokio::try_join!(
        spawn(async move {loop {
            let connected = reqwest::get("https://google.com").await.is_ok();
            state_thread1.set(Field::Internet, &connected)?;
            thread::sleep(time::Duration::from_millis(1000));
        }; Err::<(), Error>(Error::Exited("Internet Check".to_string()))}),
        spawn(async move {loop {
            state_thread2.set(Field::Price, &PriceGetter::get(None).await?)?;
            thread::sleep(time::Duration::from_millis(600_000));
        }; Err::<(), Error>(Error::Exited("Price Update".to_string()))}),
        spawn(async move {
            if platform.is_desktop() {
                let mut usb_info: UsbInfo = UsbInfo::new(&platform)?;
                loop {
                    if let Some(device_path) = usb_info.detect_new_device_path(&platform)? {
                        // Convert Option<PathBuf> to String safely, TODO update state here
                        let device_path_str = device_path.to_string_lossy().into_owned();
                        // Pass the string to the invoke function
                        dart_callback.call("print", &device_path_str).await?;
                    }
                    thread::sleep(time::Duration::from_millis(1_000));
                };
                Err::<(), Error>(Error::Exited("Usb Detection".to_string()))
            } else {Ok(())}
        }),

        spawn(async move {
            if let Some(mut wallet) = wallet {
                loop {
                    wallet.sync().await?;
                    thread::sleep(time::Duration::from_millis(1000));
                }
                Err::<(), Error>(Error::Exited("Wallet Sync".to_string()))
            } else {Ok(())}
        }),
    )?;
    Ok(())
}

pub async fn ruststart (
    path: String,
    platform: String,
    thread: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send,
) -> String {
    match async_rust(path, platform, thread).await {
        Ok(()) => "OK".to_string(),
        Err(e) => e.to_string()
    }
}


//  let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).unwrap();
//  let barrier = state.get::<f64>(Field::Price).unwrap()+10000.0;
//  loop {
//      let p = state.get::<f64>(Field::Price).unwrap();
//      if p > barrier {return "Hi".to_string();}
//      state.set(Field::Price, &(p+1.0)).unwrap();
//      thread::sleep(time::Duration::from_millis(10));
//  }



#[frb(sync)]
pub fn getstate(path: String, name: String) -> String {
    let result: Result<String, Error> = (move || {
        StateManager::new(State::new::<SqliteStore>(PathBuf::from(&path))?).get(&name)
    })();
    match result {
        Ok(s) => s,
        Err(e) => format!("Error: {}", e)
    }
}
