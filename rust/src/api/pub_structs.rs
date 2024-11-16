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
    GetFees(Sats, Usd),
}

#[derive(Debug)]
pub enum PageName {
    BitcoinHome,
    Receive,
    Send(String),
  //Speed(Sats),
  //ViewTransaction(String),
  //MyProfile,
  //MessagesHome,
//  Receive,
//  ViewTransaction,
//  MessagesHome,
//  Exchange,
//  MyProfile,
//  UserProfile,
//  ConvoInfo,
//  ChooseRecipient,
    Test(String)
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
    Reset,
    Decimal,
    Backspace,
}

pub const SATS: u64 = 100_000_000;
pub type Sats = u64;
pub type Usd = f64;
pub type Btc = f64;

pub struct DartCommand {
    pub method: String,
    pub data: String
}


/*  DISPLAYED ON BITCOIN HOME   */
#[derive(Serialize, Deserialize, Clone, Debug)]
#[flutter_rust_bridge::frb(dart_code = "
    int extraMethod() => a * 2;
    ShorthandTransaction fromJson(Map<String, dynamic> json) => ShorthandTransaction(
        isWithdraw: json['is_withdraw'] as bool,
        date: json['date'] as String,
        time: json['time'] as String,
        amount: json['amount'] as String,
        txid: json['txid'] as String,
    );
"
)]
pub struct ShorthandTransaction {
    pub is_withdraw: bool,
    pub date: String,
    pub time: String,
    pub amount: String,
    pub txid: String,
}

/*  DISPLAYED ON CONFIRM SEND   */
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct BuildingTransaction {
    pub date: String, // "10:45 PM"
    pub time: String, // "11/12/24"
    pub amount_usd: String, // "$10.00"
    pub amount_btc: String, // "0.00001234 BTC"
    pub address_whole: String, // "ack9723dxsahkdob239u1dumoiuhare482u"
    pub address_cut: String, // "123456789...123"
    pub fee: String, // "$0.14"
}

/*  DISPLAYED ON VIEW TRANSACTION - RECEIVED TRANSACTION   */
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct ReceivedTransaction {
    pub date: String, // "10:45 PM"
    pub time: String, // "11/12/24"
    pub amount_usd: String, // "$10.00"
    pub amount_btc: String, // "0.00001234 BTC"
    pub address: String, // "123456789...123"
    pub price: String, // "$78,394.12"
}

/*  DISPLAYED ON VIEW TRANSACTION - SENT TRANSACTION   */
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct SentTransaction {
    pub date: String, // "10:45 PM"
    pub time: String, // "11/12/24"
    pub amount_usd: String, // "$10.00"
    pub amount_btc: String, // "0.00001234 BTC"
    pub address: String, // "123456789...123"
    pub price: String, // "$78,394.12"
    pub fee: String, // "$0.14"
    pub total: String, // "$10.14"
}

pub struct Profile {
    pub name: String,
    pub did: String,
    pub pfp_path: Option<String>,
    pub abt_me: Option<String>,
}

pub fn load_structs(_s: ShorthandTransaction, _p: Profile) {}
