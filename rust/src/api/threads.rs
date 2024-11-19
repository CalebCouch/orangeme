use super::Error;

use super::pub_structs::{Sats, Usd};
use super::state::{State, Field};
use super::web5::MessagingAgent;
use super::price::PriceGetter;
use super::structs::Callback;
use super::wallet::Wallet;

use std::{thread, time};
use std::sync::LazyLock;
use std::path::PathBuf;

use tokio::sync::mpsc::{Receiver, Sender};
use tokio::sync::{oneshot, Mutex, mpsc};
use reqwest::Client;

static THREAD_CHANNELS: LazyLock<Mutex<(Option<WalletSender>, Option<String>)>> = LazyLock::new(|| Mutex::new((None, None)));

pub type WalletReceiver = Receiver<(oneshot::Sender<String>, WalletMethod)>;
pub type WalletSender = Sender<(oneshot::Sender<String>, WalletMethod)>;

pub enum Threads {
    Wallet(WalletMethod)
}

#[derive(Debug)]
pub enum WalletMethod {
    GetNewAddress,
    GetFees(Sats),
    BuildTransaction(String, Sats, Sats, Usd),
    BroadcastTransaction(bdk::bitcoin::Transaction)
}

pub async fn start_threads(state: State, callback: Callback, path: PathBuf) -> Result<(), Error> {
    //Init channels
    let mut threads = THREAD_CHANNELS.lock().await;
    let (w_tx, w_rx) = mpsc::channel::<(oneshot::Sender<String>, WalletMethod)>(100);
    threads.0 = Some(w_tx);
    drop(threads);

    tokio::try_join!(
        spawn(internet_thread(state.clone())),
        spawn(price_thread(state.clone())),
        spawn(wallet_thread(state.clone(), callback.clone(), path.clone(), w_rx)),
        spawn(agent_thread(state, callback, path)),
    )?;

    Err(Error::Exited("Main Thread".to_string()))
}

pub async fn call_thread(thread: Threads) -> Result<String, Error> {
    let (o_tx, o_rx) = oneshot::channel::<String>();
    let threads = THREAD_CHANNELS.lock().await;
    match thread {
        Threads::Wallet(method) => threads.0.as_ref().ok_or(Error::Exited("Wallet Channel".to_string()))?.send((o_tx, method)).await?,
    }
    let res = o_rx.await;
    //This error isn't helpful, let the error on the transmitter side propagate
    if res.is_err() {loop{}} else {Ok(res?)}
}


//PRIVATE

async fn spawn<T>(task: T) -> Result<(), Error>
    where
        T: std::future::Future<Output = Result<(), Error>> + Send + 'static
{
    tokio::spawn(task).await.map_err(Error::TokioJoin)?
  //match tokio::spawn(task).await {
  //    Ok(Ok(o)) => Ok(o),
  //    Ok(Err(err)) => Err(err),
  //    Err(e) => Err(Error::TokioJoin(e))
  //}
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

async fn wallet_thread(
    state: State,
    callback: Callback,
    path: PathBuf,
    w_rx: WalletReceiver
) -> Result<(), Error> {
    let wallet = Wallet::new(callback, path.clone()).await?;

    tokio::try_join!(
        spawn(wallet_method_thread(wallet.clone(), w_rx)),
        spawn(wallet_sync_thread(wallet.clone())),
        spawn(wallet_refresh_thread(wallet, state)),
    )?;
    Err(Error::Exited("Wallet Thread".to_string()))
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

async fn wallet_method_thread(wallet: Wallet, mut recv: WalletReceiver) -> Result<(), Error> {
    loop {
        let (o_tx, method) = recv.recv().await.ok_or(Error::Exited("Wallet Channel".to_string()))?;
        match method {
            WalletMethod::GetNewAddress => o_tx.send(wallet.get_new_address().await?),
            WalletMethod::GetFees(amount) => {
                o_tx.send(serde_json::to_string(&wallet.get_fees(amount).await?)?)
            },
            WalletMethod::BuildTransaction(address, amount, fee, price) => {
                o_tx.send(serde_json::to_string(&wallet.build_transaction(&address, amount, fee, price).await?)?)
            },
            WalletMethod::BroadcastTransaction(tx) => {
                wallet.broadcast_transaction(&tx).await?;
                o_tx.send(String::new())
            },
        }.map_err(Error::Exited)?;
    }
}

async fn agent_thread(state: State, callback: Callback, path: PathBuf) -> Result<(), Error> {
    let agent = MessagingAgent::new(callback, path).await?;
    tokio::try_join!(
        spawn(agent_sync_thread(agent.clone())),
        spawn(agent_refresh_thread(agent, state)),
    )?;
    Err(Error::Exited("Agent Thread".to_string()))
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
