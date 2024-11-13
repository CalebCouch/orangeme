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

use super::pub_structs::{Platform, PageName, Thread, WalletMethod};
use super::state::Field;

use super::structs::{DartCommand, Storage, DartCallback, Profile};
use super::price::PriceGetter;
use super::state::{StateManager, State};
//use super::usb::UsbInfo;

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

//use crate::api::state::Conversation;

use web5_rust::dids::{DhtDocument, Identity};
use web5_rust::{Record};
use super::protocols::Protocols;

use log::info;

use std::sync::Arc;
use tokio::sync::Mutex;
use std::sync::{LazyLock};

use tokio::sync::{oneshot, mpsc};
use tokio::sync::mpsc::{Receiver, Sender};

use std::collections::HashMap;

use super::wallet::{Wallet, DescriptorSet, Seed, Transaction};

static THREAD_CHANNELS: LazyLock<Mutex<(Option<Sender<(oneshot::Sender<String>, WalletMethod)>>, Option<String>)>> = LazyLock::new(|| Mutex::new((None, None)));

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
        state.set(Field::Internet(Some(connected))).await?;
        thread::sleep(time::Duration::from_millis(1000));
    }
}

async fn price_thread(mut state: State) -> Result<(), Error> {
    loop {
        state.set(Field::Price(Some(PriceGetter::get(None).await?))).await?;
        thread::sleep(time::Duration::from_millis(2_000));
    }
}

async fn wallet_sync_thread(wallet: Wallet) -> Result<(), Error> {
    loop {
        wallet.sync().await?;
        thread::sleep(time::Duration::from_millis(1_000));
    }
    Err(Error::Exited("Wallet Sync".to_string()))
}

async fn wallet_thread(wallet: Wallet, mut recv: Receiver<(oneshot::Sender<String>, WalletMethod)>) -> Result<(), Error> {
    loop {
        let (o_tx, method) = recv.recv().await.ok_or(Error::Exited("Wallet Channel".to_string()))?;
        match method {
            WalletMethod::GetNewAddress => o_tx.send(wallet.get_new_address().await?),
        };
    }
    Err(Error::Exited("Wallet".to_string()))
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
    platform: Platform,
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

    let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
    state.set(Field::Path(Some(path.clone()))).await?;
    state.set(Field::Platform(Some(platform.clone()))).await?;

    let storage = Storage::new(dart_callback.clone());

    let (doc, id) = if let Some(i) = storage.get("identity").await? {
        serde_json::from_str::<(DhtDocument, Identity)>(&i)?
    } else {
        let tup = DhtDocument::default(vec!["did:dht:fxaigdryri3os713aaepighxf6sm9h5xouwqfpinh9izwro3mbky".to_string()])?;
        storage.set("identity", &serde_json::to_string(&tup)?).await?;
        tup
    };

    doc.publish(&id.did_key).await?;

    //let seed: Seed = if let Some(seed) = storage.get("legacy_seed").await? {
    //    serde_json::from_str(&seed)?
    //} else {
    //    let seed = Seed::new();
    //    storage.set("legacy_seed", &serde_json::to_string(&seed)?).await?;
    //    seed
    //};
    //Hard coded for testing
    let seed: Seed = Seed{inner: vec![175, 178, 194, 229, 165, 10, 1, 80, 224, 239, 231, 107, 145, 96, 212, 195, 10, 78, 64, 17, 241, 77, 229, 246, 109, 226, 14, 83, 139, 28, 232, 220, 5, 150, 79, 185, 67, 31, 247, 41, 150, 36, 77, 199, 67, 47, 157, 15, 61, 142, 5, 244, 245, 137, 198, 34, 174, 221, 63, 134, 129, 165, 25, 7]};
    let descriptors = DescriptorSet::from_seed(&seed)?;
    let path = PathBuf::from(&path);

    let mut threads = THREAD_CHANNELS.lock().await;
    let (w_tx, w_rx) = mpsc::channel::<(oneshot::Sender<String>, WalletMethod)>(100);
    threads.0 = Some(w_tx);
    drop(threads);

    let mut wallet = Wallet::new(descriptors, path, state.clone())?;

    tokio::try_join!(
        spawn(price_thread(state.clone())),
        spawn(internet_thread(state.clone())),
        spawn(wallet_sync_thread(wallet.clone())),
        spawn(wallet_thread(wallet, w_rx)),
      //spawn(web5_thread(state.clone(), platfrom, id, path)),
      //spawn(usb_thread(state)),
    )?;

    Err(Error::Exited("Main Thread".to_string()))
}

