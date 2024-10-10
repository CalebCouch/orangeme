use super::Error;

use super::wallet::Transaction;

use web5_rust::common::traits::KeyValueStore;
use web5_rust::common::structs::DateTime;

use serde::{Serialize, Deserialize};

use bdk::bitcoin::hash_types::Txid;

use std::collections::BTreeMap;
use std::path::PathBuf;

#[derive(Debug)]
pub enum Field {
    Transactions(BTreeMap<Txid, Transactions>),
    Internet(bool),
    Balance(f64),
    Price(f64),
    NewAddress(String)
}
impl Field {
    pub fn into_bytes(&self) -> Vec<u8> {
        format!("{:?}", self).into_bytes()
    }
}

#[derive(Clone)]
pub struct State {
    store: Box<dyn KeyValueStore>,
}

impl State {
    pub fn new<KVS: KeyValueStore + 'static>(
        path: PathBuf,
    ) -> Result<Self, Error> {
        Ok(State{
            store: Box::new(KVS::new(path)?)
        })
    }

    pub fn set<T: Serialize>(&mut self, field: Field, data: &T) -> Result<(), Error> {
        self.store.set(&field.into_bytes(), &serde_json::to_vec(data)?)?;
        Ok(())
    }
    pub fn get<T: for <'a> Deserialize<'a> + Default>(&self, field: Field) -> Result<T, Error> {
        Ok(self.store.get(&field.into_bytes())?.map(|b|
            serde_json::from_slice(&b)
        ).transpose()?.unwrap_or_default())
    }
}

#[derive(Clone)]
pub struct StateManager {
    state: State,
}

impl StateManager {
    pub fn new(state: State) -> Self {
        StateManager{state}
    }

    pub fn get(&self, state_name: &str) -> Result<String, Error> {
        match state_name {
            "BitcoinHome" => self.bitcoin_home(),
            "Receive" => self.receive(),
            _ => Err(Error::bad_request("StateManager::get", &format!("No state with name {}", state_name)))
        }
    }

    fn format_datetime(datetime: Option<&DateTime>) -> String {
        datetime
        .map(|dt| dt.format("%Y-%m-%d %l:%M %p").to_string())
        .unwrap_or("Pending".to_string())
    }

    pub fn bitcoin_home(&self) -> Result<String, Error> {
        let btc = self.state.get::<f64>(Field::Balance)?;
        let usd = 1.0*self.state.get::<f64>(Field::Price)?;
        Ok(serde_json::to_string(&BitcoinHome{
            usd: usd.to_string(),
            btc: btc.to_string(),
            transactions: self.state
            .get::<BTreeMap<Txid, Transaction>>(Field::Transactions)?
            .into_values().map(|tx|
                BitcoinHomeTransaction{
                    usd: format!("${}", tx.usd),
                    datetime: Self::format_datetime(tx.confirmation_time.as_ref().map(|t| &t.1)),
                    is_withdraw: tx.is_withdraw,
                }
            ).collect()
        })?)
    }
    pub fn receive(&self) -> Result<String, Error> {
        Ok(serde_json::to_string(&Receive{
            address: self.state.get(Field::Address)?
        })?)
    }
}

#[derive(Serialize)]
struct BitcoinHomeTransaction {
    pub usd: String,
    pub datetime: String,
    pub is_withdraw: bool
}

#[derive(Serialize)]
struct BitcoinHome {
    pub usd: String,
    pub btc: String,
    pub transactions: Vec<BitcoinHomeTransaction>
}

#[derive(Serialize)]
struct Receive {
    pub address: String
}
