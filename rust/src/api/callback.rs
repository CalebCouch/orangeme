use super::Error;

use super::structs::{DartCallback, RustCommand, RustResponse};
use super::wallet::Wallet;
use super::state_manager::StateManager;

use web5_rust::common::traits::KeyValueStore;

use flutter_rust_bridge::DartFnFuture;

use std::path::PathBuf;

#[derive(Clone)]
pub struct RustCallback {
    wallet: Wallet,
    state_manager: StateManager,
    dart_callback: DartCallback,
    store: Box<dyn KeyValueStore>
}

impl RustCallback {
    pub async fn new<KVS: KeyValueStore + 'static>(
        wallet: Wallet,
        state_manager: StateManager,
        dart_callback: DartCallback,
        path: PathBuf,
    ) -> Result<Self, Error> {
        let mut store = Box::new(KVS::new(path)?);
         store.set(
            b"new_address",
            &wallet.get_new_address().await?.as_bytes()
        )?;
        Ok(RustCallback{
            wallet,
            state_manager,
            dart_callback,
            store,
        })
    }

    pub async fn handle(&mut self) -> Result<(), Error> {
        let ec = "RustCallback.handle";
        let res = self.dart_callback.call("get_commands", "").await?;
        let commands = serde_json::from_str::<Vec<RustCommand>>(&res)?;
        for command in commands {
            let result: Result<String, Error> = match command.method.as_str() {
                "get_new_address" => {
                    Ok(String::from_utf8(
                        self.store.get(b"new_address")?
                        .ok_or(Error::err(ec, "No new address"))?
                    )?)
                },
                "get_state" => {
                    Ok(self.state_manager.get(&command.data).await?)
                }
              //"check_address" => {
              //    Ok(Address::from_str(&command.data).map(|a|
              //        a.require_network(Network::Bitcoin).is_ok()
              //    ).unwrap_or(false).to_string())
              //},
              //"create_legacy_transaction" => {
              //    let ec = "Main.create_transaction";
              //    let error = || Error::bad_request(ec, "Invalid parameters");

              //    invoke(&callback, "print", &format!("split {}", command.data.clone())).await?;
              //    let split: Vec<&str> = command.data.split("|").collect();
              //    let address = Address::from_str(split.first().ok_or(error())?)?.require_network(Network::Bitcoin)?;
              //    let amount = (f64::from_str(split.get(1).ok_or(error())?)? * SATS) as u64;
              //    let priority = u8::from_str(split.get(2).ok_or(error())?)? as u8;
              //    let price_error = || Error::not_found(ec, "Cannot get price");
              //    let current_price = f64::from_le_bytes(price.get(b"price")?.ok_or(price_error())?.try_into().or(Err(price_error()))?);
              //    let is_mine = |s: &Script| legacy_spending_wallet.is_mine(s).unwrap_or(false);
              //    invoke(&callback, "print", &format!("amount: {}", amount)).await?;
              //    let fees = vec![blockchain.estimate_fee(3)?, blockchain.estimate_fee(1)?];
              //    let (mut psbt, mut tx_details) = {
              //        let mut builder = legacy_spending_wallet.build_tx();
              //        builder.add_recipient(address.script_pubkey(), amount);
              //        builder.fee_rate(FeeRate::from_btc_per_kvb(fees[priority as usize] as f32));
              //        builder.finish()?
              //    };
              //    let finalized = legacy_spending_wallet.sign(&mut psbt, SignOptions::default())?;
              //    if !finalized { return Err(Error::err(ec, "Could not sign std tx"));}

              //    let tx = psbt.clone().extract_tx();
              //    let mut stream: Vec<u8> = Vec::new();
              //    tx.consensus_encode(&mut stream)?;
              //    store.set(&tx_details.txid.to_string().as_bytes(), &stream)?;

              //    tx_details.transaction = Some(tx);
              //    let tx = Transaction::from_details(tx_details, current_price, |s: &Script| {legacy_spending_wallet.is_mine(s).unwrap_or(false)})?;

              //    Ok(serde_json::to_string(&tx)?)
              //},
              //"broadcast_transaction" => {
              //    let ec = "Main.broadcast_transaction";
              //    let error = || Error::bad_request(ec, "Invalid parameters");

              //    let stream = store.get(&command.data.as_bytes())?.ok_or(error())?;
              //    let tx = bdk::bitcoin::Transaction::consensus_decode(&mut stream.as_slice())?;
              //    client.transaction_broadcast(&tx)?;
              //    Ok("Ok".to_string())
              //},
                "break" => {
                    return Err(Error::Exited("Break Requested".to_string()));
                },
                _ => {
                    return Err(Error::bad_request("rust_start", &format!("Unknown method: {}", command.method)));
                }
            };
            let resp = RustResponse{uid: command.uid.to_string(), data: result?};
            self.dart_callback.call("post_response", &serde_json::to_string(&resp)?).await?;

            //POST PROCESSES
            match command.method.as_str() {
                "get_new_address" => {
                    self.store.set(
                        b"new_address",
                        &self.wallet.get_new_address().await?.as_bytes()
                    )?;
                },
                _ => {}
            }
        }
        Ok(())
    }
}
