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

    pub async fn get(&mut self, timestamp: Option<u64>) -> Result<f64, Error> {
        match timestamp {
            None => {
                self.store.get(b"price")?.map(|b|
                    Self::from_bytes(&b)
                ).unwrap_or(Ok(0.0))
            },
            Some(timestamp) => {
                match self.store.get(&timestamp.to_le_bytes())? {
                    Some(b) => Self::from_bytes(&b),
                    None => {
                        let date = DateTime::from_timestamp(timestamp)?.format("%Y-%m-%d");
                        let url = format!("{}?date={}", PRICES_URL, date);
                        let reqwest = Request::get(&url).await?;
                        let value: serde_json::Value = reqwest.json().await?;
                        let spot_res: SpotRes = serde_json::from_value(value.clone()).or(
                            Err(Error::err("Fetching price from coinbases api",
                                &serde_json::to_string(&value)?
                            ))
                        )?;
                        let price = spot_res.data.amount.parse::<f64>()?;
                        self.store.set(&timestamp.to_le_bytes(), &price.to_le_bytes())?;
                        Ok(price)
                    }
                }
            }
        }
    }

    fn from_bytes(b: &[u8]) -> Result<f64, Error> {
        Ok(f64::from_le_bytes(b.try_into().or(
            Err(Error::err("PriceGetter.from_bytes", "invalid b"))
        )?))
    }

    pub async fn fetch_price(&mut self) -> Result<(), Error> {
        let res = Request::get(PRICE_URL).await?.json::<Value>().await?;
        let price_res: PriceRes = serde_json::from_value(res)?;
        let price = price_res.data.amount.parse::<f64>()?.to_le_bytes();
        self.store.set(b"price", &price)?;
        Ok(())
    }
}
