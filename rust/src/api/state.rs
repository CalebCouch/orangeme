use super::Error;

use super::simple::rustCall;
use super::pub_structs::{PageName, Platform, Thread, WalletMethod};
use super::wallet::{Transactions, Transaction};
use super::structs::{DateTime, Profile};

use log::info;
use simple_database::KeyValueStore;

use serde::{Serialize, Deserialize};

use bdk::bitcoin::hash_types::Txid;

use std::collections::BTreeMap;
use std::path::PathBuf;
use std::str::FromStr;

use num_format::{Locale, ToFormattedString};

use bdk::bitcoin::{Network, Address};
use web5_rust::dids::Identity;


pub type Internet = bool;

const SATS: u64 = 100_000_000;

#[derive(Serialize, Deserialize, Debug)]
#[serde(untagged)]
pub enum Field {
    Path(Option<String>),
    Price(Option<f64>),
    Internet(Option<bool>),
    Platform(Option<Platform>),

    Transactions(Option<Transactions>),
    Balance(Option<f64>),

//  LegacySeed(Option<Seed>),
//  DescriptorSet(Option<DescriptorSet>),
//  Profile(Option<Profile>),
//  Address(Option<String>),
//  Amount(Option<String>),
//  Priority(Option<u8>),
//  AmountErr(Option<String>),
//  AmountBTC(Option<f64>),
//  Decimals(Option<String>),
//  InputValidation(Option<bool>),
//  CurrentConversation(Option<Conversation>),
//  Conversations(Option<Vec<Conversation>>),
//  Users(Option<Vec<Profile>>),
//  CurrentTx(Option<Transaction>),
//  CurrentRawTx(Option<bdk::bitcoin::Transaction>),
}

impl Field {
    pub fn into_bytes(&self) -> Vec<u8> {
        format!("{:?}", self).split("(").collect::<Vec<&str>>()[0].as_bytes().to_vec()
    }
}



#[derive(Clone)]
pub struct State {
    store: Box<dyn KeyValueStore>,
}

