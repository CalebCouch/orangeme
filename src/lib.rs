use pelican_ui::{Component, Context, Plugins, Plugin, maverick_start, start, Application, PelicanEngine, MaverickOS, HardwareContext};
use pelican_ui::drawable::{Drawable, Component};
use pelican_ui_std::{AvatarIconStyle, AvatarContent, Interface, NavigateEvent, AppPage};
use pelican_ui::runtime::{Services, Service, ServiceList};
use profiles::plugin::{ProfilePlugin, NameGenerator};
use profiles::service::{Name, Profiles, ProfileService};
use profiles::components::AvatarContentProfiles;
use messages::plugin::MessagesPlugin;
use std::sync::{Arc, Mutex};
use std::any::TypeId;
use std::collections::BTreeMap;
use std::pin::Pin;
use std::future::Future;

use bitcoin::service::BDKService;
use messages::service::RoomsService;

use bitcoin::pages::*;
use bitcoin::components::IconButtonBitcoin;
use messages::pages::*;
use messages::components::IconButtonMessages;
use profiles::pages::*;
use profiles::components::IconButtonProfiles;

use pelican_ui_std::{Stack, Splash};
use pelican_ui::layout::{Area, SizeRequest, Layout};
use pelican_ui::events::{Event, OnEvent, TickEvent};

// mod bdk;
// use bdk::BDKPlugin;
mod msg;
// use msg::MSGPlugin;
// use ucp_rust::UCPPlugin;

pub struct MyApp;
impl Services for MyApp {
    fn services() -> ServiceList {
        let mut services = ServiceList::default();
        services.insert::<ProfileService>();
        services.insert::<BDKService>();
        services.insert::<RoomsService>();
        services
    }
}

impl Plugins for MyApp {
    fn plugins(ctx: &mut Context) -> Vec<Box<dyn Plugin>> {
        vec![Box::new(ProfilePlugin::new(ctx)), Box::new(MessagesPlugin::new(ctx))]
    }
}

impl Application for MyApp {
    async fn new(ctx: &mut Context) -> Box<dyn Drawable> { App::new(ctx) }
}

start!(MyApp);

#[derive(Debug, Component)]
pub struct App(Stack, Interface);

impl App {
    pub fn new(ctx: &mut Context) -> Box<Self> {
        let mut account_actions = Arc::new(Mutex::new(vec![
            IconButtonBitcoin::new(ctx), // AccountAction("wallet", Box::new(|ctx: &mut Context| Box::new(BitcoinHome::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>),
            IconButtonMessages::new(ctx),
            IconButtonProfiles::block(ctx) // AccountAction("block", Box::new(|ctx: &mut Context| Box::new(BitcoinHome::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>)
        ]));

        let navigation = vec![
            ("wallet", "Bitcoin".to_string(), None, Some(Box::new(|ctx: &mut Context| Box::new(BitcoinHome::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>)),
            ("messages", "Messages".to_string(), None, Some(Box::new(move |ctx: &mut Context| Box::new(MessagesHome::new(ctx, account_actions.clone())) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>)),
            ("profile", "My Profile".to_string(), Some(AvatarContentProfiles::default()), Some(Box::new(|ctx: &mut Context| Box::new(Account::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>))
        ];

        let home = BitcoinHome::new(ctx);
        let interface = Interface::new(ctx, Box::new(home), Some((0_usize, navigation)));
        Box::new(App(Stack::default(), interface))
    }
}

impl OnEvent for App {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            if ctx.state().get::<Name>().is_some() {
                self.1.desktop().as_mut().map(|d| d.navigator().as_mut().map(|nav| {
                    let me = ProfilePlugin::me(ctx).0;
                    nav.update_avatar(AvatarContentProfiles::from_orange_name(ctx, &me));

                    // let username = ProfilePlugin::get_username(ctx);
                    // let username = NameGenerator::display_name(username);
                    // nav.update_username(username)
                }));
            }
        }
        true
    }
}