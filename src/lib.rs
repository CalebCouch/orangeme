use rust_on_rails::prelude::*;
use rust_on_rails::prelude::Text as BasicText;
use pelican_ui::prelude::*;
use serde::{Serialize, Deserialize};
use std::sync::mpsc::{channel, Sender, Receiver};
use std::time::Duration;

//FOR TESTING DO NOT REMOVE
//mod canvas;
//pub use canvas::*;

//  mod flows;
//  use crate::flows::*;

//  use std::time::Duration;

//  #[derive(Serialize, Deserialize, Default, Debug)]
//  pub struct Count(u64);

//  #[derive(Serialize, Deserialize, Default, Debug)]
//  pub struct CacheCount(u64);

//  //  pub struct MyBackgroundApp{
//  //      cache: Cache
//  //  }

//  //  impl MyBackgroundApp {
//  //      async fn tick5(&mut self) {
//  //          let count = self.cache.get::<CacheCount>().await.0;
//  //          println!("on_background+tick: {}", count+1);
//  //          self.cache.set(CacheCount(count+1)).await;
//  //      }
//  //  }

//  //  impl HeadlessApp for MyBackgroundApp {
//  //      const LOG_LEVEL: log::Level = log::Level::Error;
//  //      async fn new(cache: Cache) -> Self {
//  //          MyBackgroundApp{cache}
//  //      }

//  //      async fn register_tasks() -> BackgroundTasks {
//  //          vec![
//  //              task!(Duration::from_secs(5), MyBackgroundApp::tick5)
//  //          ]
//  //      }
//  //  }

//  //  pub struct ActiveApp{
//  //      cache: Cache,
//  //      results: Sender<Callback>
//  //  }

//  //  impl ActiveApp {
//  //      pub fn new(cache: cache, results: Sender<Callback>) -> Self {
//  //          ActiveApp{cache, results}
//  //      }

//  //      async fn async_tick(&mut self) {
//  //          let cache_count = self.cache.get::<CacheCount>().await.0;
//  //          println!("Async Tick 1 secs apart, cache_count: {}", cache_count);
//  //          self.results.send(Box::new(move |state: &mut State| {
//  //              let count = state.get::<Count>().0;
//  //              state.set(&CacheCount(cache_count));
//  //              state.set(&Count(count + 1));
//  //          })).unwrap();
//  //      }
//  //  }

//  //  impl HeadlessApp for ActiveApp {
//  //      fn register_tasks() -> Vec<Task<Self>> {
//  //          vec![
//  //              task!(Duration::from_secs(1), MyApp::async_tick)
//  //          ]
//  //      }
//  //  }


//  use bdk_wallet::{Wallet, KeychainKind, ChangeSet};
//  use bdk_wallet::descriptor::template::Bip86;
//  use bdk_wallet::bitcoin::bip32::Xpriv;
//  use bdk_wallet::bitcoin::Network;
//  use bdk_wallet::{PersistedWallet, WalletPersister};
//  use bdk_wallet::chain::Merge;

//  #[derive(Serialize, Deserialize, Default, Clone, Debug)]
//  pub struct WalletKey(Option<Xpriv>);

//  #[derive(Serialize, Deserialize, Default, Debug)]
//  pub struct WalletInfo(ChangeSet);

//  #[derive(Serialize, Deserialize, Default, Debug)]
//  pub struct MemoryPersister(ChangeSet);
//  impl WalletPersister for MemoryPersister {
//      type Error = ();
//      fn initialize(persister: &mut Self) -> Result<ChangeSet, Self::Error> {Ok(persister.0.clone())}
//      fn persist(persister: &mut Self, changeset: &ChangeSet) -> Result<(), Self::Error> {Ok(persister.0.merge(changeset.clone()))}
//  }

//  pub struct BDKPlugin {
//      wallet: PersistedWallet<MemoryPersister>
//  }

