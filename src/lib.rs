use pelican_ui::{Context, Plugins, Plugin, Service, Services, ServiceList, maverick_start, start, Application, PelicanEngine, MaverickOS, HardwareContext};
use pelican_ui::drawable::Drawable;
use pelican_ui_std::{AvatarIconStyle, AvatarContent, Interface, NavigateEvent};
use profiles::plugin::ProfilePlugin;
use profiles::service::{Name, Profiles, ProfileService};
use std::any::TypeId;
use std::collections::BTreeMap;
use std::pin::Pin;
use std::future::Future;

mod flows;
pub use flows::*;
// mod bdk;
// use bdk::BDKPlugin;
mod msg;
// use msg::MSGPlugin;

// use ucp_rust::UCPPlugin;

fn service<'a>(ctx: &'a mut HardwareContext) -> Pin<Box<dyn Future<Output = Box<dyn Service>> + 'a >> {
    Box::pin(async move {Box::new(ProfileService::new(ctx).await) as Box<dyn Service>})
}

pub struct MyApp;
impl Services for MyApp {
    fn services() -> ServiceList {
        BTreeMap::from([(
            TypeId::of::<ProfileService>(), 
            Box::new(service) as Box<dyn for<'a> FnOnce(&'a mut HardwareContext) -> Pin<Box<dyn Future<Output = Box<dyn Service>> + 'a>>>
        )])
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
        // launch_background_thread();
        // ctx.include_assets(include_assets!("./resources/images"));

        

        let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary); //tpm

        let navigation = vec![
            ("wallet", "Bitcoin", None, Box::new(|ctx: &mut Context| {
                let page = BitcoinHome::new(ctx);
                ctx.trigger_event(NavigateEvent::new(page));
            }) as Box<dyn FnMut(&mut Context)>),
            ("messages", "Messages", None, Box::new(|ctx: &mut Context| {
                let page = MessagesHome::new(ctx);
                ctx.trigger_event(NavigateEvent::new(page));
            }) as Box<dyn FnMut(&mut Context)>),
            ("profile", "My Profile", Some(avatar), Box::new(|ctx: &mut Context| {
                let page = Account::new(ctx);
                ctx.trigger_event(NavigateEvent::new(page));
            }) as Box<dyn FnMut(&mut Context)>)
        ];

        let home = BitcoinHome::new(ctx).0;
        Box::new(Interface::new(ctx, home, Some((0_usize, navigation))))
    }

    // fn error(ctx: &mut Context, error: String) -> Box<dyn Drawable> {
    //     let error_page = Error::new(ctx);
    //     Box::new(Interface::new(ctx, error_page, None))
    // }
}

start!(MyApp);
