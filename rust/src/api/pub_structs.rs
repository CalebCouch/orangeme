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
    BitcoinHome,
    Receive,
    Send,
    ScanQR,
    Amount,
    Speed,
    ConfirmTransaction,
    Success,
    ViewTransaction,
    MessagesHome,
    Exchange,
    MyProfile,
    ConvoInfo,
    ChooseRecipient,
    Test
}

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

#[derive(Serialize, Deserialize, Debug)]
#[serde(untagged)]
pub enum TestEnum {
    Value(Option<u8>),
    Balance(Option<f32>)
}

impl TestEnum {
    pub fn into_bytes(&self) -> Vec<u8> {
        format!("{:?}", self).split("(").collect::<Vec<&str>>()[0].as_bytes().to_vec()
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn testfn(test: TestEnum) -> String {
    std::str::from_utf8(&test.into_bytes()).unwrap().to_string()
}


