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
    UserProfile,
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
    Profile(Option<Profile>),
    Address(Option<String>),
    Amount(Option<String>),
    Priority(Option<u8>),
    AmountErr(Option<String>),
    AmountBTC(Option<f64>),
    Decimals(Option<String>),
    InputValidation(Option<bool>),
    Price(Option<f64>),
    Path,
    Balance(Option<f64>),
    CurrentConversation(Option<Conversation>),
    Conversations(Option<Vec<Conversation>>),
    Users(Option<Vec<Profile>>),
    Transactions(Option<Vec<Transaction>>),
    CurrentTx(Option<Transaction>),
    CurrentRawTx(Option<bdk::bitcoin::Transaction>),
}

impl Field {
    pub fn into_bytes(&self) -> Vec<u8> {
        format!("{:?}", self).into_bytes()
    }
}
