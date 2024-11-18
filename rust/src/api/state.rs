use super::Error;

use super::simple::{rustCall, Threads, WalletMethod};
use super::pub_structs::{PageName, Platform, ShorthandTransaction, KeyPress};
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

use num_format::{Locale, ToFormattedString, };
use thousands::Separable;

#[derive(Serialize, Deserialize, Debug)]
#[serde(untagged)]
pub enum Field {
    Path(Option<PathBuf>),
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


pub fn format_usd(price: Usd) -> String {
    let whole_part = price.trunc() as i64;
    let decimal_part = ((price.fract() * 100.0) as u64) % 100; 
    format!("${}.{:02}", whole_part.to_formatted_string(&Locale::en), decimal_part)
}

pub fn format_btc(btc: Btc) -> String {format!("{:.8} BTC", btc)}
pub fn format_adr(adr: &str) -> String {format!("{}...{}", &adr[..9], &adr[adr.len()-3..])}

pub fn format_datetime(date: Option<&DateTime>) -> String {
    if let Some(dt) = date {
        let duration = DateTime::now().date.signed_duration_since(dt.date);
        if duration.num_days() == 0 {
            dt.format("%l:%M %p").to_string()
        } else if duration.num_days() == 1 {
            "Yesterday".to_string()
        } else if duration.num_days() <= 365 {
            dt.format("%B %e").to_string()
        } else {
            dt.format("%m/%d/%Y").to_string()
        }
    } else {"Pending".to_string()}
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
          //PageName::ConfirmTransaction => self.confirm_transaction().await,
          //PageName::Success => self.send_success().await,
          //PageName::ViewTransaction => self.view_transaction().await,
            PageName::BitcoinHome => self.bitcoin_home().await,
            PageName::ViewTransaction(txid) => self.view_transaction(txid).await,
            PageName::Receive => self.receive().await,
            PageName::Amount(amount, key_press) => self.amount(amount, key_press).await,
            PageName::Speed(amount) => self.speed(amount).await,
            PageName::Confirm(address, amount, fee) => self.confirm(address, amount, fee).await,
            PageName::Success(tx) => self.success(tx).await,
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
        let profile_pfp = self.state.get_or_default::<Profile>(&Field::Profile(None)).await?.pfp_path;
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
                    datetime: date_time,
                    amount: format_usd(tx.usd),
                    txid: txid.to_string()
                }
            }).collect::<Vec<ShorthandTransaction>>()
        }))?)
    }

    pub async fn view_transaction(&self, txid: String) -> Result<String, Error> {
        let txid = Txid::from_str(&txid).map_err(|e| Error::err("Txid::from_str", &e.to_string()))?;
        let transactions = self.state.get_or_default::<BTreeMap<Txid, Transaction>>(&Field::Transactions(None)).await?;
        let tx = transactions.get(&txid).ok_or(Error::err("view_transaction", "No transaction found for txid"))?;
        let dt = tx.confirmation_time.as_ref();

        Ok(serde_json::to_string(&json!({
            "is_withdraw": tx.is_withdraw,
            "date": dt.map(|dt| dt.format("%m/%d/%Y").to_string()).unwrap_or("Pending".to_string()),
            "time": dt.map(|dt| dt.format("%l:%M %p").to_string()).unwrap_or("Pending".to_string()),
            "address": format_adr(&tx.address),
            "amount_btc": format_btc(tx.btc),
            "amount_usd": format_usd(tx.usd),
            "price": format_usd(tx.price),
            "fee": if tx.is_withdraw {Some(format_usd(tx.fee_usd))} else {None},
            "total": if tx.is_withdraw {Some(format_usd(tx.fee_usd+tx.usd))} else {None}
        }))?)
    }

    pub async fn receive(&self) -> Result<String, Error> {
        Ok(serde_json::to_string(&json!({
            "address": rustCall(Threads::Wallet(WalletMethod::GetNewAddress)).await?,
        }))?)
    }

    pub async fn send(&self, address: &str) -> Result<String, Error> {
        let valid_address = if address.is_empty() {true} else {Address::from_str(address).ok().map(|a| a.require_network(Network::Bitcoin).is_ok()).unwrap_or(false)};
        Ok(serde_json::to_string(&json!({
            "valid_address": valid_address,
        }))?)
    }

    pub async fn amount(&self, amount: String, key: Option<KeyPress>) -> Result<String, Error> {
        let price = self.state.get_or_default::<Usd>(&Field::Price(None)).await?;
        let balance = self.state.get_or_default::<Btc>(&Field::Balance(None)).await? * price;

        let is_zero = || amount == "0";
        let zero = "0".to_string();

        let (updated_amount, valid_input) = if let Some(key) = key {
            match key {
                KeyPress::Reset => ("0".to_string(), true),
                KeyPress::Backspace => {
                    if is_zero() {
                        (zero, false)
                    } else if amount.len() == 1 {
                        (zero, true)
                    } else {
                        (amount[..amount.len() - 1].to_string(), true)
                    }
                },
                KeyPress::Decimal => {
                    if !amount.contains('.') && amount.len() <= 7 {
                        (format!("{}{}", amount, "."), true)
                    } else {
                        (amount.clone(), false)
                    }
                },
                input => {
                    let input = input as i64;
                    if is_zero() {
                        (input.to_string(), true)
                    } else if amount.contains('.') {
                        let split: Vec<&str> = amount.split('.').collect();
                        if amount.len() < 11 && split[1].len() < 2 {
                            (format!("{}{}", amount, input), true)
                        } else {
                            (amount.clone(), false)
                        }
                    } else if amount.len() < 10 {
                        (format!("{}{}", amount, input), true)
                    } else {
                        (amount.clone(), false)
                    }
                }
            }
        } else {
            if amount.is_empty() {
                ("0".to_string(), true)
            } else {
                (amount, true)
            }
        };

        let needed_placeholders = if updated_amount.contains('.') {
            let split: Vec<&str> = updated_amount.split('.').collect();
            2-split.get(1).unwrap_or(&"").len() as u8
        } else {0};

        let updated_amount_usd = updated_amount.parse::<Usd>().unwrap_or(0.0);
        let amount_btc = updated_amount_usd / price;
        let amount_sats = (amount_btc * SATS as Btc) as Sats;

        let min: Usd = 0.30;//serde_json::from_str::<(Usd, Usd)>(&rustCall(Thread::Wallet(WalletMethod::GetFees(std::cmp::max(amount_sats, 5460), price))).await?)?.1;
        let max = balance - min;

        let err = if updated_amount_usd != 0.0 {
            if max <= 0.0 {
                Some("You don't have enough bitcoin".to_string())
            } else if updated_amount_usd < min {
                Some(format!("${:.2} minimum", min))
            } else if updated_amount_usd > max {
                Some(format!("${:.2} maximum", max))
            } else {
                None
            }
        } else {None};


        Ok(serde_json::to_string(&json!({
            "amount": updated_amount,
            "amount_btc": format_btc(amount_btc),
            "amount_sats": amount_sats,
            "needed_placeholders": needed_placeholders,
            "valid_input": valid_input,
            "err": err,
        }))?)
    }

    pub async fn speed(&self, amount: Sats) -> Result<String, Error> {
        let price = self.state.get_or_default::<Usd>(&Field::Price(None)).await?;
        let fees = serde_json::from_str::<(Sats, Sats)>(&rustCall(Threads::Wallet(WalletMethod::GetFees(amount))).await?)?;
        Ok(serde_json::to_string(&json!({
            "one_f": format_usd((fees.0 as Btc / SATS as Btc) * price),
            "one": fees.0,
            "three_f": format_usd((fees.1 as Btc / SATS as Btc) * price),
            "three": fees.1
        }))?)
    }

    pub async fn confirm(&self, address: String, amount_sats: Sats, fee: Sats) -> Result<String, Error> {
        log::info!("fee c: {}", fee);
        let price = self.state.get_or_default::<Usd>(&Field::Price(None)).await?;
        let (btx, tx) = serde_json::from_str::<(bdk::bitcoin::Transaction, Transaction)>(&rustCall(Threads::Wallet(WalletMethod::BuildTransaction(address, amount_sats, fee, price))).await?)?;
        log::info!("transaction: {:#?}", btx);
        log::info!("transaction: {:#?}", tx);
        Ok(serde_json::to_string(&json!({
            "raw_tx": serde_json::to_string(&btx)?,
            "address_cut": format_adr(&tx.address),
            "address_whole": tx.address,
            "amount_btc": format_btc(tx.btc),
            "amount_usd": format_usd(tx.usd),
            "amount": format_usd(tx.usd).replace('$', "").trim(),
            "fee_usd": format_usd(tx.fee_usd),
            "total": format_usd(tx.usd + tx.fee_usd),
        }))?)
    }

    pub async fn success(&self, raw_tx: String) -> Result<String, Error> {
        let tx: bdk::bitcoin::Transaction = serde_json::from_str(&raw_tx)?;
        rustCall(Threads::Wallet(WalletMethod::BroadcastTransaction(tx))).await?;
        Ok("{}".to_string())
    }



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