impl State {
    pub async fn new<KVS: KeyValueStore + 'static>(
        path: PathBuf,
    ) -> Result<Self, Error> {
        Ok(State{
            store: Box::new(KVS::new(path).await?)
        })
    }

    pub async fn set(&self, field: Field) -> Result<(), Error> {
        self.store.set(&field.into_bytes(), &serde_json::to_vec(&field)?).await?;
        Ok(())
    }

    pub async fn get_raw(&self, field: Field) -> Result<Option<Vec<u8>>, Error> {
        Ok(self.store.get(&field.into_bytes()).await?)
    }

    pub async fn get_o<T: for <'a> Deserialize<'a>>(&self, field: Field) -> Result<Option<T>, Error> {
        Ok(self.get_raw(field).await?.map(|b|
            serde_json::from_slice::<Option<T>>(&b)
        ).transpose()?.flatten())
    }

    pub async fn get<T: for <'a> Deserialize<'a> + Default>(&self, field: Field) -> Result<T, Error> {
        Ok(self.get_o(field).await?.unwrap_or_default())
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

    pub async fn get(&mut self, page: PageName) -> Result<String, Error> {
        match page {
          //PageName::BitcoinHome => self.bitcoin_home().await,
          //PageName::Send => self.send().await,
          //PageName::ScanQR => self.scan_qr().await,
          //PageName::Amount => self.amount().await,
          //PageName::ConfirmTransaction => self.confirm_transaction().await,
          //PageName::Success => self.send_success().await,
          //PageName::ViewTransaction => self.view_transaction().await,
            PageName::BitcoinHome => self.bitcoin_home().await,
            PageName::Receive => self.receive().await,
            PageName::ViewTransaction(txid) => self.view_transaction(txid).await,
            PageName::Speed(address, amount) => self.speed(address, amount).await,
          //PageName::MessagesHome => self.messages_home().await,
          //PageName::Exchange => self.exchange().await,
          //PageName::MyProfile => self.my_profile().await,
          //PageName::UserProfile => self.user_profile().await,
          //PageName::ConvoInfo => self.conv_info().await,
          //PageName::ChooseRecipient => self.choose_recipient().await,
            PageName::Test => self.test().await,
        }
    }

    pub async fn test(&self) -> Result<String, Error> {
      //let state = SqliteStore::new(PathBuf::from(&path).join("TEST")).await.unwrap();
      //let count = state.get(b"test").await.unwrap().map(|b| u32::from_le_bytes(b.try_into().unwrap())).unwrap_or_default();
        //state.set(b"test", &(count+1).to_le_bytes()).await.unwrap();
        Ok(format!("{{\"count\": {}}}", 0))
    }

    pub async fn bitcoin_home(&self) -> Result<String, Error> {
       let btc = self.state.get::<f64>(Field::Balance(None)).await?;
       let price = self.state.get::<f64>(Field::Price(None)).await?;
       let usd = btc*price;
       let internet_status = self.state.get::<bool>(Field::Internet(None)).await?;
       let transactions = self.state.get::<BTreeMap<Txid, Transaction>>(Field::Transactions(None)).await?;

       let formatted_usd = if usd == 0.0 { "$0.00".to_string() } else { format!("{:.2}", usd) };

       Ok(serde_json::to_string(&BitcoinHome{
          internet: internet_status,
          usd: formatted_usd,
          btc: btc.to_string(),
          balance: usd,
          price,
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

    pub async fn view_transaction(&self, txid: String) -> Result<String, Error> {
        let txid = Txid::from_str(&txid).map_err(|e| Error::err("Txid::from_str", &e.to_string()))?;
        let transactions = self.state.get::<BTreeMap<Txid, Transaction>>(Field::Transactions(None)).await?;
        let tx = transactions.get(&txid).ok_or(Error::err("view_transaction", "No transaction found for txid"))?;


        let price = tx.price;
        let whole_part = price.trunc() as i64;
        let decimal_part = (price.fract() * 100.0).round() as i64;
        let formatted_price = format!("${}{}", whole_part.to_formatted_string(&Locale::en), if decimal_part > 0 { format!(".{:02}", decimal_part) } else { "".to_string() });

        let basic_tx = BasicTransaction {
            tx: ShorthandTransaction {
                is_withdraw: tx.is_withdraw,
                date: self.format_datetime(tx.confirmation_time.as_ref().map(|(_, dt)| dt)).0,
                time: self.format_datetime(tx.confirmation_time.as_ref().map(|(_, dt)| dt)).1,
                btc: tx.btc,
                usd: format!("${:.2}", tx.usd),
                txid: txid.to_string(),
            },
            address: tx.address.clone(),
            price: formatted_price,
        };

        let ext_transaction = if tx.is_withdraw {
            Some(ExtTransaction {
                tx: basic_tx.clone(),
                fee: format!("${:.2}", tx.fee_usd),
                total: format!("${:.2}", tx.fee_usd + tx.usd),
            })
        } else {
            None
        };

        Ok(serde_json::to_string(&ViewTransaction {
            basic_transaction: Some(basic_tx),
            ext_transaction,
        })?)
    }

    pub async fn speed(&self, address: String, amount: f64) -> Result<String, Error> {
        let price = self.state.get::<f64>(Field::Price(None)).await?;
        let fees = rustCall(Thread::Wallet(WalletMethod::GetFees(address, amount, price))).await;
        info!("{:?}", fees);
        Ok(serde_json::to_string(&Speed{
            fees: (0.0, 0.0),
        })?)
    }

    pub async fn receive(&self) -> Result<String, Error> {
        Ok(serde_json::to_string(&Receive{
            address: rustCall(Thread::Wallet(WalletMethod::GetNewAddress)).await
        })?)
    }

//      pub async fn my_profile(&self) -> Result<String, Error> {
//          let profile = self.state.get_o::<Profile>(Field::Profile).await?;
//          Ok(serde_json::to_string(&MyProfile{
//              profile: profile,
//          })?)
//      }

//      pub async fn user_profile(&self) -> Result<String, Error> {
//          Ok(serde_json::to_string(&UserProfile{
//              profile: None,
//          })?)
//      }



//      pub async fn messages_home(&mut self) -> Result<String, Error> {
//          //self.state.set(Field::Conversations, &conversations).await?;

//          Ok(serde_json::to_string(&MessagesHome{
//              profile_picture: "".to_string(),
//              conversations: None, 
//          })?)
//      }

//      pub async fn exchange(&self) -> Result<String, Error> {
//          let conversation = self.state.get::<Conversation>(Field::CurrentConversation).await?;
//          Ok(serde_json::to_string(&Exchange{
//              conversation: conversation,
//          })?)
//      }

//      pub async fn choose_recipient(&self) -> Result<String, Error> {
//          let users = self.state.get::<Vec<Profile>>(Field::Users).await?;
//          Ok(serde_json::to_string(&ChooseRecipient{
//              users: users,
//          })?)
//      }

//      pub async fn conv_info(&self) -> Result<String, Error> {
//          let conversation = self.state.get::<Conversation>(Field::CurrentConversation).await?;
//          let contacts = conversation.members;
//          Ok(serde_json::to_string(&ConvInfo{
//              contacts: contacts,
//          })?)
//      }

//      async fn get_wallet(&self) -> Result<Wallet, Error> {
//          let descriptors = self.state.get::<DescriptorSet>(Field::DescriptorSet).await?;
//          let path = self.state.get::<PathBuf>(Field::Path).await?;
//          Wallet::new(descriptors, path, self.state.clone())
//      }

    fn format_datetime(&self, datetime: Option<&DateTime>) -> (String, String) {
        datetime.map(|dt| (
            dt.format("%m/%d/%Y").to_string(),
            dt.format("%l:%M %p").to_string()
        )).unwrap_or(("Pending".to_string(), "Pending".to_string()))
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

//  #[derive(Serialize, Deserialize, Clone, Default)]
//  pub struct Conversation {
//      pub members: Vec<Profile>,
//      pub messages: Vec<Message>,
//  }

//  #[derive(Serialize, Deserialize, Clone)]
//  pub struct Message {
//      pub sender: Profile,
//      pub message: String,
//      pub date: String,
//      pub time: String,
//      pub is_incoming: bool,
//  }

/*      Page Structs        */

#[derive(Serialize)]
struct BitcoinHome {
    pub usd: String,
    pub btc: String,
    pub balance: f64,
    pub price: f64,
    pub transactions: Vec<ShorthandTransaction>,
    pub profile_picture: String,
    pub internet: bool,
}

#[derive(Serialize)]
struct Receive {
    pub address: String
}

#[derive(Serialize)]
struct Speed {
    pub fees: (f64, f64)
}

#[derive(Serialize)]
struct ViewTransaction {
    pub ext_transaction: Option<ExtTransaction>,
    pub basic_transaction: Option<BasicTransaction>,
}

//  #[derive(Serialize)]
//  struct Send {
//      pub valid: bool,
//      pub address: String
//  }

//  #[derive(Serialize)]
//  struct ScanQR {
//  }

//  #[derive(Serialize)]
//  struct Amount {
//      pub err: String,
//      pub amount: String,
//      pub decimals: String,
//      pub btc: f64,
//  }

//  #[derive(Serialize)]
//  struct Speed {
//      pub fees: (String, String)
//  }

//  #[derive(Serialize)]
//  struct ConfirmTransaction {
//      pub transaction: ExtTransaction,
//  }

//  #[derive(Serialize)]
//  struct SendSuccess {
//      pub usd: String,
//  }

//  #[derive(Serialize)]
//  struct ViewTransaction {
//      pub ext_transaction: Option<ExtTransaction>,
//      pub basic_transaction: Option<BasicTransaction>,
//  }

//  #[derive(Serialize)]
//  struct MessagesHome {
//      pub conversations: Option<Vec<Conversation>>,
//      pub profile_picture: String,
//  }

//  #[derive(Serialize)]
//  struct MyProfile {
//      pub profile: Option<Profile>
//  }

//  #[derive(Serialize)]
//  struct UserProfile {
//      pub profile: Option<Profile>
//  }

//  #[derive(Serialize)]
//  struct Exchange {
//      pub conversation: Conversation,
//  }

//  #[derive(Serialize)]
//  struct ChooseRecipient {
//      pub users: Vec<Profile>,
//  }

//  #[derive(Serialize)]
//  struct ConvInfo {
//      pub contacts: Vec<Profile>,
//  }
