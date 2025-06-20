use pelican_ui::{Context, Plugins, Plugin, maverick_start, start, Application, PelicanEngine, MaverickOS, HardwareContext};
use pelican_ui::drawable::Drawable;
use pelican_ui_std::{AvatarIconStyle, AvatarContent, Interface, NavigateEvent, AppPage};
use pelican_ui::runtime::{Services, Service, ServiceList};
use profiles::plugin::ProfilePlugin;
use profiles::service::{Name, Profiles, ProfileService};
use std::any::TypeId;
use std::collections::BTreeMap;
use std::pin::Pin;
use std::future::Future;

use bitcoin::pages::*;
use messages::pages::*;
use profiles::pages::*;

// use tokio::time::{sleep, Duration};

// mod bdk;
// use bdk::BDKPlugin;
mod msg;
// use msg::MSGPlugin;
// use ucp_rust::UCPPlugin;

use bitcoin::service::BDKService;

pub struct MyApp;
impl Services for MyApp {
    fn services() -> ServiceList {
        let mut services = ServiceList::default();
        services.insert::<ProfileService>();
        services.insert::<BDKService>();
        services
    }
}

impl Plugins for MyApp {
    fn plugins(ctx: &mut Context) -> Vec<Box<dyn Plugin>> {
        vec![Box::new(ProfilePlugin::new(ctx))]
    }
}

impl Application for MyApp {
    //TODO: include_plugins![BDKPlugin]; || #[derive(Plugins[BDKPlugin])] || #[Plugins[BDKPlugin]]
    // async fn background_tasks(ctx: &mut HeadlessContext) -> Tasks {
    //     // BDKPlugin::background_tasks(ctx).await
    //     vec![]
    // }

    // async fn plugins(ctx: &mut Context, h_ctx: &mut HeadlessContext) -> (Plugins, Tasks) {
    //     // let (bdk_plugin, mut tasks) = BDKPlugin::new(ctx, h_ctx).await;
    //     // let (msg_plugin, msg_tasks) = MSGPlugin::new(ctx, h_ctx).await;
    //     // let (pel_plugin, _p_tasks) = PelicanUI::new(ctx, h_ctx).await;
    //     // let (ucp, tasks) = UCPPlugin::new(ctx, h_ctx).await;

    //     // tasks.extend(msg_tasks);
    
    //     (std::collections::HashMap::from([
    //         // (std::any::TypeId::of::<BDKPlugin>(), Box::new(bdk_plugin) as Box<dyn std::any::Any>),
    //         // (std::any::TypeId::of::<MSGPlugin>(), Box::new(msg_plugin) as Box<dyn std::any::Any>),
    //         // (std::any::TypeId::of::<PelicanUI>(), Box::new(pel_plugin) as Box<dyn std::any::Any>),
    //         // (std::any::TypeId::of::<UCPPlugin>(), Box::new(ucp) as Box<dyn std::any::Any>)
    //     ]), vec![])
    // }

    async fn new(ctx: &mut Context) -> Box<dyn Drawable> {
        // sleep(Duration::from_secs(30)).await;

        let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary); // tmp

        let navigation = vec![
            ("wallet", "Bitcoin", None, Some(Box::new(|ctx: &mut Context| Box::new(BitcoinHome::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>)),
            ("messages", "Messages", None, Some(Box::new(|ctx: &mut Context| Box::new(MessagesHome::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>)),
            ("profile", "My Profile", Some(avatar), Some(Box::new(|ctx: &mut Context| {
                loop {
                    let name = ctx.state().get::<Name>().0;
                    println!("name: {:?}", name);
                    if name.is_some() { return Box::new(Account::new(ctx)) as Box<dyn AppPage>; }
                }
            }) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>))
        ];
        
        // let rooms = messages::Rooms::new(ctx);
        // ctx.state().set(&rooms); 
        let home = BitcoinHome::new(ctx);
        // Some((0_usize, navigation))
        Box::new(Interface::new(ctx, Box::new(home), Some((0_usize, navigation))))
    }

    // fn error(ctx: &mut Context, error: String) -> Box<dyn Drawable> {
    //     let error_page = Error::new(ctx);
    //     Box::new(Interface::new(ctx, error_page, None))
    // }
}

start!(MyApp);
