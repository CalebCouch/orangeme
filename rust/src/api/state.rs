use super::Error;

use super::simple::rustCall;
use super::pub_structs::{PageName, Platform, Thread, WalletMethod, ShorthandTransaction};
use super::pub_structs::{SATS, Sats, Btc, Usd};
use super::wallet::{Transactions, Transaction};
use super::structs::{DateTime};
use super::web5::Profile;

use log::info;
use simple_database::KeyValueStore;

use serde::{Serialize, Deserialize};
use serde_json::json;

use bdk::bitcoin::hash_types::Txid;

use std::collections::BTreeMap;
use std::path::PathBuf;
use std::str::FromStr;

use bdk::bitcoin::{Network, Address};
use web5_rust::dids::Identity;

use num_format::{Locale, ToFormattedString};

#[derive(Serialize, Deserialize, Debug)]
#[serde(untagged)]
pub enum Field {
    Path(Option<String>),
    Price(Option<f64>),
    Internet(Option<bool>),
    Platform(Option<Platform>),

    Transactions(Option<Transactions>),
    Balance(Option<f64>),

    Profile(Option<Profile>),
  //Conversations(Option<Vec<Conversation>>),

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

    pub async fn get_raw(&self, field: &Field) -> Result<Option<Vec<u8>>, Error> {
        Ok(self.store.get(&field.into_bytes()).await?)
    }

    pub async fn get_o<T: for <'a> Deserialize<'a>>(&self, field: &Field) -> Result<Option<T>, Error> {
        Ok(self.get_raw(field).await?.map(|b|
            serde_json::from_slice::<Option<T>>(&b)
        ).transpose()?.flatten())
    }

    pub async fn get_or_default<T: for <'a> Deserialize<'a> + Default>(&self, field: &Field) -> Result<T, Error> {
        Ok(self.get_o(field).await?.unwrap_or_default())
    }

    pub async fn get<T: for <'a> Deserialize<'a>>(&self, field: &Field) -> Result<T, Error> {
        self.get_o(field).await?.ok_or(Error::not_found("State.get_f", &format!("Value not found for field: {:?}", field)))
    }
}

#[derive(Clone)]
pub struct StateManager {
    state: State,
}

pub fn format_datetime(datetime: Option<&DateTime>) -> (String, String) {
    datetime.map(|dt| (
        dt.format("%m/%d/%Y").to_string(),
        dt.format("%l:%M %p").to_string()
    )).unwrap_or(("Pending".to_string(), "Pending".to_string()))
}

pub fn format_usd(usd: Usd) -> String {
    if usd == 0.0 {"$0.00".to_string()} else {format!("${:.2}", usd)}
}

pub fn format_btc(btc: Btc) -> String {
    format!("{:.8} BTC", btc)
}

pub fn format_price(price: Usd) -> String {
    let whole_part = price.trunc() as i64;
    let decimal_part = (price.fract() * 100.0).round() as i64;
    format!("${}{}", whole_part.to_formatted_string(&Locale::en), if decimal_part > 0 { format!(".{:02}", decimal_part) } else { "".to_string() })
}

impl StateManager {
    pub fn new(state: State) -> Self {
        StateManager{state}
    }

    pub async fn get(&mut self, page: PageName) -> Result<String, Error> {
        match page {
          //PageName::BitcoinHome => self.bitcoin_home().await,
            PageName::Send(address) => self.send(&address).await,
          //PageName::ScanQR => self.scan_qr().await,
          //PageName::Amount => self.amount().await,
          //PageName::ConfirmTransaction => self.confirm_transaction().await,
          //PageName::Success => self.send_success().await,
          //PageName::ViewTransaction => self.view_transaction().await,
            PageName::BitcoinHome => self.bitcoin_home().await,
            PageName::Receive => self.receive().await,
          //PageName::ViewTransaction(txid) => self.view_transaction(txid).await,
          //PageName::Speed(amount) => self.speed(amount).await,
          //PageName::MyProfile => self.my_profile().await,
          //PageName::MessagesHome => self.messages_home().await,
          //PageName::Exchange => self.exchange().await,
          //PageName::MyProfile => self.my_profile().await,
          //PageName::UserProfile => self.user_profile().await,
          //PageName::ConvoInfo => self.conv_info().await,
          //PageName::ChooseRecipient => self.choose_recipient().await,
            PageName::Test(_) => self.test().await,
        }
    }

    pub async fn test(&self) -> Result<String, Error> {
        Ok(format!("{{\"count\": {}}}", 0))
    }

