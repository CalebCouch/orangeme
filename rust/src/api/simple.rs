use super::error::Error;

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
use rand::RngCore;
use chrono::{Utc, Date};
use futures::future::ok;
use serde_json::to_string;
use std::env;
use std::env::args;
use serde_json;



use std::{thread, time::Duration};
use flutter_rust_bridge::DartFnFuture;

const STORAGE_SPLIT: &str = "\u{0000}";


//  #[frb(mirror(Wallet))]
//  pub struct _Wallet<D> {
//      descriptor: ExtendedDescriptor,
//      change_descriptor: Option<ExtendedDescriptor>,

//      signers: Arc<SignersContainer>,
//      change_signers: Arc<SignersContainer>,

//      network: Network,

//      database: RefCell<D>,

//      secp: SecpCtx,
//  }

#[derive(Serialize, Deserialize, Debug)]
pub struct DescriptorSet {
    pub external: String,
    pub internal: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct DartCommand {
    pub method: String,
    pub data: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RustCommand {
    pub uid: String,
    pub method: String,
    pub data: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RustResponse {
    pub uid: String,
    pub data: String
}

fn handleError(res: &str) -> Result<(), Error> {
    if res.contains("Error") {
        return Err(Error::DartError(res.to_string()))
    }
    Ok(())
}

async fn invoke(dartCallback: impl Fn(String) -> DartFnFuture<String>, method: &str, data: &str) -> Result<String, Error> {
    let res = dartCallback(serde_json::to_string(&DartCommand{method: method.to_string(), data: data.to_string()})?).await;
    handleError(&res)?;
    Ok(res)
}

async fn start_rust(path: String, dartCallback: impl Fn(String) -> DartFnFuture<String>) -> Result<(), Error> {
    //invoke(&dartCallback, "secure_set", &format!("{}{}{}", "descriptors", STORAGE_SPLIT, "")).await?;
    let descriptors = invoke(&dartCallback, "secure_get", "descriptors").await?;
    let descriptors = if descriptors.is_empty() {
        let mut seed: [u8; 64] = [0; 64];
        rand::thread_rng().fill_bytes(&mut seed);
        invoke(&dartCallback, "secure_set", &format!("{}{}{}", "seed", STORAGE_SPLIT, &serde_json::to_string(&seed.to_vec())?)).await?;
        let xpriv = ExtendedPrivKey::new_master(Network::Bitcoin, &seed)?;
        let ex_desc = Bip86(xpriv, KeychainKind::External).build(Network::Bitcoin)?;
        let external = ex_desc.0.to_string_with_secret(&ex_desc.1);
        let in_desc = Bip86(xpriv, KeychainKind::Internal).build(Network::Bitcoin)?;
        let internal = in_desc.0.to_string_with_secret(&in_desc.1);
        let set = DescriptorSet{external, internal};

        invoke(&dartCallback, "secure_set", &format!("{}{}{}", "descriptors", STORAGE_SPLIT, &serde_json::to_string(&set)?)).await?;
        set
    } else {serde_json::from_str::<DescriptorSet>(&descriptors)?};
    invoke(&dartCallback, "print", &serde_json::to_string(&descriptors)?).await?;

//  let mut options = DBOptions::new().ok_or(Error::DataStore())?;
//  options.set_create_if_missing(true);
//  let db = DB::open_with_opts(Path::new(location), options)?



    let db = bdk::sled::open(path+"BDK/database.db")?;
    db.drop_tree("wallet")?;
    let tree = db.open_tree("wallet")?;

    let wallet = Wallet::new(&descriptors.external, Some(&descriptors.internal), Network::Bitcoin, tree)?;
    let sync_options = SyncOptions::default();
    let client_uri = "ssl://electrum.blockstream.info:50002";
    let client = Client::new(client_uri)?;
    let blockchain = ElectrumBlockchain::from(Client::new(client_uri)?);

    wallet.sync(&blockchain, sync_options)?;


    loop {
        thread::sleep(Duration::from_secs(1));
        let res = invoke(&dartCallback, "get_commands", "").await?;
        let commands = serde_json::from_str::<Vec<RustCommand>>(&res)?;
        for command in commands {
            //let resp = handle(&command, &dartCallback, &wallet).await?;
            let data = match command.method.as_str() {
                "messages" => {
                    let messages = vec![Message {
                        text: "my message i sent to stupid".to_string()
                    }];
                    serde_json::to_string(&messages)?
                },
                "get_price" => {
                    let amount = reqwest::get("https://api.coinbase.com/v2/prices/BTC-USD/buy").await?.json::<PriceRes>().await?.data.amount;
                    serde_json::to_string(&amount)?
                },
                "get_historical_price" => {
                    let base_url = "https://api.coinbase.com/v2/prices/BTC-USD/spot";
                    let date = chrono::Utc::today().format("%Y-%m-%d").to_string();
                    let url = format!("{}?date={}", base_url, date);
                    let spot_res: SpotRes = reqwest::get(&url).await?.json().await?;
                    spot_res.data.amount.to_string()
                },
                "get_balance" => {
                wallet.get_balance()?.get_total().to_string()
                },

                "sync_wallet" => {
                    wallet.sync(&blockchain, sync_options)?;
                    Ok("Finished".to_string())
                }

                "get_new_address" => {
                    wallet.get_address(AddressIndex::New)?.address.to_string()
                },
             
                "check_address" => {
                    let addr = &command.data;
                    
                    let result = match Address::from_str(addr) {
                        Ok(address) => {
                            if address.require_network(Network::Bitcoin).is_ok() {
                                "true".to_owned()
                            } else {
                                "false".to_owned()
                            }
                        },
                        Err(_) => "false".to_owned() 
                    };

                    Ok::<String, Error>(result)
                }?,

            
         
                "create_transaction" => {
                    let (addr, sats, fee) = serde_json::from_str::<CreateTransactionInput>(&command.data)?.parse();
                    
                    let (mut psbt, tx_details) = {
                        let mut builder = wallet.build_tx();
                        
                    if let Some(address) = addr {
                        let address = address.script_pubkey();
                        builder.add_recipient(address, sats.unwrap_or(0));
                    }
                    builder.finish()?
                    };

                    let finalized = wallet.sign(&mut psbt, SignOptions::default())?;
                    if !finalized {
                        return Err(Error::CouldNotSign());
                    }

                    let tx = psbt.clone().extract_tx();
                    let mut stream: Vec<u8> = Vec::new();
                    tx.consensus_encode(&mut stream)?;
                    let raw = hex::encode(&stream);

                    let transaction = Transaction {
                        receiver: None,
                        sender: None,
                        txid: serde_json::to_string(&tx.txid())?, 
                        net: (tx_details.received as i64) - (tx_details.sent as i64),
                        fee: tx_details.fee,
                        timestamp: if let Some(confirmation_time) = tx_details.confirmation_time {
                            Some(confirmation_time.timestamp)
                        } else {
                            None
                        },
                        raw: Some(raw),
                    };

                    serde_json::to_string(&transaction)?
                },



                 "broadcast_transaction" => {
                    let tx = serde_json::from_str::<bdk::bitcoin::Transaction>(&command.data)?;
                    serde_json::to_string(&client.transaction_broadcast(&tx)?)?
                },



                  "estimate_fees" => {
                    let priority_target: usize = 1;
                    let result = blockchain.estimate_fee(priority_target)
                        .unwrap_or_default(); 
                    serde_json::to_string(&result)?
                },
 

                "drop_descs" => {
                    invoke(&dartCallback, "secure_set", &format!("{}{}{}", "descriptors", STORAGE_SPLIT, "")).await?;
                    "Ok".to_string()
                },
                "break" => {return Err(Error::Exited("Break Requested".to_string()));},
                _ => {return Err(Error::UnknownMethod(format!("{}", command.method)));}
            };
            let resp = RustResponse{uid: command.uid.to_string(), data};
            invoke(&dartCallback, "post_response", &serde_json::to_string(&resp)?).await?;
        }
    }
    Err(Error::Exited("Unknown".to_string()))
}


pub async fn rustStart(path: String, dartCallback: impl Fn(String) -> DartFnFuture<String>) -> String {
    match start_rust(path, dartCallback).await {
        Ok(()) => "Ok".to_string(),
        Err(e) => format!("Err: {}", e)
    }
}


#[derive(Deserialize)]
struct PriceRes {
    data: Price
}

#[derive(Deserialize)]
struct Price {
    amount: String,
    currency: String
}

#[derive(Serialize, Deserialize, Debug)]
struct Message {
    text: String,
}

#[derive(Deserialize)]
struct Spot {
    amount: String,
    currency: String,
    base: String
}

#[derive(Deserialize)]
struct SpotRes {
    data: Spot
}

// #[derive(Seserialize)]
struct Fees {
    priority_fee: FeeRate,
    standard_fee: FeeRate
}

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

#[derive(Serialize, Deserialize, Debug)]
pub struct CreateTransactionInput {
    pub address: String,
    pub sats: String,
}

impl CreateTransactionInput {
    pub fn parse(&self) -> (Option<Address>, Option<u64>, Option<f64>) {
        let address = Address::from_str(&self.address)
            .ok()
            .and_then(|addr| addr.require_network(Network::Bitcoin).ok());
        let sats = self.sats.parse::<u64>().ok();
        let fee = self.sats.parse::<f64>().ok();
        (address, sats, fee)
    }
}






//async fn handle(command: &RustCommand, dartCallback: impl Fn(String) -> DartFnFuture<String>, wallet: &Wallet<Tree>) -> Result<RustResponse, Error> {
//    }



//  #[derive(Serialize, Deserialize, Debug)]
//  pub struct Transaction {
//      pub receiver: Option<String>,
//      pub sender: Option<String>,
//      pub txid: String,
//      pub net: i64,
//      pub fee: Option<u64>,
//      pub timestamp: Option<u64>,
//      pub raw: Option<String>
//  }

//  fn from_details(details: TransactionDetails) -> Result<Transaction, Error> {
//      Ok(Transaction{
//          receiver: None,
//          sender: None,
//          txid: serde_json::to_string(&details.txid)?,
//          net: (details.received as i64)-(details.sent as i64),
//          fee: details.fee,
//          timestamp: if details.confirmation_time.is_some() { Some(details.confirmation_time.unwrap().timestamp) } else { None },
//          raw: None
//      })
//  }



//  pub struct Response{
//      pub status: i32,
//      pub message: String,
//  }

//  impl Response {
//      pub fn new(status: i32, message: String) -> Response {
//          Response{status, message}
//      }

//      pub fn bad_request(method: String) -> Response {
//          Response{status: 400, message: format!("Incorrect Arguments For Method({})", method)}
//      }

//      pub fn error(message: String) -> Response {
//          Response{status: 500, message}
//      }
//  }

//  //  fn generate_singlesig_descriptor() -> Result<String, Error> {
//  //  }

//  pub fn dropdb(path: String, descriptors: String) {
//      let descs: DescriptorSet = serde_json::from_str(&descriptors).unwrap();
//      let db = bdk::sled::open(path).unwrap().open_tree("wallet").unwrap();
//      //let db = SqliteDatabase::new(path);
//      let wallet = Wallet::new(&descs.external, Some(&descs.internal), Network::Bitcoin, db).unwrap();
//      //let _ = db.connection.close();
//      //db.clear().unwrap();
//      //db.drop_tree("wallet").unwrap();
//  }

//  fn get_database(db_path: String) -> Result<Tree, Error> {
//      //Ok(SqliteDatabase::new(db_path))
//      Ok(bdk::sled::open(db_path)?.open_tree("wallet")?)
//  }

//  fn get_wallet(db_path: String, descs: DescriptorSet) -> Result<Wallet<Tree>, Error> {
//      Ok(Wallet::new(&descs.external, Some(&descs.internal), Network::Bitcoin, get_database(db_path)?)?)
//  }

//  fn get_mnemonic(descs: DescriptorSet) -> Result<String, Error> {
//  //  let wallet = get_wallet(db_path, descs)?;
//  //  Ok(wallet.get_address(AddressIndex::New)?.address.to_string())
//      Ok("to_string".to_string())
//  }

//  fn get_new_address(db_path: String, descs: DescriptorSet) -> Result<String, Error> {
//      let wallet = get_wallet(db_path, descs)?;
//      Ok(wallet.get_address(AddressIndex::New)?.address.to_string())
//  }

//  fn get_balance(db_path: String, descs: DescriptorSet) -> Result<String, Error> {
//      let wallet = get_wallet(db_path, descs)?;
//      Ok(wallet.get_balance()?.get_total().to_string())
//      //Err(Error::OutOfBounds());
//  }

//  fn get_transactions(db_path: String, descs: DescriptorSet) -> Result<String, Error> {
//      let wallet = get_wallet(db_path, descs)?;
//      let transactions: Vec<Transaction> = wallet.list_transactions(false)?.into_iter().map(from_details).collect::<Result<Vec<Transaction>, Error>>()?;
//      Ok(serde_json::to_string(&transactions)?)
//  }


//  // fn create_transaction(sats: u64) -> Result<String, Error> {
//  fn create_transaction(db_path: String, descs: DescriptorSet, addr: Address, sats: u64) -> Result<String, Error> {
//      let wallet = get_wallet(db_path, descs)?;
//      let (mut psbt, tx_details) = {
//          let mut builder = wallet.build_tx();
//          builder.add_recipient(addr.script_pubkey(), sats);
//          builder.finish()?
//      };
//      let finalized = wallet.sign(&mut psbt, SignOptions::default())?;
//      if !finalized { return Err(Error::CouldNotSign());}

//      let tx = psbt.clone().extract_tx();
//      let mut stream: Vec<u8> = Vec::new();
//      tx.consensus_encode(&mut stream)?;
//      let raw = hex::encode(&stream);
//       
//      let mut transaction: Transaction = from_details(tx_details)?;
//      transaction.receiver = Some(addr.to_string());
//      transaction.raw = Some(raw);

//      Ok(serde_json::to_string(&transaction)?)
//  }

//  fn estimate_fees() -> Result<String, Error> {
//      let client = get_client()?;
//      let blockchain = ElectrumBlockchain::from(client);

//      let priority_target: usize = 1;

//      Ok(serde_json::to_string(&blockchain.estimate_fee(priority_target)?)?)}

//  fn broadcast_transaction(db_path: String, descs: DescriptorSet, tx: bdk::bitcoin::Transaction) -> Result<String, Error> {
//      let client = get_client()?;
//      Ok(serde_json::to_string(&client.transaction_broadcast(&tx)?)?)
//  }

//  fn get_client() -> Result<Client, Error> {
//      Ok(Client::new("ssl://electrum.blockstream.info:50002")?)
//  }

//  fn sync_wallet(db_path: String, descs: DescriptorSet) -> Result<String, Error>{
//      let wallet = get_wallet(db_path, descs)?;
//      let sync_options = SyncOptions::default(); 
//      let client = get_client()?;
//      let blockchain = ElectrumBlockchain::from(client);
//      wallet.sync(&blockchain, sync_options)?;
//      Ok("Finished".to_string())
//  }



//  #[derive(Deserialize)]
//  struct Spot {
//      amount: String,
//      currency: String,
//      base: String
//  }

//  #[derive(Deserialize)]
//  struct SpotRes {
//      data: Spot
//  }



//  // #[derive(Serialize)]
//  struct Fees {
//      priority_fee: FeeRate,
//      standard_fee: FeeRate
//  }

//  fn get_price() -> Result<String, Error> {
//      Ok(reqwest::blocking::get("https://api.coinbase.com/v2/prices/BTC-USD/buy")?.json::<PriceRes>()?.data.amount)
//  }

//  fn get_historical_price(date: String) -> Result<String, Error> {
//      let base_url = "https://api.coinbase.com/v2/prices/BTC-USD/spot";
//      let url = format!("{}?date={}", base_url, date);
//      
//      
//      Ok(reqwest::blocking::get(&url)?.json::<SpotRes>()?.data.amount)
//  }

//  fn handle_error(result: Result<String, Error>) -> Result<Response, Error> {
//      Ok(match result {
//          Ok(s) => Response::new(200, s),
//          Err(err) => Response::error(err.to_string())
//      })
//  }

//  //Returns a Response or an Error that occurred during the parsing of the request
//  fn handle_request(method: String, args: Vec<String>) -> Result<Response, Error> {
//      match method.as_str() {
//  //      "get_new_singlesig_descriptor" => {
//  //          handle_error(generate_singlesig_descriptor())
//  //      },
//          "sync_wallet" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              handle_error(sync_wallet(db_path, descs))
//          }
//          "get_price" => handle_error(get_price()),
//          "get_historical_price" => handle_error(get_historical_price(args.first().ok_or(Error::OutOfBounds())?.to_string())),
//          "throw_error" => Ok(Response::error("RustErrorMsg".to_string())),
//          "get_balance" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              handle_error(get_balance(db_path, descs))
//          },
//          "get_transactions" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              handle_error(get_transactions(db_path, descs))
//          },
//          "get_new_address" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              handle_error(get_new_address(db_path, descs))
//          },
//          "get_mnemonic" => {
//              let descs: DescriptorSet = serde_json::from_str(args.first().ok_or(Error::OutOfBounds())?)?;
//              handle_error(get_mnemonic(descs))
//          },
//          "check_address" => {
//              let addr = args.first().ok_or(Error::OutOfBounds())?;
//              match Address::from_str(addr) {
//                  Ok(address) => match address.require_network(Network::Bitcoin) {
//                      Ok(_) => Ok(Response::new(200, "true".to_owned())),
//                      Err(_) => Ok(Response::new(200, "false1".to_owned()))
//                  },
//                  Err(_) => Ok(Response::new(200, "false2".to_owned()))
//              }
//          },
//          "create_transaction" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              let addr: Address = Address::from_str(args.get(2).ok_or(Error::OutOfBounds())?)?.require_network(Network::Bitcoin)?;
//              let sats: u64 = args.get(3).ok_or(Error::OutOfBounds())?.parse()?;
//              handle_error(create_transaction(db_path, descs, addr, sats))
//          }
//          "broadcast_transaction" => {
//              let db_path: String = args.first().ok_or(Error::OutOfBounds())?.to_string();
//              let descs: DescriptorSet = serde_json::from_str(args.get(1).ok_or(Error::OutOfBounds())?)?;
//              let mut stream: Vec<u8> = hex::decode(args.get(2).ok_or(Error::OutOfBounds())?)?;
//              let tx = bdk::bitcoin::Transaction::consensus_decode(&mut stream.as_slice())?;
//              handle_error(broadcast_transaction(db_path, descs, tx))
//          }
//          "estimate_fees" =>{
//              handle_error(estimate_fees())
//          }
//          unknown_method => Ok(Response::new(404, format!("Method Not Found({})", unknown_method)))
//      }
//  }

//  //  pub fn invoke(method: String, args: Vec<String>) -> Response {
//  //      handle_request(method.clone(), args).unwrap_or(Response::bad_request(method))
//  //  }
