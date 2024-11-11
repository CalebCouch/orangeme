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
