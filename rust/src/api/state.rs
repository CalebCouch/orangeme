use super::Error;

use super::wallet::{Wallet, DescriptorSet, Transaction};
use super::structs::{DateTime, Profile};

use simple_database::KeyValueStore;

use serde::{Serialize, Deserialize};

use bdk::bitcoin::hash_types::Txid;

use std::collections::BTreeMap;
use std::path::PathBuf;
use std::str::FromStr;

use num_format::{Locale, ToFormattedString};

use bdk::bitcoin::{Network, Address};


pub type Internet = bool;

const SATS: u64 = 100_000_000;

#[derive(Debug)]
pub enum Field {
    Identity,
    LegacySeed,
    DescriptorSet,
    Internet,
    Platform,
    Profile,
    Address,
    Amount,
    Priority,
    AmountErr,
    AmountBTC,
    Decimals,
    InputValidation,
    Price,
    Path,
    Balance,
    CurrentConversation,
    Conversations,
    Users,
    Transactions,
    CurrentTx,
    CurrentRawTx,
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

    pub fn get_raw(&self, field: Field) -> Result<Option<Vec<u8>>, Error> {
        Ok(self.store.get(&field.into_bytes())?)
    }

    pub fn get_o<T: for <'a> Deserialize<'a>>(&self, field: Field) -> Result<Option<T>, Error> {
        Ok(self.store.get(&field.into_bytes())?.map(|b|
            serde_json::from_slice(&b)
        ).transpose()?)
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
        Wallet::new(descriptors, path, self.state.clone())
    }

    fn format_datetime(&self, datetime: Option<&DateTime>) -> (String, String) {
        datetime
            .map(|dt| (
                dt.format("%m/%d/%Y").to_string(),
                dt.format("%l:%M %p").to_string()
            ))
            .unwrap_or(("Pending".to_string(), "Pending".to_string()))
    }

    pub fn get_users(&self) -> Result<Vec<Contact>, Error> {
        let alice = Contact {
            abt_me: Some("Software Developer".to_string()),
            did: "did:example:alice".to_string(),
            name: "Alice".to_string(),
            pfp: Some("cat/on/a/box.png".to_string()),
        };
    
        let bob = Contact {
            abt_me: Some("Graphic Designer".to_string()),
            did: "did:example:bob".to_string(),
            name: "Bob".to_string(),
            pfp: Some("chicken/on/a/horse.png".to_string()),
        };

        Ok(vec![alice, bob])
    }

    pub fn get_conversations(&self) -> Result<Vec<Conversation>, Error> {
        let alice = Contact {
            abt_me: Some("Software Developer".to_string()),
            did: "did:example:alice".to_string(),
            name: "Alice".to_string(),
            pfp: None,
        };

        let bob = Contact {
            abt_me: Some("Graphic Designer".to_string()),
            did: "did:example:bob".to_string(),
            name: "Bob".to_string(),
            pfp: None,
        };

        let message1 = Message {
            sender: alice.clone(),
            message: "Hello, Bob!".to_string(),
            date: "2024-8-14".to_string(),
            time: "2:32 AM".to_string(),
            is_incoming: false,
        };

        let message2 = Message {
            sender: bob.clone(),
            message: "Hi Alice, how are you?".to_string(),
            date: "2024-8-14".to_string(),
            time: "2:32 AM".to_string(),
            is_incoming: true,
        };

        let conversation1 = Conversation {
            members: vec![alice.clone(), bob.clone()], 
            messages: vec![message1, message2],  
        };

        let conversation2 = Conversation {
            members: vec![alice.clone()],
            messages: vec![
                Message {
                    sender: bob.clone(),
                    message: "Are you free for a meeting tomorrow?".to_string(),
                    date: "2024-8-14".to_string(),
                    time: "12:34 PM".to_string(),
                    is_incoming: false,
                },
                Message {
                    sender: alice.clone(),
                    message: "Yes, I am available!".to_string(),
                    date: "2024-8-14".to_string(),
                    time: "12:34 PM".to_string(),
                    is_incoming: true,
                },
            ],
        };

        Ok(vec![conversation1, conversation2])
    }

