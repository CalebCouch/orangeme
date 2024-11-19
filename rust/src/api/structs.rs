use super::Error;

use super::pub_structs::DartMethod;

use std::sync::Arc;

use chrono::{Utc, DateTime as ChronoDateTime};
use flutter_rust_bridge::DartFnFuture;
use serde::{Serialize, Deserialize};
use tokio::sync::Mutex;
use reqwest::Response;


pub type Callback = Arc<Mutex<dyn Fn(DartMethod) -> DartFnFuture<Option<String>> + 'static + Sync + Send>>;

#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, Eq, Hash, PartialOrd, Ord, Default)]
pub struct DateTime {
    pub date: ChronoDateTime<Utc>
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
