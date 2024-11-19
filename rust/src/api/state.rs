use super::Error;

use super::pub_structs::{
    ShorthandTransaction,
    Platform,
    PageName,
    SATS,
    Sats,
    Btc,
    Usd
};
use super::threads::{call_thread, Threads, WalletMethod};
use super::wallet::{Transactions, Transaction};
use super::structs::DateTime;
use super::web5::{Profile, ShorthandConversation, Conversation};

use std::collections::BTreeMap;
use std::path::PathBuf;
use std::str::FromStr;

use simple_database::KeyValueStore;

use serde::{Serialize, Deserialize};
use serde_json::json;

use bdk::bitcoin::{Network, Address};
use bdk::bitcoin::hash_types::Txid;

use num_format::{Locale, ToFormattedString};

#[derive(Serialize, Deserialize, Debug)]
#[serde(untagged)]
pub enum Field {
    Path(Option<PathBuf>),
    Price(Option<f64>),
    Internet(Option<bool>),
    Platform(Option<Platform>),

    Transactions(Option<Transactions>),
    Balance(Option<Sats>),

    Profile(Option<Profile>),

    Conversations(Option<Vec<Conversation>>),
    Users(Option<Vec<Profile>>),
}

impl Field {
    pub fn into_bytes(&self) -> Vec<u8> {
        format!("{:?}", self).split("(").collect::<Vec<&str>>()[0].as_bytes().to_vec()
    }
}

/* dummy data */
#[derive(Debug, Deserialize, PartialEq, Eq, PartialOrd, Ord)]
struct RoomID {
    id: u32,
}

