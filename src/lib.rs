use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;

mod flows;
pub use flows::*;
mod bdk;
use bdk::BDKPlugin;
mod msg;
use msg::MSGPlugin;

// use ucp_rust::UCPPlugin;

pub struct MyApp;

impl App for MyApp {
    //TODO: include_plugins![BDKPlugin]; || #[derive(Plugins[BDKPlugin])] || #[Plugins[BDKPlugin]]
    async fn background_tasks(ctx: &mut HeadlessContext) -> Tasks {
        BDKPlugin::background_tasks(ctx).await
    }
    async fn plugins(ctx: &mut Context, h_ctx: &mut HeadlessContext) -> (Plugins, Tasks) {
        let (bdk_plugin, mut tasks) = BDKPlugin::new(ctx, h_ctx).await;
        let (msg_plugin, msg_tasks) = MSGPlugin::new(ctx, h_ctx).await;
        let (pel_plugin, _p_tasks) = PelicanUI::new(ctx, h_ctx).await;
        // let (ucp, tasks) = UCPPlugin::new(ctx, h_ctx).await;

        tasks.extend(msg_tasks);
    
        (std::collections::HashMap::from([
            (std::any::TypeId::of::<BDKPlugin>(), Box::new(bdk_plugin) as Box<dyn std::any::Any>),
            (std::any::TypeId::of::<MSGPlugin>(), Box::new(msg_plugin) as Box<dyn std::any::Any>),
            (std::any::TypeId::of::<PelicanUI>(), Box::new(pel_plugin) as Box<dyn std::any::Any>),
            // (std::any::TypeId::of::<UCPPlugin>(), Box::new(ucp) as Box<dyn std::any::Any>)
        ]), tasks)
    }

    async fn new(ctx: &mut Context) -> Box<dyn Drawable> {
        ctx.include_assets(include_assets!("./resources/images"));

        let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary); //tpm

        let navigation = vec![
            ("wallet", "Bitcoin", None, Box::new(|ctx: &mut Context| BitcoinHome::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("messages", "Messages", None, Box::new(|ctx: &mut Context| MessagesHome::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("profile", "My Profile", Some(avatar), Box::new(|ctx: &mut Context| Account::navigate(ctx)) as Box<dyn FnMut(&mut Context)>)
        ];

        let home = Error::new(ctx);
        Box::new(Interface::new(ctx, home, Some((0_usize, navigation))))
    }
}

create_entry_points!(MyApp);