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
    GetFees(String, f64, f64),
}

#[derive(Debug)]
pub enum PageName {
    BitcoinHome,
    Speed(String, f64),
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