pub async fn rustCall(thread: Thread) -> String {
    let result: Result<String, Error> = async {
        let (o_tx, o_rx) = oneshot::channel::<String>();
        let threads = THREAD_CHANNELS.lock().await;
        match thread {
            Thread::Wallet(method) => threads.0.as_ref().ok_or(Error::Exited("Wallet Channel".to_string()))?.send((o_tx, method)).await.unwrap(),
        }
        Ok(o_rx.await.unwrap())
    }.await;
    match result {
        Ok(s) => s,
        Err(e) => format!("Error: {}", e)
    }
}

pub async fn ruststart (
    path: String,
    platform: Platform,
    thread: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send,
) -> String {
    match async_rust(path, platform, thread).await {
        Ok(()) => "OK".to_string(),
        Err(e) => e.to_string()
    }
}

pub async fn getpage(path: String, page: PageName) -> String {
    let result: Result<String, Error> = async {
        StateManager::new(State::new::<SqliteStore>(PathBuf::from(&path)).await?).get(page).await
    }.await;
    match result {
        Ok(s) => s,
        Err(e) => format!("Error: {}", e)
    }
}

//  pub async fn setstate(path: String, field: Field) -> String {
//      let result: Result<(), Error> = async {
//          let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
//          state.set(field).await?;
//          Ok(())
//      }.await;
//      match result {
//          Ok(()) => "Ok".to_string(),
//          Err(e) => format!("Error: {}", e)
//      }
//  }

//  pub async fn setStateAddress(path: String, mut address: String) -> String {
//      let result: Result<String, Error> = (|| async {
//          let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
//          state.set::<String>(Field::Address, &address).await?;
//          Ok("Address set successfully".to_string())
//      })().await;
//      match result {
//          Ok(s) => s,
//          Err(e) => format!("Error: {}", e),
//      }
//  }


//  pub async fn setStateConversation(path: String, index: usize) -> String {
//      let result: Result<String, Error> = (|| async {
//          let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
//          let conversations = state.get::<Vec<Conversation>>(Field::Conversations).await?;
//          let conversation = &conversations[index];
//          state.set(Field::CurrentConversation, conversation).await?;
//          Ok("Current conversation set successfully".to_string())
//      })().await;

//      match result {
//          Ok(message) => message,
//          Err(error) => format!("Error: {}", error),
//      }
//  }

//  pub async fn setStateBtc(path: String, btc: f64) -> String {
//      let result: Result<String, Error> = (|| async {
//          let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
//          state.set(Field::AmountBTC, &btc).await?;
//          Ok("BTC set successfully".to_string())
//      })().await;

//      match result {
//          Ok(message) => message,
//          Err(error) => format!("Error: {}", error),
//      }
//  }


//  pub async fn setStatePriority(path: String, index: u8) -> String {
//      let result: Result<String, Error> = (|| async {
//          let mut state = State::new::<SqliteStore>(PathBuf::from(&path)).await?;
//          state.set(Field::Priority, &index).await?;
//          Ok("Priority set successfully".to_string())
//      })().await;

//      match result {
//          Ok(message) => message,
//          Err(error) => format!("Error: {}", error),
//      }
//  }

 


//  #[frb(sync)]


//  pub async fn broadcastTx(path: String) -> String {
//      let state = State::new::<SqliteStore>(PathBuf::from(&path)).await
//          .expect("Failed to initialize state with the provided path");

//      let client = bdk::electrum_client::Client::new(CLIENT_URI)
//          .expect("Failed to connect to the Electrum client with the given URI");

//      let blockchain = ElectrumBlockchain::from(client);

//      let tx = state
//          .get_o::<bdk::bitcoin::Transaction>(Field::CurrentRawTx).await
//          .expect("Failed to retrieve transaction from state")
//          .expect("No transaction found in state to broadcast");

//      blockchain.broadcast(&tx)
//          .expect("Failed to broadcast transaction to the blockchain");

//      "Transaction successfully broadcast".to_string()
//  }

//  //  #[derive(Debug)]
//  //  pub enum TestEnum {HEllo}

//  //  pub fn testfn(test: TestEnum) -> String {
//  //      format!("Hi");
//  //  }
