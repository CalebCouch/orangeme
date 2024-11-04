use super::Error;

use super::structs::{Platform, DartCommand, Storage, DartCallback};
use super::wallet::{Wallet, DescriptorSet, Seed};
//use super::callback::RustCallback;
use super::price::PriceGetter;
use super::state::{StateManager, State, Field};
use super::usb::UsbInfo;

use simple_database::KeyValueStore;
use simple_database::SqliteStore;

use bdk::bitcoin::{Network, Address};
use bdk::database::SqliteDatabase;
use bdk::blockchain::ElectrumBlockchain;
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

use serde::{Serialize, Deserialize};

use chrono::NaiveDate;
use chrono::Datelike;
use chrono::Duration;
use chrono::Local;

use crate::api::state::Conversation;

const SATS: u64 = 100_000_000;

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
            .send()
            .await
            .map(|response| response.status().is_success())
            .unwrap_or(false);

        if !connected { panic!("Internet connection failed") };
        
        state.set(Field::Internet, &connected)?;
        
        thread::sleep(time::Duration::from_millis(1000));
    }
}

async fn price_thread(mut state: State) -> Result<(), Error> {
    loop {
        state.set(Field::Price, &PriceGetter::get(None).await?)?;
        thread::sleep(time::Duration::from_millis(600_000));
    }
    Err::<(), Error>(Error::Exited("Price Update".to_string()))
}

async fn wallet_thread(mut state: State) -> Result<(), Error> {
    if !state.get::<Platform>(Field::Platform)?.is_desktop() {
        let descriptors = state.get::<DescriptorSet>(Field::DescriptorSet)?;
        let path = state.get::<PathBuf>(Field::Path)?;
        let mut wallet = Wallet::new(descriptors.clone(), path.clone(), state)?;
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
    dart_callback.call("print", &format!("{:?}", path)).await?;

    let mut state = State::new::<SqliteStore>(path.clone())?;
    state.set(Field::Path, &path)?;

    let platform = Platform::from_str(&platform)?;
    state.set(Field::Platform, &platform)?;

    let storage = Storage::new(dart_callback.clone());

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
pub fn setStateAddress(path: String, address: String) -> String {
    let result: Result<String, Error> = (move || {
        let mut state = State::new::<SqliteStore>(PathBuf::from(&path))?;
        state.set::<String>(Field::Address, &address)?;
        Ok("Address set successfully".to_string())
    })();
    match result {
        Ok(s) => s,
        Err(e) => format!("Error: {}", e),
    }
}


#[frb(sync)]
pub fn setStateConversation(path: String, index: usize) -> String {
    let result: Result<String, Error> = (move || {
        let mut state = State::new::<SqliteStore>(PathBuf::from(&path))?;
        let conversations = state.get::<Vec<Conversation>>(Field::Conversations)?;
        let conversation = &conversations[index];
        state.set(Field::CurrentConversation, conversation)?;
        
        Ok("Current conversation set successfully".to_string())
    })();

    match result {
        Ok(message) => message,
        Err(error) => format!("Error: {}", error),
    }
}


#[frb(sync)]
pub fn updateDisplayAmount(path: String, input: &str) -> String {
    let result: Result<String, Error> = (move || {
        let mut state = State::new::<SqliteStore>(PathBuf::from(&path))?;
        let amount = state.get::<String>(Field::Amount)?;
        let btc = state.get::<f64>(Field::Balance)?;
        let usd_balance = btc*state.get::<f64>(Field::Price)?;
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