    pub fn get(&mut self, state_name: &str, options: &str) -> Result<String, Error> {
        match state_name {
            "BitcoinHome" => self.bitcoin_home(),
            "Receive" => self.receive(),
            "Send" => self.send(),
            "ScanQR" => self.scan_qr(),
            "Amount" => self.amount(),
            "Speed" => self.speed(),
            "ConfirmTransaction" => self.confirm_transaction(),
            "Success" => self.send_success(),
            "ViewTransaction" => self.view_transaction(options),
            "MessagesHome" => self.messages_home(),
            "Exchange" => self.exchange(),
            "MyProfile" => self.my_profile(),
            "ConvInfo" => self.conv_info(),
            "ChooseRecipient" => self.choose_recipient(),
            _ => Err(Error::bad_request("StateManager::get", &format!("No state with name {}", state_name)))
        }
    }


    pub fn bitcoin_home(&self) -> Result<String, Error> {
        let btc = self.state.get::<f64>(Field::Balance)?;
        let usd = btc*self.state.get::<f64>(Field::Price)?;
        let internet_status = self.state.get::<bool>(Field::Internet)?;
        let transactions = self.state.get::<BTreeMap<Txid, Transaction>>(Field::Transactions)?;

        let formatted_usd = if usd == 0.0 {
            "$0.00".to_string()
        } else {
            format!("{:.2}", usd)
        };

        Ok(serde_json::to_string(&BitcoinHome{
            internet: internet_status,
            usd: formatted_usd,
            btc: btc.to_string(),
            transactions: transactions.into_iter().map(|(txid, tx)|
                ShorthandTransaction {
                    is_withdraw: tx.is_withdraw,
                    date: self.format_datetime(tx.confirmation_time.as_ref().map(|(_, dt)| dt)).0,
                    time: self.format_datetime( tx.confirmation_time.as_ref().map(|(_, dt)| dt)).1,
                    btc: tx.btc,
                    usd: format!("${:.2}", tx.usd),
                    txid: txid.to_string(),
                },
            ).collect(),
            profile_picture: "".to_string(),
        })?)
    }

    pub fn send(&self) -> Result<String, Error> {
        let mut address = self.state.get::<String>(Field::Address)?;
        if let Some(stripped) = address.strip_prefix("bitcoin:") { address = stripped.to_string(); }
        let valid = Address::from_str(&address)
        .map(|a| a.require_network(Network::Bitcoin).is_ok())
        .unwrap_or(false);
        Ok(serde_json::to_string(&Send{
           valid: valid,
           address: address
        })?)
    }

    pub fn scan_qr(&self) -> Result<String, Error> {
        Ok(serde_json::to_string(&ScanQR{
        })?)
    }

    pub fn amount(&mut self) -> Result<String, Error> {
        let amount = self.state.get::<String>(Field::Amount)?;
        let err = self.state.get::<Option<String>>(Field::AmountErr)?; 
        let decimals = self.state.get::<String>(Field::Decimals)?; 
        let btc = self.state.get::<f64>(Field::AmountBTC)?;
        Ok(serde_json::to_string(&Amount{
            err: err.unwrap_or_default(),
            amount,
            decimals,
            btc,
        })?)
    }

    pub fn speed(&self) -> Result<String, Error> {
        let address = self.state.get::<String>(Field::Address)?;
        let amount = self.state.get::<f64>(Field::AmountBTC)?;
        let price = self.state.get::<f64>(Field::Price)?;
        let wallet = self.get_wallet()?;
        let fees: (f64, f64) = wallet.get_fees(address, amount, price)?;
        let fees_str: (String, String) = (
            format!("${:.2}", fees.0),
            format!("${:.2}", fees.1)
        );
        Ok(serde_json::to_string(&Speed{
           fees: fees_str,
        })?)
    }

