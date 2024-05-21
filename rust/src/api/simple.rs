use super::error::Error;

use secp256k1::{Secp256k1, rand};
use secp256k1::rand::RngCore;
use serde::{Serialize, Deserialize};
use bdk::bitcoin::{Network, Address};
use bdk::bitcoin::bip32::ExtendedPrivKey;
use bdk::template::Bip86;
use bdk::{TransactionDetails, Wallet, KeychainKind, SyncOptions, SignOptions};
use bdk::wallet::{AddressIndex};
use bdk::database::MemoryDatabase;
use bdk::template::DescriptorTemplate;
use bdk::blockchain::esplora::EsploraBlockchain;
use bdk::blockchain::electrum::ElectrumBlockchain;
use bdk::electrum_client::Client;
use bdk::sled::Tree;
use bdk::database::SqliteDatabase;
use bdk::electrum_client::ElectrumApi;
use bdk::bitcoin::consensus::{Encodable, Decodable};
use std::str::FromStr;
use bdk::FeeRate;

#[derive(Serialize, Deserialize, Debug)]
pub struct Transaction {
    pub receiver: Option<String>,
    pub sender: Option<String>,
    pub txid: String,
    pub net: i64,
    pub fee: Option<u64>,
    pub timestamp: Option<u64>, 
    pub raw: Option<String>
}

fn from_details(details: TransactionDetails) -> Result<Transaction, Error> {
    Ok(Transaction{
        receiver: None,
        sender: None,
        txid: serde_json::to_string(&details.txid)?,
        net: (details.received as i64)-(details.sent as i64),
        fee: details.fee,
        timestamp: if details.confirmation_time.is_some() { Some(details.confirmation_time.unwrap().timestamp) } else { None },
        raw: None
    })
}

#[derive(Serialize, Deserialize, Debug)]
pub struct DescriptorSet {
    pub external: String,
    pub internal: String
}

pub struct Response{
    pub status: i32,
    pub message: String,
}

impl Response {
    pub fn new(status: i32, message: String) -> Response {
        Response{status, message}
    }

    pub fn bad_request(method: String) -> Response {
        Response{status: 400, message: format!("Incorrect Arguments For Method({})", method)}
    }

    pub fn error(message: String) -> Response {
        Response{status: 500, message}
    }
}

fn generate_singlesig_descriptor() -> Result<String, Error> {
    let mut seed: [u8; 64] = [0; 64];
    rand::thread_rng().fill_bytes(&mut seed);
    let xpriv = ExtendedPrivKey::new_master(Network::Bitcoin, &seed)?;
    let ex_desc = Bip86(xpriv, KeychainKind::External).build(Network::Bitcoin)?;
    let external = ex_desc.0.to_string_with_secret(&ex_desc.1);
    let in_desc = Bip86(xpriv, KeychainKind::Internal).build(Network::Bitcoin)?;
    let internal = in_desc.0.to_string_with_secret(&in_desc.1);
    Ok(serde_json::to_string(&DescriptorSet{external, internal})?)
}

pub fn dropdb(path: String, descriptors: String) {
    let descs: DescriptorSet = serde_json::from_str(&descriptors).unwrap();
    let db = bdk::sled::open(path).unwrap().open_tree("wallet").unwrap();
    //let db = SqliteDatabase::new(path);
    let wallet = Wallet::new(&descs.external, Some(&descs.internal), Network::Bitcoin, db).unwrap();
    //let _ = db.connection.close();
    //db.clear().unwrap();
    //db.drop_tree("wallet").unwrap();
}

fn get_database(db_path: String) -> Result<Tree, Error> {
    //Ok(SqliteDatabase::new(db_path))
    Ok(bdk::sled::open(db_path)?.open_tree("wallet")?)
}

fn get_wallet(db_path: String, descs: DescriptorSet) -> Result<Wallet<Tree>, Error> {
    Ok(Wallet::new(&descs.external, Some(&descs.internal), Network::Bitcoin, get_database(db_path)?)?)
}

fn get_mnemonic(descs: DescriptorSet) -> Result<String, Error> {
//  let wallet = get_wallet(db_path, descs)?;
//  Ok(wallet.get_address(AddressIndex::New)?.address.to_string())
    Ok("to_string".to_string())
}

fn get_new_address(db_path: String, descs: DescriptorSet) -> Result<String, Error> {
    let wallet = get_wallet(db_path, descs)?;
    Ok(wallet.get_address(AddressIndex::New)?.address.to_string())
}

fn get_balance(db_path: String, descs: DescriptorSet) -> Result<String, Error> {
    let wallet = get_wallet(db_path, descs)?;
    Ok(wallet.get_balance()?.get_total().to_string())
    //Err(Error::OutOfBounds());
}

fn get_transactions(db_path: String, descs: DescriptorSet) -> Result<String, Error> {
    let wallet = get_wallet(db_path, descs)?;
    let transactions: Vec<Transaction> = wallet.list_transactions(false)?.into_iter().map(from_details).collect::<Result<Vec<Transaction>, Error>>()?;
    Ok(serde_json::to_string(&transactions)?)
}

