use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct DartCommand {
    pub method: String,
    pub data: String
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct RustCommand {
    pub uid: String,
    pub method: String,
    pub data: String
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct RustResponse {
    pub uid: String,
    pub data: String
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Transaction {
    pub isReceive: bool,
    pub sentAddress: Option<String>,
    pub txid: String,
    pub usd: f64,
    pub btc: f64,
    pub price: f64,
    pub fee: f64,
    pub date: Option<String>,
    pub time: Option<String>
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Contact {
    pub name: String,
    pub did: String,
    pub pfp: Option<String>,
    pub abtme: Option<String>,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Conversation {
    pub messages: Vec<Message>,
    pub members: Vec<Contact>,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Message {
    pub sender: Contact,
    pub message: String,
    pub date: String,
    pub time: String,
    pub is_incoming: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct DartState {
    pub currentPrice: f64,
    pub usdBalance: f64,
    pub btcBalance: f64,
    pub transactions: Vec<Transaction>,
    pub fees: Vec<f64>,
    pub conversations: Vec<Conversation>,
    pub users: Vec<Contact>,
    pub personal: Contact,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct DescriptorSet{
    pub external: String,
    pub internal: String
}