//  impl BDKPlugin {
//      pub async fn init(cache: &mut Cache) -> Self {
//          let mut db = cache.get::<MemoryPersister>().await; 
//          let (ext, int) = Self::get_descriptors(cache).await;
//          let network = Network::Bitcoin;
//          let wallet_opt = Wallet::load()
//              .descriptor(KeychainKind::External, Some(ext.clone()))
//              .descriptor(KeychainKind::Internal, Some(int.clone()))
//              .extract_keys()
//              .check_network(network)
//              .load_wallet(&mut db)
//              .expect("wallet");
//          let mut wallet = match wallet_opt {
//              Some(wallet) => wallet,
//              None => Wallet::create(ext, int)
//                  .network(network)
//                  .create_wallet(&mut db)
//                  .expect("wallet"),
//          };

//          BDKPlugin{wallet}
//      }

//      pub async fn get_descriptors(cache: &mut Cache) -> (Bip86<Xpriv>, Bip86<Xpriv>) {
//          //TODO: from web 5 normally
//          let key = cache.get::<WalletKey>().await.0.unwrap_or(
//              Xpriv::new_master(Network::Bitcoin, &secp256k1::SecretKey::new(&mut secp256k1::rand::thread_rng()).secret_bytes()).unwrap()
//          );
//          cache.set(WalletKey(Some(key.clone()))).await;
//          (Bip86(key.clone(), KeychainKind::External), 
//           Bip86(key, KeychainKind::Internal))
//      }
//  }
//
pub struct BDKPlugin;
impl BDKPlugin {
    async fn init(&mut self) {//Include theme
        println!("Initialized BDK");
    }
}

impl Plugin for BDKPlugin {
    async fn background_tasks(_ctx: &mut HeadlessContext) -> Tasks {vec![]}

    async fn new(ctx: &mut Context<'_>, h_ctx: &mut HeadlessContext) -> (Self, Tasks) {
        (BDKPlugin{}, vec![])
    }
}

mod flows;
use crate::flows::*;

pub struct MyApp;

impl App for MyApp {
    //TODO: include_plugins![BDKPlugin]; || #[derive(Plugins[BDKPlugin])] || #[Plugins[BDKPlugin]]
    async fn background_tasks(ctx: &mut HeadlessContext) -> Tasks {
        BDKPlugin::background_tasks(ctx).await
    }

    async fn plugins(ctx: &mut Context<'_>, h_ctx: &mut HeadlessContext) -> (Plugins, Tasks) {
        let (plugin, tasks) = BDKPlugin::new(ctx, h_ctx).await;
        let pelican = PelicanUI::new(ctx);
       
        (std::collections::HashMap::from([
            (std::any::TypeId::of::<BDKPlugin>(), Box::new(plugin) as Box<dyn std::any::Any>),
            (std::any::TypeId::of::<PelicanUI>(), Box::new(pelican) as Box<dyn std::any::Any>)
        ]), tasks)
    }

    async fn new(ctx: &mut Context<'_>) -> Box<dyn Drawable> {
        ctx.get::<BDKPlugin>().init();
        // let page = ScanQR::new(ctx).page();
        // let font = ctx.add_font(include_bytes!("../resources/fonts/outfit_regular.ttf"));

        
        // Box::new(Interface::new(ctx, page))
        //Box::new(BasicText::new("Hello", Color(0, 0, 255, 255), None, 48.0, 60.0, font))
      let navigation = (0 as usize, vec![
         ("wallet", "Bitcoin", Box::new(|ctx: &mut Context| BitcoinHome.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
         ("messages", "Messages", Box::new(|ctx: &mut Context| MessagesHome.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
         // ("profile", "My Profile", Box::new(|ctx: &mut Context| MyProfile.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
      ]);

      let profile = ("My Profile", AvatarContent::Icon("profile", AvatarIconStyle::Secondary), Box::new(|ctx: &mut Context| MyProfile.navigate(ctx)) as Box<dyn FnMut(&mut Context)>);

      let page = BitcoinHome.build_page(ctx);
      Box::new(Interface::new(ctx, page, navigation, profile))
    }
}

create_entry_points!(MyApp);
