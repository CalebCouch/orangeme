#[derive(snafu::Error, Debug)]
pub enum Error {
    #[snafu(transparent)]
    BDKBitcoinConsensusEncode{source: bdk::bitcoin::consensus::encode::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    BDKDescriptor{source: bdk::descriptor::DescriptorError, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    BDKBitcoinBip32{source: bdk::bitcoin::bip32::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    BDK{source: bdk::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    HexError{source: hex::FromHexError, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    IoError{source: std::io::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    SerdeJson{source: serde_json::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    Reqwest{source: reqwest::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    BDKSled{source: bdk::sled::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    ElectrumError{source: bdk::electrum_client::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    BDKBitcoinPSBT{source: bdk::bitcoin::psbt::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    BDKBitcoinAddress{source: bdk::bitcoin::address::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    NumParseInt{source: std::num::ParseIntError, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    Web5{source: web5_rust::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    SimpleDatabase{source: simple_database::Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    Utf8Str{source: std::str::Utf8Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    Utf8String{source: std::string::FromUtf8Error, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    TokioJoin{source: tokio::task::JoinError, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    EsploraError{source: Box<bdk::esplora_client::Error>, backtrace: snafu::Backtrace},
    #[snafu(transparent)]
    RecvError{source: tokio::sync::oneshot::error::RecvError, backtrace: snafu::Backtrace},



    #[error("SendError: {0}")]
    SendError(String),


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

    #[error("Cannot connect to the Internet")]
    NoInternet()
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

impl From<bdk::esplora_client::Error> for Error {
    fn from(ece: bdk::esplora_client::Error) -> Error {
        Error::EsploraError(Box::new(ece))
    }
}

impl<T> From<tokio::sync::mpsc::error::SendError<T>> for Error {
    fn from(e: tokio::sync::mpsc::error::SendError<T>) -> Error {
        Error::SendError(e.to_string())
    }
}
