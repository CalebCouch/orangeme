use super::Error;


//Test
//  use simple_database::{KeyValueStore, SqliteStore};
//  use flutter_rust_bridge::frb;
//  use std::convert::TryInto;
//  use std::path::PathBuf;

//  pub async fn getstate(name: String, path: String) -> String {
//      let state = SqliteStore::new(PathBuf::from(&path).join("TEST")).await.unwrap();
//      let count = state.get(b"test").await.unwrap().map(|b| u32::from_le_bytes(b.try_into().unwrap())).unwrap_or_default();
//      //state.set(b"test", &(count+1).to_le_bytes()).await.unwrap();
//      format!("{{\"count\": {}}}", count)
//  }

pub use super::state::{Page, Field};

use super::structs::{Platform, DartCommand, Storage, DartCallback, Profile};
use super::wallet::{Wallet, DescriptorSet, Seed, Transaction};
use super::price::PriceGetter;
use super::state::{StateManager, State};
use super::usb::UsbInfo;

use simple_database::KeyValueStore;
use simple_database::SqliteStore;
use simple_database::database::{FiltersBuilder, IndexBuilder, Filter};

use bdk::bitcoin::{Network, Address};
use bdk::database::SqliteDatabase;
use bdk::blockchain::electrum::ElectrumBlockchain;
use bdk::electrum_client::ElectrumApi;
use bdk::FeeRate;
use bdk::SignOptions;
use bdk::blockchain::Progress;
use bdk::blockchain::Blockchain;
use bdk::SyncOptions;

use tokio::task::JoinHandle;

use flutter_rust_bridge::DartFnFuture;
use flutter_rust_bridge::frb;

use std::fs::File;
use std::str::FromStr;
use std::{thread, time};
use std::convert::TryInto;
use std::path::{Path, PathBuf};

use serde::{Serialize, Deserialize};

use chrono::NaiveDate;
use chrono::Datelike;
use chrono::Duration;
use chrono::Local;

use crate::api::state::Conversation;

use web5_rust::dids::{DhtDocument, Identity};
use web5_rust::{Record};
use super::protocols::Protocols;

use log::info;

const SATS: u64 = 100_000_000;
const CLIENT_URI: &str = "ssl://electrum.blockstream.info:50002";

use reqwest::Client;


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

async fn internet_thread(mut state: State) -> Result<(), Error> {
    let client = Client::new();

    loop {
        let connected = client.get("https://google.com")
            .send().await
            .map(|response| response.status().is_success())
            .unwrap_or(false);

        if !connected { panic!("Internet connection failed") };
        state.set(Field::Internet, &connected).await?;
        thread::sleep(time::Duration::from_millis(1000));
    }
}

async fn price_thread(mut state: State) -> Result<(), Error> {
    loop {
        state.set(Field::Price, &PriceGetter::get(None).await?).await?;
        thread::sleep(time::Duration::from_millis(2_000));
    }
    Err::<(), Error>(Error::Exited("Price Update".to_string()))
}

async fn wallet_thread(mut state: State, platform: Platform, descriptors: DescriptorSet, path: PathBuf) -> Result<(), Error> {
    if !platform.is_desktop() {
        let mut wallet = Wallet::new(descriptors, path, state)?;
        loop {
            wallet.sync().await?;
            thread::sleep(time::Duration::from_millis(1_000));
        }
        Err(Error::Exited("Wallet Sync".to_string()))
    } else {Ok(())}
}

//  async fn web5_thread(mut state: State, platform: Platform, id: Identity) -> Result<(), Error> {
//      info!("Start Web5 init");
//      if !platform.is_desktop() {
//          let mut wallet = web5_rust::Wallet::new(id, None, None);
//          let agent_key = wallet.get_agent_key(&Protocols::rooms_protocol()).await?;
//          let agent = web5_rust::Agent::new(agent_key, Protocols::get(), None, None);
//          let tenant = agent.tenant().clone();
//          let profile = if let Some(p) = agent.public_read(FiltersBuilder::build(vec![
//              ("author", Filter::equal(tenant.to_string())),
//              ("type", Filter::equal("profile"))]
//          ), None, None).await?.first() {
//              let profile = serde_json::from_slice::<Profile>(&p.1.payload)?;
//              state.set(Field::Profile, &profile)?;
//              profile
//          } else {
//              let index = IndexBuilder::build(vec![("type", "profile")]);
//              let profile = Profile::new("Default Name".to_string(), tenant, None, None);
//              let record = Record::new(None, &Protocols::profile(), serde_json::to_vec(&profile)?);
//              agent.public_create(record, index, None).await?;
//              state.set(Field::Profile, &profile).await?;
//              profile
//          };
//          info!("Finished Web5 init");
//          loop {
//              info!("Web5 scan");
//            //agent.scan().await?;
//            //thread::sleep(time::Duration::from_millis(1_000));
//          }
//          Err(Error::Exited("Agent Scan".to_string()))
//      } else {Ok(())}
//  }

