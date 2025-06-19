use pelican_ui::{Component, Context, Plugins, Plugin, maverick_start, start, Application, PelicanEngine, MaverickOS, HardwareContext};
use pelican_ui::drawable::{Drawable, Component};
use pelican_ui_std::{AvatarIconStyle, AvatarContent, Interface, NavigateEvent, AppPage};
use pelican_ui::runtime::{Services, Service, ServiceList};
use profiles::plugin::ProfilePlugin;
use profiles::service::{Name, Profiles, ProfileService};
use profiles::components::AvatarContentProfiles;
use std::any::TypeId;
use std::collections::BTreeMap;
use std::pin::Pin;
use std::future::Future;

use bitcoin::pages::*;
use messages::pages::*;
use profiles::pages::*;

use pelican_ui_std::{Stack};
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
        services
    }
}

impl Plugins for MyApp {
    fn plugins(ctx: &mut Context) -> Vec<Box<dyn Plugin>> {
        vec![Box::new(ProfilePlugin::new(ctx))]
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
        let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary); // tmp

        let navigation = vec![
            ("wallet", "Bitcoin", None, Some(Box::new(|ctx: &mut Context| Box::new(BitcoinHome::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>)),
            ("messages", "Messages", None, Some(Box::new(|ctx: &mut Context| Box::new(MessagesHome::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>)),
            ("profile", "My Profile", Some(avatar), Some(Box::new(|ctx: &mut Context| Box::new(Account::new(ctx)) as Box<dyn AppPage>) as Box<dyn FnMut(&mut Context) -> Box<dyn AppPage>>))
        ];
        
        let rooms = messages::Rooms::new(ctx);
        ctx.state().set(&rooms); 
        let home = BitcoinHome::new(ctx);
        Box::new(App(Stack::default(), Interface::new(ctx, Box::new(home), Some((0_usize, navigation)))))
    }
}

impl OnEvent for App {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            if let Some((orange_name, _)) = ProfilePlugin::me(ctx) {
                self.1.desktop().as_mut().map(|d| d.navigator().as_mut().map(|nav| {
                    nav.update_avatar(AvatarContentProfiles::from_orange_name(ctx, &orange_name))
                }));
            }
        }
        true
    }
}