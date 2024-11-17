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
