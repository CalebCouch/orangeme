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

use super::pub_structs::DartCommand;

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

pub type Thread = Arc<Mutex<dyn Fn(DartCommand) -> DartFnFuture<String> + 'static + Sync + Send>>;

#[derive(Clone, Default)]
pub struct DartCallback {
    threads: Vec<Thread>
}

impl DartCallback {
    pub fn new() -> Self {DartCallback{threads: vec![]}}

    pub fn add_thread(&mut self, thread: impl Fn(DartCommand) -> DartFnFuture<String> + 'static + Sync + Send) {
        self.threads.push(Arc::new(Mutex::new(thread)));
    }

    pub async fn call(&self, method: &str, data: &str) -> Result<String, Error> {
        loop {
            for thread in &self.threads {
                if let Ok(thread) = thread.try_lock() {
                    return Ok(thread(DartCommand{
                        method: method.to_string(),
                        data: data.to_string()
                    }).await);
                }
            }
        }
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
