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

impl Default for Platform {
    fn default() -> Self {Platform::Mac}
}

#[derive(Debug)]
pub enum PageName {
//  BitcoinHome,
//  Receive,
//  Send,
//  ScanQR,
//  Amount,
//  Speed,
//  ConfirmTransaction,
//  Success,
//  ViewTransaction,
//  MessagesHome,
//  Exchange,
//  MyProfile,
//  UserProfile,
//  ConvoInfo,
//  ChooseRecipient,
    Test
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(untagged)]
pub enum Field {
    Path(Option<String>),
    Price(Option<f64>),
    Internet(Option<bool>),
    Platform(Option<Platform>),
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
//  Balance(Option<f64>),
//  CurrentConversation(Option<Conversation>),
//  Conversations(Option<Vec<Conversation>>),
//  Users(Option<Vec<Profile>>),
//  Transactions(Option<Vec<Transaction>>),
//  CurrentTx(Option<Transaction>),
//  CurrentRawTx(Option<bdk::bitcoin::Transaction>),
}

impl Field {
    pub fn into_bytes(&self) -> Vec<u8> {
        format!("{:?}", self).split("(").collect::<Vec<&str>>()[0].as_bytes().to_vec()
    }
}