    pub fn confirm_transaction(&self) -> Result<String, Error> {
        let mut wallet = self.get_wallet()?;
        let x = self.state.get::<Transaction>(Field::CurrentTx)?;
        let raw_tx = self.state.get_o::<bdk::bitcoin::Transaction>(Field::CurrentRawTx)?;
        let price = self.state.get::<f64>(Field::Price)?;
        wallet.build_transaction()?;
        let txid = raw_tx.ok_or(Error::err("Failed to get transaction", "raw_tx is None or Err"))?.txid();
        let transaction = ExtTransaction {
            tx: BasicTransaction {
                tx: ShorthandTransaction {
                    is_withdraw: x.is_withdraw,
                    date: self.format_datetime(x.confirmation_time.as_ref().map(|(_, dt)| dt)).0,
                    time: self.format_datetime(x.confirmation_time.as_ref().map(|(_, dt)| dt)).1,
                    btc: x.btc,
                    usd: format!("${:.2}", x.usd),
                    txid: txid.to_string(),
                },
                address: x.address.clone(),
                price: format!("${:.2}", x.price),
            },
            fee: format!("${:.2}", x.fee_usd),
            total: format!("${:.2}", x.fee_usd + x.usd),
        };
        
        Ok(serde_json::to_string(&ConfirmTransaction {
            transaction: transaction
        })?)
    }

    pub fn send_success(&self) -> Result<String, Error> {
        let tx = self.state.get::<Transaction>(Field::CurrentTx)?;

        Ok(serde_json::to_string(&SendSuccess{
            usd:  format!("${:.2}", tx.usd)
        })?)
    }


    pub fn receive(&self) -> Result<String, Error> {
        let wallet = self.get_wallet()?;
        Ok(serde_json::to_string(&Receive{
            address: wallet.get_new_address()?
        })?)
    }

    pub fn my_profile(&self) -> Result<String, Error> {
        let profile = self.state.get_o::<Profile>(Field::Profile)?.ok_or(Error::err("my_profile", "Profile not found"))?;
        Ok(serde_json::to_string(&profile)?)
    }

    pub fn usd_to_btc(&self, amount: String) -> Result<f64, Error> {
        let amt: f64 = amount.parse().map_err(|_| Error::err("usd_to_btc", "Invalid amount format"))?;
        let price = self.state.get::<f64>(Field::Price)?;
        let btc_amount = amt / price;

        Ok(btc_amount)
    }

    pub fn view_transaction(&self, options: &str) -> Result<String, Error> {
        let txid = Txid::from_str(options).map_err(|e| Error::err("Txid::from_str", &e.to_string()))?;

        let wallet = self.get_wallet()?;
        let tx = wallet.get_tx(&txid);
        let x = tx.unwrap();

        let price = x.price;
        let whole_part = price.trunc() as i64;
        let decimal_part = (price.fract() * 100.0).round() as i64;
        let formatted_price = format!("${}{}", whole_part.to_formatted_string(&Locale::en), if decimal_part > 0 { format!(".{:02}", decimal_part) } else { "".to_string() });

        let basic_tx = BasicTransaction {
            tx: ShorthandTransaction {
                is_withdraw: x.is_withdraw,
                date: self.format_datetime(x.confirmation_time.as_ref().map(|(_, dt)| dt)).0,
                time: self.format_datetime(x.confirmation_time.as_ref().map(|(_, dt)| dt)).1,
                btc: x.btc,
                usd: format!("${:.2}", x.usd),
                txid: txid.to_string(),
            },
            address: x.address.clone(),
            price: formatted_price,
        };

        let ext_transaction = if x.is_withdraw {
            Some(ExtTransaction {
                tx: basic_tx.clone(),
                fee: format!("${:.2}", x.fee_usd),
                total: format!("${:.2}", x.fee_usd + x.usd),
            })
        } else {
            None
        };

        Ok(serde_json::to_string(&ViewTransaction {
            basic_transaction: Some(basic_tx),
            ext_transaction,
        })?)
    }