fn create_transaction(db_path: String, descs: DescriptorSet, addr: Address, sats: u64) -> Result<String, Error> {
    let wallet = get_wallet(db_path, descs)?;
    let (mut psbt, tx_details) = {
        let mut builder = wallet.build_tx();
        builder.add_recipient(addr.script_pubkey(), sats);
        builder.finish()?
    };
    let finalized = wallet.sign(&mut psbt, SignOptions::default())?;
    if !finalized { return Err(Error::CouldNotSign());}

    let tx = psbt.clone().extract_tx();
    let mut stream: Vec<u8> = Vec::new();
    tx.consensus_encode(&mut stream)?;
    let raw = hex::encode(&stream);
     
    let mut transaction: Transaction = from_details(tx_details)?;
    transaction.receiver = Some(addr.to_string());
    transaction.raw = Some(raw);

    Ok(serde_json::to_string(&transaction)?)
}

fn estimate_fees() -> Result<String, Error> {
    let client = get_client()?;
    let blockchain = ElectrumBlockchain::from(client);

    let priority_target: usize = 6;

    // let priority_fee = &client.estimate_fee(target)?;
    // let standard_fee = &client.estimate_fee(6);

    // let fees = Fees {
    //     priority_fee,
    //     standard_fee
    // }
    Ok(serde_json::to_string(&blockchain.estimate_fee(priority_target)?)?)}

fn broadcast_transaction(db_path: String, descs: DescriptorSet, tx: bdk::bitcoin::Transaction) -> Result<String, Error> {
    let client = get_client()?;
    Ok(serde_json::to_string(&client.transaction_broadcast(&tx)?)?)
}

fn get_client() -> Result<Client, Error> {
    Ok(Client::new("ssl://electrum.blockstream.info:50002")?)
}

fn sync_wallet(db_path: String, descs: DescriptorSet) -> Result<String, Error>{
    let wallet = get_wallet(db_path, descs)?;
    let sync_options = SyncOptions::default(); 
    let client = get_client()?;
    let blockchain = ElectrumBlockchain::from(client);
    wallet.sync(&blockchain, sync_options)?;
    Ok("Finished".to_string())
}

#[derive(Deserialize)]
struct Price {
    amount: String,
    currency: String
}

#[derive(Deserialize)]
struct PriceRes {
    data: Price
}

// #[derive(Serialize)]
struct Fees {
    priority_fee: FeeRate,
    standard_fee: FeeRate
}

fn get_price() -> Result<String, Error> {
    Ok(reqwest::blocking::get("https://api.coinbase.com/v2/prices/BTC-USD/buy")?.json::<PriceRes>()?.data.amount)
}

fn get_historic_price(date: String) -> Result<String, Error> {
    let base_url = "https://api.coinbase.com/v2/prices/BTC-USD/spot";
    let url = match date {
        some(d) => format!("{}?date={}", base_url, d)
    };
    Ok(reqwest::blocking::get(&url)?.json::<PriceRes>()?.data.amount)
}

fn handle_error(result: Result<String, Error>) -> Result<Response, Error> {
    Ok(match result {
        Ok(s) => Response::new(200, s),
        Err(err) => Response::error(err.to_string())
    })
}

//Returns a Response or an Error that occurred during the parsing of the request
fn handle_request(method: String, args: Vec<String>) -> Result<Response, Error> {
    match method.as_str() {
        "get_new_singlesig_descriptor" => {
            handle_error(generate_singlesig_descriptor())
        },
        "sync_wallet" => {
            let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
            let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
            handle_error(sync_wallet(db_path, descs))
        }
        "get_price" => handle_error(get_price()),
        "get_historical_price" => handle_error(get_historical_price(args.get(1).ok_or(Error::OutOfBounds())?))?,
        "throw_error" => Ok(Response::error("RustErrorMsg".to_string())),
        "get_balance" => {
            let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
            let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
            handle_error(get_balance(db_path, descs))
        },
        "get_transactions" => {
            let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
            let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
            handle_error(get_transactions(db_path, descs))
        },
        "get_new_address" => {
            let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
            let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
            handle_error(get_new_address(db_path, descs))
        },
        "get_mnemonic" => {
            let descs: DescriptorSet = serde_json::from_str(args.first().ok_or(Error::OutOfBounds())?)?;
            handle_error(get_mnemonic(descs))
        },
        "check_address" => {
            let addr = args.first().ok_or(Error::OutOfBounds())?;
            match Address::from_str(addr) {
                Ok(address) => match address.require_network(Network::Bitcoin) {
                    Ok(_) => Ok(Response::new(200, "true".to_owned())),
                    Err(_) => Ok(Response::new(200, "false1".to_owned()))
                },
                Err(_) => Ok(Response::new(200, "false2".to_owned()))
            }
        },
        "create_transaction" => {
            let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
            let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
            let addr: Address = Address::from_str(args.get(2).ok_or(Error::OutOfBounds())?)?.require_network(Network::Bitcoin)?;
            let sats: u64 = args.get(3).ok_or(Error::OutOfBounds())?.parse()?;
            handle_error(create_transaction(db_path, descs, addr, sats))
        }
        "broadcast_transaction" => {
            let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
            let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
            let mut stream: Vec<u8> = hex::decode(args.get(2).ok_or(Error::OutOfBounds())?)?;
            let tx = bdk::bitcoin::Transaction::consensus_decode(&mut stream.as_slice())?;
            handle_error(broadcast_transaction(db_path, descs, tx))
        }
        "estimate_fees" =>{
            handle_error(estimate_fees())
        }
        unknown_method => Ok(Response::new(404, format!("Method Not Found({})", unknown_method)))
    }
}

pub fn invoke(method: String, args: Vec<String>) -> Response {
    handle_request(method.clone(), args).unwrap_or(Response::bad_request(method))
}
