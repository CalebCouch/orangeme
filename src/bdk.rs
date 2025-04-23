use rust_on_rails::prelude::*;
use serde::{Serialize, Deserialize};
use std::sync::{Arc, Mutex};
use std::time::Duration;

use bdk_wallet::{Wallet, KeychainKind, ChangeSet};
use bdk_wallet::descriptor::template::Bip86;
use bdk_wallet::bitcoin::bip32::Xpriv;
pub use bdk_wallet::bitcoin::{Amount, Network, Address};
use bdk_wallet::{PersistedWallet, WalletPersister};
use bdk_wallet::chain::Merge;
use bdk_esplora::esplora_client::Builder;
use bdk_esplora::EsploraExt;

#[derive(Serialize, Deserialize, Default, Clone, Debug)]
pub struct WalletKey(Option<Xpriv>);

#[derive(Serialize, Deserialize, Default, Debug, Clone)]
pub struct MemoryPersister(ChangeSet);
impl WalletPersister for MemoryPersister {
    type Error = ();
    fn initialize(persister: &mut Self) -> Result<ChangeSet, Self::Error> {Ok(persister.0.clone())}
    fn persist(persister: &mut Self, changeset: &ChangeSet) -> Result<(), Self::Error> {Ok(persister.0.merge(changeset.clone()))}
}

pub struct CachePersister(Arc<Mutex<MemoryPersister>>);
#[async_trait]
impl Task for CachePersister {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(1))}

    async fn run(&mut self, h_ctx: &mut HeadlessContext) {
        println!("persisting");
        let mut change_set = h_ctx.cache.get::<MemoryPersister>().await.0;
        change_set.merge(self.0.lock().unwrap().0.clone());
        h_ctx.cache.set(&change_set).await;
    }
}

pub struct BDKPlugin {
    wallet: PersistedWallet<MemoryPersister>,
    persister: Arc<Mutex<MemoryPersister>>
}
impl BDKPlugin {
    pub async fn init(&mut self) {//Include theme
        println!("Initialized BDK");
    }

    pub async fn get_descriptors(cache: &mut Cache) -> (Bip86<Xpriv>, Bip86<Xpriv>) {
        //TODO: from web 5 normally
        let key = cache.get::<WalletKey>().await.0.unwrap_or(
            Xpriv::new_master(Network::Bitcoin, &secp256k1::SecretKey::new(&mut secp256k1::rand::thread_rng()).secret_bytes()).unwrap()
        );
        println!("key: {}", hex::encode(key.private_key.secret_bytes()));
        cache.set(&WalletKey(Some(key.clone()))).await;
        (Bip86(key.clone(), KeychainKind::External), 
         Bip86(key, KeychainKind::Internal))
    }

    pub async fn get_wallet(cache: &mut Cache) -> (PersistedWallet<MemoryPersister>, MemoryPersister) {
        let mut db = cache.get::<MemoryPersister>().await; 
        let (ext, int) = Self::get_descriptors(cache).await;
        let network = Network::Bitcoin;
        let wallet_opt = Wallet::load()
            .descriptor(KeychainKind::External, Some(ext.clone()))
            .descriptor(KeychainKind::Internal, Some(int.clone()))
            .extract_keys()
            .check_network(network)
            .load_wallet(&mut db)
            .expect("wallet");
        (match wallet_opt {
            Some(wallet) => wallet,
            None => Wallet::create(ext, int)
                .network(network)
                .create_wallet(&mut db)
                .expect("wallet"),
        }, db)
    }
    pub fn get_balance(&self) -> Amount {
        self.wallet.balance().trusted_spendable()
    }

    pub fn get_new_address(&mut self) -> Address {
        let address = self.wallet.reveal_next_address(KeychainKind::External).address;
        self.wallet.persist(&mut self.persister.lock().unwrap()).expect("write is okay");
        address
    }
}

impl Plugin for BDKPlugin {
    async fn background_tasks(ctx: &mut HeadlessContext) -> Tasks {
        let (wallet, persister) = Self::get_wallet(&mut ctx.cache).await;
        tasks![WalletSync(wallet, persister)]
    }

    async fn new(ctx: &mut Context<'_>, h_ctx: &mut HeadlessContext) -> (Self, Tasks) {
        let (wallet, persister) = Self::get_wallet(&mut h_ctx.cache).await;
        let persister = Arc::new(Mutex::new(persister));
        (BDKPlugin{wallet, persister: persister.clone()}, tasks![CachePersister(persister)])
    }
}

pub struct WalletSync(PersistedWallet<MemoryPersister>, MemoryPersister);
#[async_trait]
impl Task for WalletSync {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(5))}

    async fn run(&mut self, h_ctx: &mut HeadlessContext) {
        let sync_request = self.0.start_sync_with_revealed_spks()
        .inspect(|item, progress| {println!("items remaining: {:?}", progress.remaining());})
        .build();

        let builder = Builder::new("https://blockstream.info/api");
        let blocking_client = builder.build_blocking();
        let _ = blocking_client.sync(sync_request, 1).unwrap();
        self.0.persist(&mut self.1).expect("write is okay");
        let mut change_set = h_ctx.cache.get::<MemoryPersister>().await.0;
        change_set.merge(self.1.0.clone());
        h_ctx.cache.set(&change_set).await;
    }
}