    pub fn messages_home(&mut self) -> Result<String, Error> {
        let conversations = self.get_conversations()?; 
        self.state.set(Field::Conversations, &conversations)?;

        Ok(serde_json::to_string(&MessagesHome{
            profile_picture: "".to_string(),
            conversations: conversations, 
        })?)
    }

    pub fn exchange(&self) -> Result<String, Error> {
        let conversation = self.state.get::<Conversation>(Field::CurrentConversation)?;
        Ok(serde_json::to_string(&Exchange{
            conversation: conversation,
        })?)
    }

    pub fn choose_recipient(&self) -> Result<String, Error> {
        let users = self.get_users()?;
        Ok(serde_json::to_string(&ChooseRecipient{
            users: users,
        })?)
    }

    pub fn conv_info(&self) -> Result<String, Error> {
        let conversation = self.state.get::<Conversation>(Field::CurrentConversation)?;
        let contacts = conversation.members;
        Ok(serde_json::to_string(&ConvInfo{
            contacts: contacts,
        })?)
    }
}

#[derive(Serialize, Clone, Debug)]
struct ExtTransaction {
    pub tx: BasicTransaction,
    pub fee: String,
    pub total: String,
}

#[derive(Serialize, Clone, Debug)]
struct BasicTransaction {
    pub tx: ShorthandTransaction,
    pub address: String,
    pub price: String,
}

#[derive(Serialize, Clone, Debug)]
struct ShorthandTransaction {
    pub is_withdraw: bool,
    pub date: String,
    pub time: String,
    pub btc: f64,
    pub usd: String,
    pub txid: String,
}

#[derive(Serialize, Deserialize, Clone, Default)]
pub struct Conversation {
    pub members: Vec<Contact>,
    pub messages: Vec<Message>,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct Contact {
    pub name: String,
    pub did: String,
    pub pfp: Option<String>,
    pub abt_me: Option<String>,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct Message {
    pub sender: Contact,
    pub message: String,
    pub date: String,
    pub time: String,
    pub is_incoming: bool,
}

#[derive(Serialize)]
struct BitcoinHome {
    pub usd: String,
    pub btc: String,
    pub transactions: Vec<ShorthandTransaction>,
    pub profile_picture: String,
    pub internet: bool,
}

#[derive(Serialize)]
struct Receive {
    pub address: String
}

#[derive(Serialize)]
struct Send {
    pub valid: bool,
    pub address: String
}

#[derive(Serialize)]
struct ScanQR {
}

#[derive(Serialize)]
struct Amount {
    pub err: String,
    pub amount: String,
    pub decimals: String,
    pub btc: f64,
}

#[derive(Serialize)]
struct Speed {
    pub fees: (String, String)
}

#[derive(Serialize)]
struct ConfirmTransaction {
    pub transaction: ExtTransaction,
}

#[derive(Serialize)]
struct SendSuccess {
    pub usd: String,
}

#[derive(Serialize)]
struct ViewTransaction {
    pub ext_transaction: Option<ExtTransaction>,
    pub basic_transaction: Option<BasicTransaction>,
}

#[derive(Serialize)]
struct MessagesHome {
    pub conversations: Vec<Conversation>,
    pub profile_picture: String,
}

#[derive(Serialize)]
struct MyProfile {
    pub personal: Contact
}

#[derive(Serialize)]
struct Exchange {
    pub conversation: Conversation,
}

#[derive(Serialize)]
struct ChooseRecipient {
    pub users: Vec<Contact>,
}

#[derive(Serialize)]
struct ConvInfo {
    pub contacts: Vec<Contact>,
}
