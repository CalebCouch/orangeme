use super::Error;

use super::structs::{Platform, DartCommand, Storage, DartCallback};
use super::wallet::{Wallet, DescriptorSet, Seed};
//use super::callback::RustCallback;
use super::price::PriceGetter;
use super::state::{StateManager, State, Field};
use super::usb::UsbInfo;

use web5_rust::common::SqliteStore;
use web5_rust::common::traits::KeyValueStore;

use bdk::bitcoin::{Network, Address};
use bdk::database::SqliteDatabase;
use bdk::blockchain::ElectrumBlockchain;
use web5_rust::dwn::traits::Client;
use bdk::FeeRate;
use bdk::SignOptions;
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
    loop {
        let connected = reqwest::get("https://google.com").await.is_ok();
        state.set(Field::Internet, &connected)?;
        thread::sleep(time::Duration::from_millis(1000));
    }
    Err::<(), Error>(Error::Exited("Internet Check".to_string()))
}

async fn price_thread(mut state: State) -> Result<(), Error> {
    loop {
        state.set(Field::Price, &PriceGetter::get(None).await?)?;
        thread::sleep(time::Duration::from_millis(600_000));
    }
    Err::<(), Error>(Error::Exited("Price Update".to_string()))
}

async fn wallet_thread(mut state: State) -> Result<(), Error> {
    if state.get::<Platform>(Field::Platform)?.is_desktop() {
        let descriptors = state.get::<DescriptorSet>(Field::DescriptorSet)?;
        let path = state.get::<PathBuf>(Field::Path)?;
        let mut wallet = Wallet::new(descriptors.clone(), path.clone())?;
        loop {
            wallet.sync().await?;
            thread::sleep(time::Duration::from_millis(1_000));
        }
        Err(Error::Exited("Wallet Sync".to_string()))
    } else {Ok(())}
}

