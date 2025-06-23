use pelican_ui::{Component, Context, Plugins, Plugin, maverick_start, start, Application, PelicanEngine, MaverickOS, HardwareContext};
use pelican_ui::drawable::{Drawable, Component};
use pelican_ui_std::{AvatarIconStyle, AvatarContent, Interface, NavigateEvent, AppPage};
use pelican_ui::runtime::{Services, Service, ServiceList};
use profiles::plugin::ProfilePlugin;
use profiles::service::{Name, Profiles, ProfileService};
use profiles::components::AvatarContentProfiles;
use messages::plugin::MessagesPlugin;
use std::any::TypeId;
use std::collections::BTreeMap;
use std::pin::Pin;
use std::future::Future;

use bitcoin::service::BDKService;
use messages::service::RoomsService;

use bitcoin::pages::*;
use messages::pages::*;
use profiles::pages::*;

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
        let start = Splash::new(ctx);
        Box::new(App(Stack::default(), Interface::new(ctx, Box::new(start), None)))
    }
}

impl OnEvent for App {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            if let Some(_) = ctx.state().get::<Name>() {
                let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary); // tmp

                let navigation = vec![
                    ("wallet", "Bitcoin", None, Some(Box::new(|ctx: &mut Context| Box::new(BitcoinHome::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>)),
                    ("messages", "Messages", None, Some(Box::new(|ctx: &mut Context| Box::new(MessagesHome::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>)),
                    ("profile", "My Profile", Some(avatar), Some(Box::new(|ctx: &mut Context| Box::new(Account::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>))
                ];
                let home = BitcoinHome::new(ctx);
                self.1 = Interface::new(ctx, Box::new(home), Some((0_usize, navigation)));
            } else {
                println!("Name not found");
            }

            // if self.2.is_none() {
            //     self.1.desktop().as_mut().map(|d| d.navigator().as_mut().map(|nav| {
            //         let me = ProfilePlugin::me(ctx).0;
            //         nav.update_avatar(AvatarContentProfiles::from_orange_name(ctx, &me))
            //     }));
            // }
        }
        true
    }
}