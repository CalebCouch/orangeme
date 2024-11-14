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
    GetFees(String, Sats, Usd),
}

#[derive(Debug)]
pub enum PageName {
    BitcoinHome,
    Speed(String, Sats),
    Receive,
    ViewTransaction(String),
    MyProfile,
//  Receive,
//  ViewTransaction,
//  MessagesHome,
//  Exchange,
//  MyProfile,
//  UserProfile,
//  ConvoInfo,
//  ChooseRecipient,
    Test
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
    Decimal,
    Backspace
}

pub const SATS: f64 = 100_000_000.0;
pub type Sats = u64;
pub type Usd = f64;


