use super::Error;

use super::structs::Request;

use serde::Deserialize;
use serde_json::Value;
use std::path::PathBuf;
use std::convert::TryInto;

use web5_rust::common::traits::KeyValueStore;
use web5_rust::common::structs::DateTime;

#[derive(Deserialize)]
struct PriceRes {data: Price}
#[derive(Deserialize)]
struct Price {amount: String, currency: String}
#[derive(Deserialize)]
struct Spot {amount: String, currency: String, base: String}
#[derive(Deserialize)]
struct SpotRes {
    data: Spot,
}

const PRICE_URL: &str = "https://api.coinbase.com/v2/prices/BTC-USD/buy";
const PRICES_URL: &str = "https://api.coinbase.com/v2/prices/BTC-USD/spot";

#[derive(Clone, Debug)]
pub struct PriceGetter {
    store: Box<dyn KeyValueStore>
}

impl PriceGetter {
    pub fn new<KVS: KeyValueStore + 'static>(path: PathBuf) -> Result<Self, Error> {
        Ok(PriceGetter{
            store: Box::new(KVS::new(path)?)
        })
    }

    pub fn get_current_price(&self) -> Result<f64, Error> {
        Ok(self.store.get(b"price")?.map(|b|
            serde_json::from_slice(&b)
        ).transpose()?.unwrap_or_default())
    }

    pub async fn update_current_price(&mut self) -> Result<(), Error> {
        Ok(self.store.set(b"price", &Self::get(None).await?.to_le_bytes())?)
    }

    pub async fn get(timestamp: Option<&DateTime>) -> Result<f64, Error> {
        Ok(match timestamp {
            None => {
                let res = Request::get(PRICE_URL).await?.json::<Value>().await?;
                let price_res: PriceRes = serde_json::from_value(res)?;
                price_res.data.amount.parse::<f64>()?
            },
            Some(timestamp) => {
                let date = timestamp.format("%Y-%m-%d");
                let url = format!("{}?date={}", PRICES_URL, date);
                let reqwest = Request::get(&url).await?;
                let value: serde_json::Value = reqwest.json().await?;
                let spot_res: SpotRes = serde_json::from_value(value.clone()).or(
                    Err(Error::err("Fetching price from coinbases api",
                        &serde_json::to_string(&value)?
                    ))
                )?;
                spot_res.data.amount.parse::<f64>()?
            }
        })
    }
}
