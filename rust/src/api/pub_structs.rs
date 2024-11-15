use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub enum Platform {
    Mac,
    Linux,
    Windows,
    IOS,
    Android,
    Fuchsia
}

impl Platform {
    #[flutter_rust_bridge::frb(sync)]
    pub fn is_desktop(&self) -> bool {
        matches!(self, Platform::Mac | Platform::Linux | Platform::Windows)
    }
}

pub enum Thread {
    Wallet(WalletMethod)
}

pub enum WalletMethod {
    GetNewAddress,
    GetFees(Sats, Usd),
}

#[derive(Debug)]
pub enum PageName {
    BitcoinHome,
    Receive,
  //Speed(Sats),
  //ViewTransaction(String),
  //MyProfile,
  //MessagesHome,
//  Receive,
//  ViewTransaction,
//  MessagesHome,
//  Exchange,
//  MyProfile,
//  UserProfile,
//  ConvoInfo,
//  ChooseRecipient,
    Test(String)
}

pub enum KeyPress {
    Zero = 0,
    One = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5,
    Six = 6,
    Seven = 7,
    Eight = 8,
    Nine = 9,
    Reset,
    Decimal,
    Backspace,
}

pub const SATS: u64 = 100_000_000;
pub type Sats = u64;
pub type Usd = f64;
pub type Btc = f64;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct ShorthandTransaction {
    pub is_withdraw: bool,
    pub date: String,
    pub time: String,
    pub usd: String,
    pub txid: String,
}

pub fn test(s: ShorthandTransaction) {}