async fn usb_thread(mut state: State) -> Result<(), Error> {
    let platform: Platform = state.get(Field::Platform)?;
    if platform.is_desktop() {
        let mut usb_info: UsbInfo = UsbInfo::new(&platform)?;
        loop {
            if let Some(device_path) = usb_info.detect_new_device_path(&platform)? {
                // Convert Option<PathBuf> to String safely, TODO update state here
                let device_path_str = device_path.to_string_lossy().into_owned();
                // Pass the string to the invoke function
                //dart_callback.call("print", &device_path_str).await?;
            }
            thread::sleep(time::Duration::from_millis(1_000));
        }
        Err::<(), Error>(Error::Exited("Usb Detection".to_string()))
    } else {Ok(())}
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
    state.set(Field::Platform, &platform)?;

    let storage = Storage::new(dart_callback.clone());

   if !platform.is_desktop() {
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
    }

    tokio::try_join!(
        spawn(price_thread(state.clone())),
        spawn(internet_thread(state.clone())),
        spawn(wallet_thread(state.clone())),
        spawn(usb_thread(state)),
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

#[frb(sync)]
pub fn getstate(path: String, name: String, options: String) -> String {
    let result: Result<String, Error> = (move || {
        StateManager::new(State::new::<SqliteStore>(PathBuf::from(&path))?).get(&name, &options)
    })();
    match result {
        Ok(s) => s,
        Err(e) => format!("Error: {}", e)
    }
}

#[frb(sync)]
pub fn check_address_valid(address: String) -> bool {
    Address::from_str(&address)
        .map(|a| a.require_network(Network::Bitcoin).is_ok())
        .unwrap_or(false)
}

/*
#[frb(sync)]
pub fn build_transaction(address: String) -> String {
    let ec = "Main.create_transaction";
    let error = || Error::bad_request(ec, "Invalid parameters");

    invoke(&callback, "print", &format!("split {}", command.data.clone())).await?;
    let split: Vec<&str> = command.data.split("|").collect();
    let address = Address::from_str(split.first().ok_or(error())?)?.require_network(Network::Bitcoin)?;
    let amount = (f64::from_str(split.get(1).ok_or(error())?)? * SATS) as u64;
    let priority = u8::from_str(split.get(2).ok_or(error())?)? as u8;
    let price_error = || Error::not_found(ec, "Cannot get price");
    let current_price = f64::from_le_bytes(price.get(b"price")?.ok_or(price_error())?.try_into().or(Err(price_error()))?);
    let is_mine = |s: &Script| wallet.is_mine(s).unwrap_or(false);
    invoke(&callback, "print", &format!("amount: {}", amount)).await?;
    let fees = vec![blockchain.estimate_fee(3)?, blockchain.estimate_fee(1)?];
    let (mut psbt, mut tx_details) = {
        let mut builder = wallet.build_tx();
        builder.add_recipient(address.script_pubkey(), amount);
        builder.fee_rate(FeeRate::from_btc_per_kvb(fees[priority as usize] as f32));
        builder.finish()?
    };
    let finalized = wallet.sign(&mut psbt, SignOptions::default())?;
    if !finalized { return Err(Error::err(ec, "Could not sign std tx"));}

    let tx = psbt.clone().extract_tx();
    let mut stream: Vec<u8> = Vec::new();
    tx.consensus_encode(&mut stream)?;
    store.set(&tx_details.txid.to_string().as_bytes(), &stream)?;

    tx_details.transaction = Some(tx);
    let tx = Transaction::from_details(tx_details, current_price, |s: &Script| {wallet.is_mine(s).unwrap_or(false)})?;

    Ok(serde_json::to_string(&tx)?)
                
}*/
#[frb(sync)]
pub fn build_transaction(address_str: String, amount_str: String, priority_str: String) -> Result<String, Error> {
    let ec = "Main.create_transaction";
    
    let error = || Error::bad_request(ec, "Invalid parameters");

    let wallet = Wallet::new(&descriptors.external, Some(&descriptors.internal), Network::Bitcoin, SqliteDatabase::new(wallet_path.join("bdk.db")))?;
    let blockchain = ElectrumBlockchain::from(Client::new(&client_uri)?);
    let mut store = SqliteStore::new(store_path.clone())?;
    let price = SqliteStore::new(price_path.clone())?;
    let client = Client::new(&client_uri)?;

    let address = Address::from_str(&address_str).map_err(|_| error())?;
    address.require_network(Network::Bitcoin).map_err(|_| error())?;

    let amount = f64::from_str(&amount_str).map_err(|_| error())?;
    const SATS: f64 = 100_000_000.0;
    let amount_sats = (amount * SATS) as u64;

    let priority = u8::from_str(&priority_str).map_err(|_| error())?;

    let price_error = || Error::not_found(ec, "Cannot get price");
    let current_price = price.get(b"price")
        .ok_or_else(price_error)?
        .try_into()
        .map_err(|_| price_error())?;

    let is_mine = |s: &Script| wallet.is_mine(s).unwrap_or(false);

    let fees = vec![
        blockchain.estimate_fee(3)?,
        blockchain.estimate_fee(1)?
    ];
    

    let (mut psbt, mut tx_details) = {
        let mut builder = wallet.build_tx();
        builder.add_recipient(address.script_pubkey(), amount_sats);
        builder.fee_rate(FeeRate::from_btc_per_kvb(fees[priority as usize] as f32));
        builder.finish()?
    };


    let finalized = wallet.sign(&mut psbt, SignOptions::default())?;
    if !finalized {
        return Err(Error::err(ec, "Could not sign transaction"));
    }

    let tx = psbt.clone().extract_tx();
    let mut stream: Vec<u8> = Vec::new();
    tx.consensus_encode(&mut stream)?;
    store.set(&tx_details.txid.to_string().as_bytes(), &stream)?;
    
    tx_details.transaction = Some(tx.clone());
    let tx = Transaction::from_details(tx_details, current_price, is_mine)?;

    Ok(serde_json::to_string(&tx)?)
}



#[frb(sync)]
pub fn updateDisplayAmount(path: String, input: &str) -> String {
    let result: Result<String, Error> = (move || {
        let mut state = State::new::<SqliteStore>(PathBuf::from(&path))?;
        let amount = state.get::<String>(Field::Amount)?;
        let usd_balance: f64 = 120.30;
        let fees: Vec<f64> = vec![0.15, 0.34];
        let min: f64 = fees[0] + 0.10;
        let max: f64 = usd_balance - min;
        let mut updated_amount = amount.clone();
        let mut validation = true;

        match input {
            "reset" => updated_amount = "0".to_string(),
            "backspace" => {
                if amount == "0" {
                    validation = false;
                } else if amount.len() == 1 {
                    updated_amount = "0".to_string();
                } else {
                    updated_amount = amount[..amount.len() - 1].to_string();
                }
            },
            "." => {
                if !amount.contains('.') && amount.len() <= 7 {
                    updated_amount = format!("{}{}", amount, ".");
                } else {
                    validation = false;
                }
            },
            _ => {
                if amount == "0" {
                    updated_amount = input.to_string();
                } else if amount.contains('.') {
                    let split: Vec<&str> = amount.split('.').collect();
                    if amount.len() < 11 && split[1].len() < 2 {
                        updated_amount = format!("{}{}", amount, input);
                    } else {
                        validation = false;
                    }
                } else if amount.len() < 10 {
                    updated_amount = format!("{}{}", amount, input);
                } else {
                    validation = false;
                }
            }
        }

        let mut decimals = String::new();
        if updated_amount.contains('.') {
            let split: Vec<&str> = updated_amount.split('.').collect();
            let decimals_len = split.get(1).unwrap_or(&"").len();
            if decimals_len < 2 {
                decimals = "0".repeat(2 - decimals_len);
            }
        }

        let mut err = String::new();
        let updated_amount_f64 = updated_amount.parse::<f64>().unwrap_or(0.0);

        if updated_amount_f64 != 0.0 {
            if updated_amount_f64 <= min {
                err = format!("${:.2} minimum", min);
            } else if updated_amount_f64 > max {
                err = format!("${:.2} maximum", max);
                if err == "$0.00 maximum" {
                    err = "You have no bitcoin".to_string();
                }
            }
        }

        state.set(Field::Amount, &updated_amount)?;
        state.set(Field::AmountErr, &err)?;
        state.set(Field::Decimals, &decimals)?;
        Ok(if validation { "true".to_string() } else { "false".to_string() })
    })();

    match result {
        Ok(validation_str) => validation_str,
        Err(e) => format!("Error: {}", e),
    }
}
