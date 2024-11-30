#[derive(snafu::Snafu, Debug)]
#[snafu(module)]
#[frb(opaque)]
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



    #[snafu(display("SendError: {message}"))]
    SendError{message: String, backtrace: snafu::Backtrace},

    #[snafu(transparent)]
    ParseFloat{source: std::num::ParseFloatError, backtrace: snafu::Backtrace},

    #[snafu(display("Exited, Reason: {message}"))]
    Exited{message: String, backtrace: snafu::Backtrace},

    #[snafu(display("Dart Error: {message}"))]
    DartError{message: String, backtrace: snafu::Backtrace},

    #[snafu(display("Could not parse type ({message}) from: {error}"))]
    Parse{message: String, error: String, backtrace: snafu::Backtrace},

    #[snafu(display("Bad Request: {message}: {error}"))] // 400
    BadRequest{message: String, error: String, backtrace: snafu::Backtrace},

    #[snafu(display("Auth failed {message}: {error}"))] // 401
    AuthFailed{message: String, error: String, backtrace: snafu::Backtrace},

    #[snafu(display("Not Found {message}: {error}"))] // 404
    NotFound{message: String, error: String, backtrace: snafu::Backtrace},

    #[snafu(display("Conflict {message}: {error}"))] // 409
    Conflict{message: String, error: String, backtrace: snafu::Backtrace},

    #[snafu(display("Error {message}: {error}"))] // 500
    Error{message: String, error: String, backtrace: snafu::Backtrace},

    #[snafu(display("Cannot connect to the Internet"))]
    NoInternet{backtrace: snafu::Backtrace}
}

impl Error {
    pub fn bad_request(ctx: &str, err: &str) -> Self {
        Error::BadRequest{message: ctx.to_string(), error: err.to_string(), backtrace: snafu::Backtrace::capture()}
    }
    pub fn auth_failed(ctx: &str, err: &str) -> Self {
        Error::AuthFailed{message: ctx.to_string(), error: err.to_string(), backtrace: snafu::Backtrace::capture()}
    }
    pub fn not_found(ctx: &str, err: &str) -> Self {
        Error::NotFound{message: ctx.to_string(), error: err.to_string(), backtrace: snafu::Backtrace::capture()}
    }
    pub fn conflict(ctx: &str, err: &str) -> Self {
        Error::Conflict{message: ctx.to_string(), error: err.to_string(), backtrace: snafu::Backtrace::capture()}
    }
    pub fn parse(rtype: &str, data: &str) -> Self {Error::Parse{message: rtype.to_string(), error: data.to_string(), backtrace: snafu::Backtrace::capture()}}
    pub fn err(ctx: &str, err: &str) -> Self {Error::Error{message: ctx.to_string(), error: err.to_string(), backtrace: snafu::Backtrace::capture()}}
    pub fn no_internet() -> Self {Error::NoInternet{backtrace: snafu::Backtrace::capture()}}
    pub fn exited(msg: &str) -> Self {Error::Exited{message: msg.to_string(), backtrace: snafu::Backtrace::capture()}}
    pub fn tokio_join(source: tokio::task::JoinError) -> Self {Error::TokioJoin{source, backtrace: snafu::Backtrace::capture()}}
}

impl From<bdk::esplora_client::Error> for Error {
    fn from(ece: bdk::esplora_client::Error) -> Error {
        Error::EsploraError{source: Box::new(ece), backtrace: snafu::Backtrace::capture()}
    }
}

impl<T> From<tokio::sync::mpsc::error::SendError<T>> for Error {
    fn from(e: tokio::sync::mpsc::error::SendError<T>) -> Error {
        Error::SendError{message: e.to_string(), backtrace: snafu::Backtrace::capture()}
    }
}
