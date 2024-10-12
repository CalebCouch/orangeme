use super::Error;

use super::wallet::{Wallet, DescriptorSet, Transaction};
use super::structs::DateTime;

use web5_rust::common::traits::KeyValueStore;

use serde::{Serialize, Deserialize};

use bdk::bitcoin::hash_types::Txid;

use std::collections::BTreeMap;
use std::path::PathBuf;

pub type Internet = bool;
pub type Price = f64;

#[derive(Debug)]
pub enum Field {
    DescriptorSet,
    Internet,
    Price,
    Path
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

    fn get_wallet(&self) -> Result<Wallet, Error> {
        let descriptors = self.state.get::<DescriptorSet>(Field::DescriptorSet)?;
        let path = self.state.get::<PathBuf>(Field::Path)?;
        Wallet::new(descriptors, path)
    }

    fn format_datetime(datetime: Option<&DateTime>) -> String {
        datetime
        .map(|dt| dt.format("%Y-%m-%d %l:%M %p").to_string())
        .unwrap_or("Pending".to_string())
    }

    

    pub fn get(&self, state_name: &str) -> Result<String, Error> {
        match state_name {
            "BitcoinHome" => self.bitcoin_home(),
            "Receive" => self.receive(),
            "ViewTransaction" => self.view_transaction(),
            "MessagesHome" => self.messages_home(),
            _ => Err(Error::bad_request("StateManager::get", &format!("No state with name {}", state_name)))
        }
    }

    pub fn bitcoin_home(&self) -> Result<String, Error> {
        let wallet = self.get_wallet()?;
        let btc = wallet.get_balance()?;
        let usd = btc*self.state.get::<Price>(Field::Price)?;
        let personal_data = self.get_personal_data()?; // Assuming a method that fetches user's personal data
        Ok(serde_json::to_string(&BitcoinHome{
            usd: usd.to_string(),
            btc: btc.to_string(),
            transactions: wallet.list_unspent()?.into_iter().map(|tx|
                if tx.is_withdraw {
                    TransactionType::Ext(ExtTransaction {
                        transaction: BasicTransaction {
                            transaction: ShorthandTransaction {
                                datetime: Self::format_datetime(tx.confirmation_time.as_ref().map(|t| &t.1)),
                                btc: tx.btc,
                                usd: format!("${}", tx.usd),
                            },
                            address: tx.address,
                            price: format!("${}", tx.price),
                        },
                        fee: format!("${}", tx.fee),
                        total: format!("${}", tx.usd + tx.fee),
                    })
                } else {
                    TransactionType::Basic(BasicTransaction {
                        transaction: ShorthandTransaction {
                            datetime: Self::format_datetime(tx.confirmation_time.as_ref().map(|t| &t.1)),
                            btc: tx.btc,
                            usd: format!("${}", tx.usd),
                        },
                        address: tx.address,
                        price: format!("${}", tx.price),
                    })
                }
            ).collect(),
            personal_data: personal_data, // Assuming 'personal_data' is of type 'Contact'
        })?)
    }

    pub fn receive(&self) -> Result<String, Error> {
        let wallet = self.get_wallet()?;
        Ok(serde_json::to_string(&Receive{
            address: wallet.get_new_address()?
        })?)
    }

    pub fn view_transaction(&self) -> Result<String, Error> {
        let tx = Transaction {
            btc: 0.00004567,
            usd: 9.34,
            btc_price: 63408.02,
            fee: 0.32,
        };        
        Ok(serde_json::to_string(&ViewTransaction{
            transaction: 
            if tx.is_withdraw {
                TransactionType::Ext(ExtTransaction {
                    transaction: BasicTransaction {
                        transaction: ShorthandTransaction {
                            datetime: Self::format_datetime(tx.confirmation_time.as_ref().map(|t| &t.1)),
                            btc: tx.btc,
                            usd: format!("${}", tx.usd),
                        },
                        address: tx.address,
                        price: format!("${}", tx.price),
                    },
                    fee: format!("${}", tx.fee),
                    total: format!("${}", tx.usd + tx.fee),
                })
            } else {
                TransactionType::Basic(BasicTransaction {
                    transaction: ShorthandTransaction {
                        datetime: Self::format_datetime(tx.confirmation_time.as_ref().map(|t| &t.1)),
                        btc: tx.btc,
                        usd: format!("${}", tx.usd),
                    },
                    address: tx.address,
                    price: format!("${}", tx.price),
                })
            }
        })?)
    }

    pub fn messages_home(&self) -> Result<String, Error> {
        let personal_data = self.get_personal_data()?; // Assuming a method that fetches user's personal data
        let conversations = self.get_conversations()?; // Assuming a method that fetches user's conversations
        Ok(serde_json::to_string(&MessagesHome{
            personal_data: personal_data, // Assuming 'personal_data' is of type 'Contact'
            conversations: conversations, // Assuming 'conversations' is a list of conversation data
        })?)
    }
}

enum TransactionType {
    Ext(ExtTransaction),
    Basic(BasicTransaction),
}

#[derive(Serialize)]
struct ExtTransaction {
    pub transaction: BasicTransaction,
    pub fee: String,
    pub total: String,
}


#[derive(Serialize)]
struct BasicTransaction {
    pub transaction: ShorthandTransaction,
    pub address: String,
    pub price: String,
}

#[derive(Serialize)]
struct ShorthandTransaction {
    pub datetime: String,
    pub btc: f64,
    pub usd: String,
}

#[derive(Serialize)]
struct Conversation {
    pub members: Vec<Contact>,
    pub messages: Vec<Message>,
}

#[derive(Serialize)]
struct Contact {
    pub name: String,
    pub did: String,
    pub pfp: String,
    pub abt_me: String,
}

#[derive(Serialize)]
struct Message {
    pub sender: Contact,
    pub message: String,
    pub datetime: String,
    pub is_incoming: bool,
}


#[derive(Serialize)]
struct BitcoinHome {
    pub usd: String,
    pub btc: String,
    pub transactions: Vec<ShorthandTransaction>,
    pub personal_data: Contact,
}

#[derive(Serialize)]
struct Receive {
    pub address: String
}

#[derive(Serialize)]
struct Send {}

#[derive(Serialize)]
struct ScanQR {}

#[derive(Serialize)]
struct Amount {}

#[derive(Serialize)]
struct Speed {}

#[derive(Serialize)]
struct Confirm {}

#[derive(Serialize)]
struct Success {}

#[derive(Serialize)]
struct ViewTransaction {
    pub transaction: Vec<ShorthandTransaction> //Either a transaction or a sent transaction
}

#[derive(Serialize)]
struct MessagesHome {
    pub conversations: Vec<Conversation>,
    pub personal_data: Contact,
}
