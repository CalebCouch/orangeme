use super::Error;

use super::structs::DescriptorSet;

use bdk::{TransactionDetails, KeychainKind, SyncOptions, SignOptions};
use bdk::bitcoin::consensus::{Encodable, Decodable};
use bdk::blockchain::electrum::ElectrumBlockchain;
use bdk::blockchain::esplora::EsploraBlockchain;
use bdk::bitcoin::blockdata::script::Script;
use bdk::bitcoin::bip32::ExtendedPrivKey;
use bdk::electrum_client::ElectrumApi;
use bdk::template::DescriptorTemplate;
use bdk::bitcoin::{Network, Address};
use bdk::database::SqliteDatabase;
use bdk::database::MemoryDatabase;
use bdk::electrum_client::Client;
use bdk::wallet::{AddressIndex};
use bdk::template::Bip86;
use bdk::sled::Tree;
use bdk::FeeRate;
use bdk::Wallet as BDKWallet;

use serde::{Serialize, Deserialize};
use secp256k1::rand::RngCore;
use secp256k1::rand;
use std::path::PathBuf;

pub struct Wallet{
    pub inner: BDKWallet<SqliteDatabase>,
    pub blockchain: ElectrumBlockchain,
}

impl Wallet {
    pub fn generate_seed() -> [u8; 64] {
        let mut seed: [u8; 64] = [0; 64];
        rand::thread_rng().fill_bytes(&mut seed);
        seed
    }

    pub fn generate_descs(seed: [u8; 64]) -> Result<(DescriptorSet), Error> {
        let xpriv = ExtendedPrivKey::new_master(Network::Bitcoin, &seed)?;
        let ex_desc = Bip86(xpriv, KeychainKind::External).build(Network::Bitcoin)?;
        let external = ex_desc.0.to_string_with_secret(&ex_desc.1);
        let in_desc = Bip86(xpriv, KeychainKind::Internal).build(Network::Bitcoin)?;
        let internal = in_desc.0.to_string_with_secret(&in_desc.1);
        Ok(DescriptorSet{external, internal})
    }

    pub fn new(descriptors: &DescriptorSet, path: PathBuf) -> Result<Self, Error> {
        let database = SqliteDatabase::new(path.join("bdk.db"));
        let client_uri = "ssl://electrum.blockstream.info:50002";

        Ok(Wallet{
            inner: BDKWallet::new(&descriptors.external, Some(&descriptors.internal), Network::Bitcoin, database)?,
            blockchain: ElectrumBlockchain::from(Client::new(client_uri)?)
        })
    }

    pub fn list_txs(&self) -> Result<Vec<Transaction>, Error> {
        let wallet_transactions = self.inner.list_transactions(true)?;
    }


    pub async fn sync(&mut self) -> Result<(), Error> {
        self.inner.sync(&self.blockchain, SyncOptions::default())?;
        Ok(())
    }
}
