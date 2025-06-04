use pelican_ui::{Context, Plugins, Services, maverick_start, start, Application, PelicanEngine, MaverickOS};
use pelican_ui::drawable::Drawable;
use pelican_ui_std::{AvatarIconStyle, AvatarContent, Interface, NavigateEvent};

mod flows;
pub use flows::*;
// mod bdk;
// use bdk::BDKPlugin;
// mod msg;
// use msg::MSGPlugin;

// use ucp_rust::UCPPlugin;

pub struct MyApp;
impl Services for MyApp {}

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
            ("wallet", "Bitcoin", None, Box::new(|ctx: &mut Context| BitcoinHome::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("messages", "Messages", None, Box::new(|ctx: &mut Context| MessagesHome::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("profile", "My Profile", Some(avatar), Box::new(|ctx: &mut Context| Account::navigate(ctx)) as Box<dyn FnMut(&mut Context)>)
        ];

        let home = BitcoinHome::new(ctx);
        Box::new(Interface::new(ctx, home, Some((0_usize, navigation))))
    }
}

start!(MyApp);

// use std::thread;
// use std::time::Duration;
// use dispatch2::DispatchQueue;
// use dispatch2::DispatchQueueAttr;
// use dispatch2::DispatchObject;

// fn background_task() {
//     println!("Running background task...");
//     thread::sleep(Duration::from_secs(3));
//     println!("Background task completed!");
// }

// pub fn launch_background_thread() {
//     let attr = DispatchQueueAttr::new_initially_inactive(None);
//     let queue = DispatchQueue::new("RustBackgroundQueue", Some(&attr));
    
//     queue.exec_async(|| {
//         background_task();
//     });

//     queue.activate();
// }