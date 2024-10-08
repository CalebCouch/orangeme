use super::Error;

use super::wallet::Wallet;

use web5_rust::common::traits::KeyValueStore;
use web5_rust::common::structs::DateTime;

use serde::Serialize;

use std::path::PathBuf;

#[derive(Clone)]
pub struct StateManager {
    wallet: Wallet,
    store: Box<dyn KeyValueStore>,
}

impl StateManager {
    pub fn new<KVS: KeyValueStore + 'static>(
        wallet: Wallet,
        path: PathBuf,
    ) -> Result<Self, Error> {
        Ok(StateManager{
            wallet,
            store: Box::new(KVS::new(path)?)
        })
    }

    pub async fn get(&self, state_name: &str) -> Result<String, Error> {
        match state_name {
            "BitcoinHome" => self.bitcoin_home(),
            _ => Err(Error::bad_request("StateManager::get", &format!("No state with name {}", state_name)))
        }
    }
    fn format_datetime(datetime: Option<&DateTime>) -> String {
        datetime
        .map(|dt| dt.format("%Y-%m-%d %l:%M %p").to_string())
        .unwrap_or("Pending".to_string())
    }

    pub fn bitcoin_home(&self) -> Result<String, Error> {
        let (btc, usd) = self.wallet.get_balance()?;
        Ok(serde_json::to_string(&BitcoinHome{
            usd: usd.to_string(),
            btc: btc.to_string(),
            transactions: self.wallet.list_unspent()?.into_iter().map(|tx| Transaction{
                usd: format!("${}", tx.usd),
                datetime: Self::format_datetime(tx.confirmation_time.as_ref().map(|t| &t.1)),
                is_withdraw: tx.is_withdraw,
            }).collect()
        })?)
    }
}

#[derive(Serialize)]
struct Transaction{
    pub usd: String,
    pub datetime: String,
    pub is_withdraw: bool
}

#[derive(Serialize)]
struct BitcoinHome {
    pub usd: String,
    pub btc: String,
    pub transactions: Vec<Transaction>
}
