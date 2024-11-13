use super::Error;

use web5_rust::dids::Did;

use serde::{Serialize, Deserialize};

use reqwest::Response;

use flutter_rust_bridge::DartFnFuture;

use chrono::{Utc, DateTime as ChronoDateTime};
use chrono::format::SecondsFormat;

use schemars::JsonSchema;

use tokio::sync::Mutex;
use std::sync::Arc;

const STORAGE_SPLIT: &str = "\u{0000}";


#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, Eq, Hash, PartialOrd, Ord, Default)]
pub struct DateTime {
    date: ChronoDateTime<Utc>
}

impl DateTime {
    pub fn from_timestamp(timestamp: u64) -> Result<DateTime, Error> {
        Ok(DateTime{date:
            ChronoDateTime::<Utc>::from_timestamp(timestamp as i64, 0)
            .ok_or(Error::bad_request("DateTime::from_timestamp", "Could not create date from timestamp"))?
        })
    }
    pub fn now() -> DateTime {
        DateTime{date: Utc::now()}
    }
    pub fn timestamp(&self) -> u64 {
        Some(self.date.timestamp()).filter(|t| *t >= 0).expect("timestamp was negative") as u64
    }
    pub fn format(&self, fmt: &str) -> String {
        self.date.format(fmt).to_string()
    }
}

pub struct Request {}

impl Request {
    pub async fn get(url: &str) -> Result<Response, Error> {
        loop {
            if let Ok(res) = reqwest::get(url).await {
                return Ok(res);
            }
        }
    }
}

pub type Thread = Arc<Mutex<dyn Fn(String) -> DartFnFuture<String> + 'static + Sync + Send>>;

#[derive(Clone, Default)]
pub struct DartCallback {
    threads: Vec<Thread>
}

impl DartCallback {
    pub fn new() -> Self {DartCallback{threads: vec![]}}

    pub fn add_thread(&mut self, thread: impl Fn(String) -> DartFnFuture<String> + 'static + Sync + Send) {
        self.threads.push(Arc::new(Mutex::new(thread)));
    }

    pub async fn call(&self, method: &str, data: &str) -> Result<String, Error> {
        loop {
            for thread in &self.threads {
                if let Ok(thread) = thread.try_lock() {
                    let req = serde_json::to_string(&DartCommand{
                        method: method.to_string(),
                        data: data.to_string()
                    })?;
                    let res = thread(req).await;
                    if res.contains("Error") {
                        return Err(Error::DartError(res.to_string()))
                    }
                    return Ok(res)
                }
            }
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct DartCommand {
    pub method: String,
    pub data: String
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct RustCommand {
    pub uid: String,
    pub method: String,
    pub data: String
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct RustResponse {
    pub uid: String,
    pub data: String
}


#[derive(Serialize, Deserialize, Debug, Clone)]
pub enum Platform {
    Mac,
    Linux,
    Windows,
    IOS,
    Android,
    Fuchsia
}

impl Platform {
    pub fn is_desktop(&self) -> bool {
        matches!(self, Platform::Mac | Platform::Linux | Platform::Windows)
    }
}

impl Default for Platform {
    fn default() -> Self {Platform::Mac}
}

impl std::str::FromStr for Platform {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        Ok(match s {
            "Mac" => Platform::Mac,
            "Linux" => Platform::Linux,
            "Windows" => Platform::Windows,
            "IOS" => Platform::IOS,
            "Android" => Platform::Android,
            "Fuchsia" => Platform::Fuchsia,
            _ => return Err(Error::parse("Platform", s))
        })
    }
}

pub struct Storage {
    dart_callback: DartCallback
}

impl Storage {
    pub fn new(dart_callback: DartCallback) -> Self {
        Storage{dart_callback}
    }

    pub async fn set(&self, key: &str, value: &str) -> Result<(), Error> {
        let data = key.to_string()+STORAGE_SPLIT+value;
        self.dart_callback.call("storage_set", &data).await?;
        Ok(())
    }

    pub async fn get(&self, key: &str) -> Result<Option<String>, Error> {
        Ok(Some(self.dart_callback.call("storage_get", key).await?).filter(|s: &String| !s.is_empty()))
    }
}



//  #[derive(Serialize, Deserialize, Debug, Clone, Default)]
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

//  #[derive(Serialize, Deserialize, Debug, Clone, Default)]
//  pub struct Contact {
//      pub name: String,
//      pub did: String,
//      pub pfp: Option<String>,
//      pub abtme: Option<String>,
//  }

//  #[derive(Serialize, Deserialize, Debug, Clone, Default)]
//  pub struct Conversation {
//      pub messages: Vec<Message>,
//      pub members: Vec<Contact>,
//  }

//  #[derive(Serialize, Deserialize, Debug, Clone, Default)]
//  pub struct Message {
//      pub sender: Contact,
//      pub message: String,
//      pub date: String,
//      pub time: String,
//      pub is_incoming: bool,
//  }

//  #[derive(Serialize, Deserialize, Debug, Clone, Default)]
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