    pub async fn bitcoin_home(&self) -> Result<String, Error> {
        let internet = self.state.get_or_default::<bool>(&Field::Internet(None)).await?;
        let profile_pfp = self.state.get::<Profile>(&Field::Profile(None)).await?.pfp_path;
        let balance = self.state.get_or_default::<Btc>(&Field::Balance(None)).await?;
        let transactions = self.state.get_or_default::<BTreeMap<Txid, Transaction>>(&Field::Transactions(None)).await?;
        let price = self.state.get_or_default::<Usd>(&Field::Price(None)).await?;

        Ok(serde_json::to_string(&json!({
            "internet": internet,
            "balance_btc": format_btc(balance),
            "balance_usd": format_usd(balance*price),
            "profile_picture": profile_pfp,
            "transactions": transactions.into_iter().map(|(txid, tx)| {
                let date_time = format_datetime(tx.confirmation_time.as_ref());
                ShorthandTransaction{
                    is_withdraw: tx.is_withdraw,
                    date: date_time.0,
                    time: date_time.1,
                    amount: format_usd(tx.usd),
                    txid: txid.to_string()
                }
            }).collect::<Vec<ShorthandTransaction>>()
        }))?)
    }

    pub async fn receive(&self) -> Result<String, Error> {
        Ok(serde_json::to_string(&json!({
            "address": rustCall(Thread::Wallet(WalletMethod::GetNewAddress)).await?,
        }))?)
    }

    pub async fn send(&self, address: &str) -> Result<String, Error> {
        let valid_address = Address::from_str(address).ok().map(|a| a.require_network(Network::Bitcoin).is_ok()).unwrap_or(false);
        Ok(serde_json::to_string(&json!({
            "valid_address": valid_address,
        }))?)
    }

    pub async fn view_transaction(&self, txid: String) -> Result<String, Error> {
        let txid = Txid::from_str(&txid).map_err(|e| Error::err("Txid::from_str", &e.to_string()))?;
        let transactions = self.state.get_or_default::<BTreeMap<Txid, Transaction>>(&Field::Transactions(None)).await?;
        let tx = transactions.get(&txid).ok_or(Error::err("view_transaction", "No transaction found for txid"))?;

SingleTab(title: "Date", subtitle: tx.date),
            SingleTab(title: "Time", subtitle: tx.time),
            SingleTab(title: "Sent to Address", subtitle: tx.address),
            SingleTab(title: "Amount Sent", subtitle: tx.amount_btc),
            SingleTab(title: "Bitcoin Price", subtitle: tx.price),
            SingleTab(title: "USD Value Sent", subtitle: tx.amount_usd),
            const Spacing(AppPadding.content),
            SingleTab(title: "Fee", subtitle: tx.fee),
            SingleTab(title: "Total Amount", subtitle: tx.total),

        


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

//  pub async fn speed(&self, amount: Sats) -> Result<String, Error> {
//      let price = self.state.get_or_default::<Usd>(&Field::Price(None)).await?;
//      let fees = rustCall(Thread::Wallet(WalletMethod::GetFees(amount, price))).await;
//      info!("{:?}", fees);
//      Ok(serde_json::to_string(&Speed{
//          fees: (0.0, 0.0),
//      })?)
//  }

    

//  pub async fn my_profile(&self) -> Result<String, Error> {
//      let profile = self.state.get::<Profile>(&Field::Profile(None)).await?;
//      Ok(serde_json::to_string(&MyProfile{
//          profile: profile,
//          address: rustCall(Thread::Wallet(WalletMethod::GetNewAddress)).await?
//      })?)
//  }

//  pub async fn messages_home(&mut self) -> Result<String, Error> {
//      let conversations = self.state.get::<Vec<Conversation>>(&Field::Conversations(None)).await?;

//      Ok(serde_json::to_string(&MessagesHome{
//          profile_picture: "".to_string(),
//          conversations: conversations, 
//      })?)
//  }


    //  pub async fn user_profile(&self) -> Result<String, Error> {
    //      Ok(serde_json::to_string(&UserProfile{
    //          profile: None,
    //      })?)
    //  }


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
}

/*      Transactions        */



/*      Conversation        */

//  #[derive(Serialize, Deserialize, Clone, Default, Debug)]
//  pub struct Conversation {
//      pub members: Vec<Profile>,
//      pub messages: Vec<Message>,
//  }

//  #[derive(Serialize, Deserialize, Clone, Debug)]
//  pub struct Message {
//      pub sender: Profile,
//      pub message: String,
//      pub date: String,
//      pub time: String,
//      pub is_incoming: bool,
//  }

/*      Bitcoin Flow        */

//  #[derive(Serialize)]
//  struct BitcoinHome {
//      pub usd: String,
//      pub btc: String,
//      pub balance: f64,
//      pub price: f64,
//      pub transactions: Vec<ShorthandTransaction>,
//      pub profile_picture: String,
//      pub internet: bool,
//  }

//  #[derive(Serialize)]
//  struct Receive {
//      pub address: String
//  }

//  #[derive(Serialize)]
//  struct Speed {
//      pub fees: (f64, f64)
//  }

//  #[derive(Serialize)]
//  struct ViewTransaction {
//      pub ext_transaction: Option<ExtTransaction>,
//      pub basic_transaction: Option<BasicTransaction>,
//  }

//  /*      Messages Flow        */

//  #[derive(Serialize)]
//  struct MyProfile {
//      pub profile: Profile,
//      pub address: String,
//  }

//  #[derive(Serialize)]
//  struct MessagesHome {
//      pub conversations: Vec<Conversation>,
//      pub profile_picture: String,
//  }

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