impl RoomID {
    fn new(id: u32) -> Self {
        RoomID { id }
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

impl StateManager {
    pub fn new(state: State) -> Self {
        StateManager{state}
    }

    pub async fn get(&mut self, page: PageName) -> Result<String, Error> {
        match page {
            PageName::BitcoinHome => self.bitcoin_home().await,
            PageName::ViewTransaction(txid) => self.view_transaction(txid).await,
            PageName::Receive => self.receive().await,
            PageName::Send(address) => self.send(&address).await,
            PageName::Amount(amount) => self.amount(amount).await,
            PageName::Speed(amount) => self.speed(amount).await,
            PageName::Confirm(address, amount, fee) => self.confirm(address, amount, fee).await,
            PageName::Success(tx) => self.success(tx).await,
            PageName::MyProfile(init) => self.my_profile(init).await,
            PageName::MessagesHome => self.messages_home().await,
            PageName::ChooseRecipient => self.choose_recipient().await,
            PageName::Test(_) => self.test().await,
        }
    }

    pub async fn test(&self) -> Result<String, Error> {
        Ok(format!("{{\"count\": {}}}", 0))
    }

    /*      Bitcoin Home        */
    pub async fn bitcoin_home(&self) -> Result<String, Error> {
        let internet = self.state.get_or_default::<bool>(&Field::Internet(None)).await?;
        let profile_pfp = self.state.get_or_default::<Profile>(&Field::Profile(None)).await?.pfp_path;
        let balance = sats_to_btc(self.state.get_or_default::<Sats>(&Field::Balance(None)).await?);
        let transactions = self.state.get_or_default::<BTreeMap<Txid, Transaction>>(&Field::Transactions(None)).await?;
        let price = self.state.get_or_default::<Usd>(&Field::Price(None)).await?;
        //log::info!("transactions: {:#?}", transactions);
        let mut transactions = transactions.into_iter()
        .collect::<Vec<(Txid, Transaction)>>();
        transactions.sort_by_key(|(_, tx)| tx.confirmation_time.as_ref().unwrap_or(&tx.time_created).clone());
        transactions.reverse();

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
                    amount: format_usd(sats_to_btc(tx.sats)*tx.price),
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

        let btc = sats_to_btc(tx.sats);
        let usd = btc * tx.price;
        let fee_usd = sats_to_btc(tx.fee)*tx.price;

        Ok(serde_json::to_string(&json!({
            "is_withdraw": tx.is_withdraw,
            "date": dt.map(|dt| dt.format("%m/%d/%Y").to_string()).unwrap_or("Pending".to_string()),
            "time": dt.map(|dt| dt.format("%l:%M %p").to_string()).unwrap_or("Pending".to_string()),
            "address": format_adr(&tx.address),
            "amount_btc": format_btc(btc),
            "amount_usd": format_usd(usd),
            "price": format_usd(tx.price),
            "fee": if tx.is_withdraw {Some(format_usd(fee_usd))} else {None},
            "total": if tx.is_withdraw {Some(format_usd(fee_usd+usd))} else {None}
        }))?)
    }

    pub async fn receive(&self) -> Result<String, Error> {
        Ok(serde_json::to_string(&json!({
            "address": call_thread(Threads::Wallet(WalletMethod::GetNewAddress)).await?,
        }))?)
    }

    pub async fn send(&self, address: &str) -> Result<String, Error> {
        let valid_address = if address.is_empty() {true} else {Address::from_str(address).ok().map(|a| a.require_network(Network::Bitcoin).is_ok()).unwrap_or(false)};
        Ok(serde_json::to_string(&json!({
            "valid_address": valid_address,
        }))?)
    }

    pub async fn amount(&self, amount: String) -> Result<String, Error> {
        let price = self.state.get_or_default::<Usd>(&Field::Price(None)).await?;
        let balance = sats_to_btc(self.state.get_or_default::<Sats>(&Field::Balance(None)).await?) * price;

        let amount_usd = amount.parse::<Usd>().unwrap_or(0.0);
        let amount_btc = amount_usd / price;
        let amount_sats = (amount_btc * SATS as Btc) as Sats;

        let min: Usd = 0.30;
        let max = balance - min;

        let err = if amount_usd != 0.0 {
            if max <= 0.0 {
                Some("You don't have enough bitcoin".to_string())
            } else if amount_usd < min {
                Some(format!("${:.2} minimum", min))
            } else if amount_usd > max {
                Some(format!("${:.2} maximum", max))
            } else {
                None
            }
        } else {None};


        Ok(serde_json::to_string(&json!({
            "amount_btc": format_btc(amount_btc),
            "amount_sats": amount_sats,
            "err": err,
        }))?)
    }

    pub async fn speed(&self, amount: Sats) -> Result<String, Error> {
        let price = self.state.get_or_default::<Usd>(&Field::Price(None)).await?;
        let fees = serde_json::from_str::<(Sats, Sats)>(&call_thread(Threads::Wallet(WalletMethod::GetFees(amount))).await?)?;
        Ok(serde_json::to_string(&json!({
            "priority_f": format_usd((fees.0 as Btc / SATS as Btc) * price),
            "priority": fees.0,
            "standard_f": format_usd((fees.1 as Btc / SATS as Btc) * price),
            "standard": fees.1
        }))?)
    }

    pub async fn confirm(&self, address: String, amount_sats: Sats, fee: Sats) -> Result<String, Error> {
        let price = self.state.get_or_default::<Usd>(&Field::Price(None)).await?;
        let (btx, tx) = serde_json::from_str::<(bdk::bitcoin::Transaction, Transaction)>(
            &call_thread(Threads::Wallet(WalletMethod::BuildTransaction(
                address, amount_sats, fee, price
            ))).await?
        )?;
        let btc = sats_to_btc(tx.sats);
        let usd = btc * tx.price;
        let fee_usd = sats_to_btc(tx.fee)*tx.price;
        Ok(serde_json::to_string(&json!({
            "raw_tx": serde_json::to_string(&btx)?,
            "address_cut": format_adr(&tx.address),
            "address_whole": tx.address,
            "amount_btc": format_btc(btc),
            "amount_usd": format_usd(usd),
            "amount": format_usd(usd).replace("$", ""),
            "fee_usd": format_usd(fee_usd),
            "total": format_usd(usd + fee_usd),
        }))?)
    }

    pub async fn success(&self, raw_tx: String) -> Result<String, Error> {
        let tx: bdk::bitcoin::Transaction = serde_json::from_str(&raw_tx)?;
        call_thread(Threads::Wallet(WalletMethod::BroadcastTransaction(tx))).await?;
        Ok("{}".to_string())
    }

    /*      Messages Home        */

    // pub async fn messages_home(&self) -> Result<String, Error> {
    //     let profile_pfp = self.state.get_or_default::<Profile>(&Field::Profile(None)).await?.pfp_path;

    //     Ok(serde_json::to_string(&json!({
    //         "profile_picture": profile_pfp,
    //         "conversations": None, //ShorthandConversation
    //     }))?)
    // }

    pub async fn my_profile(&self, init: bool) -> Result<String, Error> {
        let profile = self.state.get::<Profile>(&Field::Profile(None)).await?;
        let address = if init {
            call_thread(Threads::Wallet(WalletMethod::GetNewAddress)).await?
        } else {String::new()};

        Ok(serde_json::to_string(&json!({
            "name": profile.name,
            "about_me": profile.abt_me,
            "did": profile.did,
            "profile_picture": profile.pfp_path,
            "address": address,
        }))?)
    }

    pub async fn messages_home(&self) -> Result<String, Error> {
        let profile_pfp = self.state.get_or_default::<Profile>(&Field::Profile(None)).await?.pfp_path;
        let conversations = self.state.get_or_default::<BTreeMap<RoomID, Conversation>>(&Field::Conversations(None)).await?;

        Ok(serde_json::to_string(&json!({
            "profile_picture": profile_pfp,
            "conversations": conversations.values().map(|cv| {
                let is_group = cv.members.len() > 1;
                let photo = if is_group { None } else { cv.members[0].pfp_path.clone() };

                ShorthandConversation{
                    room_name: if is_group { "Group Message".to_string() } else { cv.members[0].name.clone() },
                    photo,
                    subtext: if is_group { cv.messages[0].message.to_string() } else { format_names(&cv.members) },
                    room_id: "123".to_string(),
                    is_group,
                }
            }).collect::<Vec<ShorthandConversation>>()
        }))?)
    }


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

    pub async fn choose_recipient(&self) -> Result<String, Error> {
        let users = self.state.get_or_default::<Vec<Profile>>(&Field::Users(None)).await?;
        Ok(serde_json::to_string(&json!({
            "users": users.into_iter().map(|profile| {
                Profile{
                    name: profile.name,
                    did: profile.did,
                    abt_me: profile.abt_me,
                    pfp_path: profile.pfp_path,
                }
            }).collect::<Vec<Profile>>()
        }))?)
    }

//      pub async fn conv_info(&self) -> Result<String, Error> {
//          let conversation = self.state.get::<Conversation>(Field::CurrentConversation).await?;
//          let contacts = conversation.members;
//          Ok(serde_json::to_string(&ConvInfo{
//              contacts: contacts,
//          })?)
//      }

}

pub fn format_usd(price: Usd) -> String {
    let price = (price * 100.0).round() / 100.0;
    let whole_part = price.trunc() as i64;
    let decimal_part = ((price.fract() * 100.0) as u64) % 100;
    format!("${}.{:02}", whole_part.to_formatted_string(&Locale::en), decimal_part)
}

pub fn format_btc(btc: Btc) -> String {format!("{:.8} BTC", btc)}

pub fn sats_to_btc(sats: Sats) -> Btc {sats as Btc / SATS as Btc}

pub fn format_adr(adr: &str) -> String {
    if adr.starts_with("The ") { return "Redeposit".to_string();}
    format!("{}...{}", &adr[..9], &adr[adr.len()-3..])
}

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

fn format_names(cv: &[Profile]) -> String {
    let names: String = cv.iter().map(|profile| profile.name.as_str()).collect::<Vec<_>>().join(", ");
    if names.len() > 20 {return format!("{}...", &names[0..20]);}
    names
}