//  async fn usb_thread(mut state: State) -> Result<(), Error> {
//      let platform: Platform = state.get(Field::Platform).await?;
//      if platform.is_desktop() {
//          let mut usb_info: UsbInfo = UsbInfo::new(&platform)?;
//          loop {
//              if let Some(device_path) = usb_info.detect_new_device_path(&platform)? {
//                  // Convert Option<PathBuf> to String safely, TODO update state here
//                  let device_path_str = device_path.to_string_lossy().into_owned();
//                  // Pass the string to the invoke function
//                  //dart_callback.call("print", &device_path_str).await?;
//              }
//              thread::sleep(time::Duration::from_millis(1_000));
//          }
//          Err::<(), Error>(Error::Exited("Usb Detection".to_string()))
//      } else {Ok(())}
//  }

async fn async_rust (
    path: String,
    platform: String,
    thread: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send,
) -> Result<(), Error> {

    #[cfg(target_os = "android")]
    android_logger::init_once(
        android_logger::Config::default().with_max_level(log::LevelFilter::Info),
    );
    #[cfg(any(target_os = "ios", target_os = "macos"))]
    oslog::OsLogger::new("frb_user").level_filter(log::LevelFilter::Info).init();
    thread::sleep(time::Duration::from_millis(500));//TODO: loggers need time to initialize maybe find an async solution

    let mut dart_callback = DartCallback::new();
    dart_callback.add_thread(thread);

    let path = PathBuf::from(&path);
    dart_callback.call("print", &format!("{:?}", path)).await?;

    let mut state = State::new::<SqliteStore>(path.clone()).await?;
    state.set(Field::Path, &path).await?;

    let platform = Platform::from_str(&platform)?;
    state.set(Field::Platform, &platform).await?;

    let storage = Storage::new(dart_callback.clone());

    let (doc, id) = if let Some(i) = storage.get("identity").await? {
        serde_json::from_str::<(DhtDocument, Identity)>(&i)?
    } else {
        let tup = DhtDocument::default(vec!["did:dht:fxaigdryri3os713aaepighxf6sm9h5xouwqfpinh9izwro3mbky".to_string()])?;
        storage.set("identity", &serde_json::to_string(&tup)?).await?;
        tup
    };

    doc.publish(&id.did_key).await?;

   if !platform.is_desktop() {
      //let seed: Seed = if let Some(seed) = storage.get("legacy_seed").await? {
      //    serde_json::from_str(&seed)?
      //} else {
      //    let seed = Seed::new();
      //    storage.set("legacy_seed", &serde_json::to_string(&seed)?).await?;
      //    seed
      //};
        //Hard coded for testing
        let seed: Seed = Seed{inner: vec![175, 178, 194, 229, 165, 10, 1, 80, 224, 239, 231, 107, 145, 96, 212, 195, 10, 78, 64, 17, 241, 77, 229, 246, 109, 226, 14, 83, 139, 28, 232, 220, 5, 150, 79, 185, 67, 31, 247, 41, 150, 36, 77, 199, 67, 47, 157, 15, 61, 142, 5, 244, 245, 137, 198, 34, 174, 221, 63, 134, 129, 165, 25, 7]};
        dart_callback.call("print", &format!("{:?}", seed)).await?;
        let descriptors = DescriptorSet::from_seed(&seed)?;
        dart_callback.call("print", &descriptors.internal).await?;
        state.set(Field::DescriptorSet, &descriptors).await?;
    }
    //info!("HELLO");
    tokio::try_join!(
        spawn(price_thread(state.clone())),
        spawn(internet_thread(state.clone())),
      //spawn(wallet_thread(state.clone(), platform, descriptors, path)),
      //spawn(web5_thread(state.clone(), platfrom, id, path)),
      //spawn(usb_thread(state)),
    )?;

    Err(Error::Exited("Main Thread".to_string()))
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

pub async fn getpage(path: String, page: Page) -> String {
    let result: Result<String, Error> = (|| async {
        StateManager::new(State::new::<SqliteStore>(PathBuf::from(&path)).await?).get(&page).await
    })().await;
    match result {
        Ok(s) => s,
        Err(e) => format!("Error: {}", e)
    }
}

pub async fn setstate(path: String, field: Field, data: String) -> String {
    let result: Result<String, Error> = (|| async {
        let state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
        let value = serde_json::from_str::<serde_json::Value>(&data)?;
        state.set::<serde_json::Value>(field, value).await?;
    })().await;
    match result {
        Ok(s) => s,
        Err(e) => format!("Error: {}", e)
    }
}

pub async fn setStateAddress(path: String, mut address: String) -> String {
    let result: Result<String, Error> = (|| async {
        let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
        state.set::<String>(Field::Address, &address).await?;
        Ok("Address set successfully".to_string())
    })().await;
    match result {
        Ok(s) => s,
        Err(e) => format!("Error: {}", e),
    }
}


pub async fn setStateConversation(path: String, index: usize) -> String {
    let result: Result<String, Error> = (|| async {
        let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
        let conversations = state.get::<Vec<Conversation>>(Field::Conversations).await?;
        let conversation = &conversations[index];
        state.set(Field::CurrentConversation, conversation).await?;
        Ok("Current conversation set successfully".to_string())
    })().await;

    match result {
        Ok(message) => message,
        Err(error) => format!("Error: {}", error),
    }
}

pub async fn setStateBtc(path: String, btc: f64) -> String {
    let result: Result<String, Error> = (|| async {
        let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
        state.set(Field::AmountBTC, &btc).await?;
        Ok("BTC set successfully".to_string())
    })().await;

    match result {
        Ok(message) => message,
        Err(error) => format!("Error: {}", error),
    }
}


pub async fn setStatePriority(path: String, index: u8) -> String {
    let result: Result<String, Error> = (|| async {
        let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
        state.set(Field::Priority, &index).await?;
        Ok("Priority set successfully".to_string())
    })().await;

    match result {
        Ok(message) => message,
        Err(error) => format!("Error: {}", error),
    }
}

pub async fn updateDisplayAmount(path: String, input: &str) -> String {
    let result: Result<String, Error> = (|| async {
        let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
        let amount = state.get::<String>(Field::Amount).await?;
        let btc = state.get::<f64>(Field::Balance).await?;
        let price = state.get::<f64>(Field::Price).await?;
        let usd_balance = btc*price;
        let min: f64 = 0.30;
        let max = usd_balance - min;

        let (updated_amount, validation) = match input {
            "reset" => ("0".to_string(), true),
            "backspace" => {
                if amount == "0" {
                    (amount.clone(), false)
                } else if amount.len() == 1 {
                    ("0".to_string(), true)
                } else {
                    (amount[..amount.len() - 1].to_string(), true)
                }
            },
            "." => {
                if !amount.contains('.') && amount.len() <= 7 {
                    (format!("{}{}", amount, "."), true)
                } else {
                    (amount.clone(), false)
                }
            },
            _ => {
                if amount == "0" {
                    (input.to_string(), true)
                } else if amount.contains('.') {
                    let split: Vec<&str> = amount.split('.').collect();
                    if amount.len() < 11 && split[1].len() < 2 {
                        (format!("{}{}", amount, input), true)
                    } else {
                        (amount.clone(), false)
                    }
                } else if amount.len() < 10 {
                    (format!("{}{}", amount, input), true)
                } else {
                    (amount.clone(), false)
                }
            }
        };

        let decimals = if updated_amount.contains('.') {
            let split: Vec<&str> = updated_amount.split('.').collect();
            let decimals_len = split.get(1).unwrap_or(&"").len();
            if decimals_len < 2 {
                "0".repeat(2 - decimals_len)
            } else {
                String::new()
            }
        } else {
            String::new()
        };

        let updated_amount_f64 = updated_amount.parse::<f64>().unwrap_or(0.0);

        let err: Option<String> = if updated_amount_f64 != 0.0 {
            if max <= 0.0 {
                Some("You have no bitcoin".to_string())
            } else if updated_amount_f64 < min {
                Some(format!("${:.2} minimum", min))
            } else if updated_amount_f64 > max {
                Some(format!("${:.2} maximum", max))
            } else {
                None
            }
        } else {
            None
        };

        state.set(Field::Amount, &updated_amount).await?;
        state.set(Field::AmountBTC, &(updated_amount_f64 / price)).await?;
        state.set(Field::AmountErr, &err).await?;
        state.set(Field::Decimals, &decimals).await?;
        Ok(if validation { "true".to_string() } else { "false".to_string() })
    })().await;

    match result {
        Ok(validation_str) => validation_str,
        Err(e) => format!("Error: {}", e),
    }
}


#[frb(sync)]
pub fn format_transaction_date(date: String, time: String) -> String {
    let now = Local::now().date_naive();
    let transaction_date = NaiveDate::parse_from_str(&date, "%m/%d/%Y").expect("Invalid date format");

    if is_same_date(transaction_date, now) {
        time
    } else if is_same_date(transaction_date, now - Duration::days(1)) {
        "Yesterday".to_string()
    } else {
        format!("{}", transaction_date.format("%B %e"))
    }
}

fn is_same_date(date1: NaiveDate, date2: NaiveDate) -> bool {
    date1.year() == date2.year() && date1.month() == date2.month() && date1.day() == date2.day()
}

pub async fn broadcastTx(path: String) -> String {
    let state = State::new::<SqliteStore>(PathBuf::from(&path)).await
        .expect("Failed to initialize state with the provided path");

    let client = bdk::electrum_client::Client::new(CLIENT_URI)
        .expect("Failed to connect to the Electrum client with the given URI");

    let blockchain = ElectrumBlockchain::from(client);

    let tx = state
        .get_o::<bdk::bitcoin::Transaction>(Field::CurrentRawTx).await
        .expect("Failed to retrieve transaction from state")
        .expect("No transaction found in state to broadcast");

    blockchain.broadcast(&tx)
        .expect("Failed to broadcast transaction to the blockchain");

    "Transaction successfully broadcast".to_string()
}
