use rust_on_rails::prelude::*;
use rust_on_rails::prelude::Text as BasicText;
//use pelican_ui::prelude::*;
use serde::{Serialize, Deserialize};
use std::sync::mpsc::{channel, Sender, Receiver};
use std::sync::{Arc, Mutex};
use std::time::Duration;

mod bdk;
use bdk::{BDKPlugin, Address, Amount};


#[derive(Debug, Clone, Component)]
pub struct WalletText(DefaultStack, BasicText, #[skip] Option<Address>);
impl WalletText {
    pub fn new(ctx: &mut Context<'_>) -> Self {
        let font = ctx.add_font(include_bytes!("../resources/fonts/outfit_regular.ttf"));
        WalletText(DefaultStack, BasicText::new(ctx, "Hello", Color(0, 0, 255, 255), font, 48.0, 60.0, None), None)
    }
}
impl OnEvent for WalletText {
    fn on_event(&mut self, ctx: &mut Context<'_>, event: &mut dyn Event) -> bool {
        if event.downcast_ref::<TickEvent>().is_some() {
            let bdk = ctx.get::<BDKPlugin>();
            if let Some(address) = &self.2 {
                self.1.set_text(ctx, &format!("Address: {}", address));
            } else {
                let balance = bdk.get_balance();
                self.1.set_text(ctx, &format!("Balance: {}", balance));
            }
        } else if let Some(event) = event.downcast_ref::<MouseEvent>() {
            if event.state == MouseState::Pressed {
                let bdk = ctx.get::<BDKPlugin>();
                self.2 = Some(bdk.get_new_address());
            }
        }
        true
    }
}

pub struct MyApp;

impl App for MyApp {
    //TODO: include_plugins![BDKPlugin]; || #[derive(Plugins[BDKPlugin])] || #[Plugins[BDKPlugin]]
    async fn background_tasks(ctx: &mut HeadlessContext) -> Tasks {
        BDKPlugin::background_tasks(ctx).await
    }
    async fn plugins(ctx: &mut Context<'_>, h_ctx: &mut HeadlessContext) -> (Plugins, Tasks) {
        let (plugin, tasks) = BDKPlugin::new(ctx, h_ctx).await;
        (std::collections::HashMap::from([
            (std::any::TypeId::of::<BDKPlugin>(), Box::new(plugin) as Box<dyn std::any::Any>)
        ]), tasks)
    }
    //END TODO

    async fn new(ctx: &mut Context<'_>) -> Box<dyn Drawable> {
        ctx.get::<BDKPlugin>().init();
        Box::new(WalletText::new(ctx))
    }
}

create_entry_points!(MyApp);
