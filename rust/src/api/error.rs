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
    #[error(transparent)]
    Web5(#[from] web5_rust::Error),
    #[error(transparent)]
    Utf8Str(#[from] std::str::Utf8Error),
    #[error(transparent)]
    Utf8String(#[from] std::string::FromUtf8Error),
    #[error(transparent)]
    TokioJoin(#[from] tokio::task::JoinError),
    #[error(transparent)]
    EsploraError(#[from] bdk::esplora_client::Error),



    #[error(transparent)]
    ParseFloat(#[from] std::num::ParseFloatError),

    #[error("Exited, Reason: {0}")]
    Exited(String),
    #[error("Dart Error: {0}")]
    DartError(String),

    #[error("Could not parse type ({0}) from: {1}")]
    Parse(String, String),
    #[error("Bad Request: {0}: {1}")]
    BadRequest(String, String), //400
    #[error("Auth failed {0}: {1}")]
    AuthFailed(String, String), //401
    #[error("Not Found {0}: {1}")]
    NotFound(String, String), //404
    #[error("Conflict {0}: {1}")]
    Conflict(String, String), //409
    #[error("Error {0}: {1}")]
    Error(String, String), //500
}

impl Error {
    pub fn bad_request(ctx: &str, err: &str) -> Self {
        Error::BadRequest(ctx.to_string(), err.to_string())
    }
    pub fn auth_failed(ctx: &str, err: &str) -> Self {
        Error::AuthFailed(ctx.to_string(), err.to_string())
    }
    pub fn not_found(ctx: &str, err: &str) -> Self {
        Error::NotFound(ctx.to_string(), err.to_string())
    }
    pub fn conflict(ctx: &str, err: &str) -> Self {
        Error::Conflict(ctx.to_string(), err.to_string())
    }
    pub fn parse(rtype: &str, data: &str) -> Self {Error::Parse(rtype.to_string(), data.to_string())}
    pub fn err(ctx: &str, err: &str) -> Self {Error::Error(ctx.to_string(), err.to_string())}
}
