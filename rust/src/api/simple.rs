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

use super::web5::MessagingAgent;
use super::structs::{DartCommand, Storage, DartCallback};
use super::price::PriceGetter;
use super::state::{StateManager, State};
//use super::usb::UsbInfo;

use simple_database::SqliteStore;

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

use log::{error, info};

use std::sync::Arc;
use tokio::sync::Mutex;
use std::sync::{LazyLock};

use tokio::sync::{oneshot, mpsc};
use tokio::sync::mpsc::{Receiver, Sender};

use std::collections::HashMap;

use super::wallet::{Wallet, DescriptorSet, Seed, Transaction};

use web5_rust::dids::{DhtDocument, Identity};

pub type WalletSender = Sender<(oneshot::Sender<String>, WalletMethod)>;

static THREAD_CHANNELS: LazyLock<Mutex<(Option<WalletSender>, Option<String>)>> = LazyLock::new(|| Mutex::new((None, None)));

use reqwest::Client;


async fn spawn<T>(task: T) -> Result<(), Error>
    where
        T: std::future::Future<Output = Result<(), Error>> + Send + 'static
{
    match tokio::spawn(task).await {
        Ok(Ok(o)) => Ok(o),
        Ok(Err(err)) => Err(err),
        Err(e) => Err(Error::TokioJoin(e))
    }
}

async fn internet_thread(state: State) -> Result<(), Error> {
    let client = Client::new();

    loop {
        let connected = client.get("https://google.com")
            .send().await
            .map(|response| response.status().is_success())
            .unwrap_or(false);

        state.set(Field::Internet(Some(connected))).await?;
        thread::sleep(time::Duration::from_millis(1000));
    }
}

async fn price_thread(state: State) -> Result<(), Error> {
    loop {
        state.set(Field::Price(Some(PriceGetter::get(None).await?))).await?;
        thread::sleep(time::Duration::from_millis(15_000));
    }
}

async fn wallet_sync_thread(wallet: Wallet) -> Result<(), Error> {
    loop {
        wallet.sync().await?;
        thread::sleep(time::Duration::from_millis(10_000));
    }
}

async fn wallet_refresh_thread(wallet: Wallet, state: State) -> Result<(), Error> {
    loop {
        wallet.refresh_state(&state).await?;
        thread::sleep(time::Duration::from_millis(1_000));
    }
}

async fn wallet_thread(wallet: Wallet, mut recv: Receiver<(oneshot::Sender<String>, WalletMethod)>) -> Result<(), Error> {
    loop {
        let (o_tx, method) = recv.recv().await.ok_or(Error::Exited("Wallet Channel".to_string()))?;
        match method {
            WalletMethod::GetNewAddress => o_tx.send(wallet.get_new_address().await?),
            WalletMethod::GetFees(amount, price) => o_tx.send(serde_json::to_string(&wallet.get_fees(amount, price).await?)?),
        }.map_err(Error::Exited)?;
    }
}

async fn agent_sync_thread(agent: MessagingAgent) -> Result<(), Error> {
    loop {
        agent.sync().await?;
        thread::sleep(time::Duration::from_millis(10_000));
    }
}

async fn agent_refresh_thread(agent: MessagingAgent, state: State) -> Result<(), Error> {
    loop {
        agent.refresh_state(&state).await?;
        thread::sleep(time::Duration::from_millis(5_000));
    }
}

pub async fn rustStart (
    path: String,
    platform: Platform,
    thread: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send,
) -> Result<String, Error> {

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

    let wallet = Wallet::new(descriptors, path.clone())?;

    let agent = MessagingAgent::new(id, path).await?;

    tokio::try_join!(
        spawn(price_thread(state.clone())),
        spawn(internet_thread(state.clone())),
        spawn(wallet_sync_thread(wallet.clone())),
        spawn(wallet_refresh_thread(wallet.clone(), state.clone())),
        spawn(wallet_thread(wallet.clone(), w_rx)),
        spawn(agent_sync_thread(agent.clone())),
        spawn(agent_refresh_thread(agent.clone(), state.clone())),
      //spawn(agent_thread(agent, state.clone())),
    )?;

    Err(Error::Exited("Main Thread".to_string()))
}

pub async fn rustCall(thread: Thread) -> Result<String, Error> {
    let (o_tx, o_rx) = oneshot::channel::<String>();
    let threads = THREAD_CHANNELS.lock().await;
    match thread {
        Thread::Wallet(method) => threads.0.as_ref().ok_or(Error::Exited("Wallet Channel".to_string()))?.send((o_tx, method)).await?,
    }
    Ok(o_rx.await?)
}

pub async fn getPage(path: String, page: PageName) -> Result<String, Error> {
    StateManager::new(State::new::<SqliteStore>(PathBuf::from(&path)).await?).get(page).await
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
