#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error(transparent)]
    BDKBitcoinConsensusEncode(#[from] bdk::bitcoin::consensus::encode::Error),
    #[error(transparent)]
    BDKDescriptor(#[from] bdk::descriptor::DescriptorError),
    #[error(transparent)]
    BDKBitcoinBip32(#[from] bdk::bitcoin::bip32::Error),
    #[error(transparent)]
    BDK(#[from] bdk::Error),
    #[error(transparent)]
    HexError(#[from] hex::FromHexError),
    #[error(transparent)]
    IoError(#[from] std::io::Error),
    #[error(transparent)]
    SerdeJson(#[from] serde_json::Error),
    #[error(transparent)]
    Reqwest(#[from] reqwest::Error),
    #[error(transparent)]
    BDKSled(#[from] bdk::sled::Error),
    #[error(transparent)]
    ElectrumError(#[from] bdk::electrum_client::Error),
    #[error(transparent)]
    BDKBitcoinPSBT(#[from] bdk::bitcoin::psbt::Error),
    #[error(transparent)]
    BDKBitcoinAddress(#[from] bdk::bitcoin::address::Error),
    #[error(transparent)]
    NumParseInt(#[from] std::num::ParseIntError),

    #[error("Index of vector out of bounds")]
    OutOfBounds(),
    #[error("Could not sign Transaction")]
    CouldNotSign(),
    #[error("Exited, Reason: {0}")]
    Exited(String),
    #[error("Unknown Method: {0}")]
    UnknownMethod(String),
    #[error("Dart Error: {0}")]
    DartError(String),
    #[derive(Debug)]
    InvalidInput(String),


}
