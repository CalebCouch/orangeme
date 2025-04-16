
use pelican_ui::prelude::*;
use rust_on_rails::prelude::*;

use serde::{Serialize, Deserialize};
use std::time::Duration;

#[derive(Serialize, Deserialize, Default, Debug)]
pub struct Count(u64);

#[derive(Serialize, Deserialize, Default, Debug)]
pub struct CacheCount(u64);

pub struct MyBackgroundApp{}

impl MyBackgroundApp {
    async fn tick5(&mut self, ctx: &mut AsyncContext) {
        let count = ctx.cache.get::<CacheCount>().await.0;
        println!("on_background+tick: {}", count+1);
        ctx.cache.set(CacheCount(count+1)).await;
    }
}

impl BackgroundApp for MyBackgroundApp {
    const LOG_LEVEL: log::Level = log::Level::Error;
    async fn new(ctx: &mut AsyncContext) -> Self {
        MyBackgroundApp{}
    }

    async fn register_tasks(&mut self, ctx: &mut AsyncContext) -> BackgroundTasks {
        vec![
            background_task!(Duration::from_secs(5), MyBackgroundApp::tick5)
        ]
    }
}


mod flows;
use crate::flows::*;

pub struct MyApp;

impl MyApp {
    async fn async_tick(ctx: &mut AsyncContext) -> Callback {
        let cache_count = ctx.cache.get::<CacheCount>().await.0;
        println!("Async Tick 1 secs apart, cache_count: {}", cache_count);
        Box::new(move |state: &mut State| {
            let count = state.get::<Count>().0;
            state.set(&CacheCount(cache_count));
            state.set(&Count(count + 1));
        })
    }
}

impl App for MyApp {
    async fn register_tasks() -> AsyncTasks {
        vec![
            async_task!(Duration::from_secs(1), MyApp::async_tick)
        ]
    }

    async fn root(ctx: &mut Context<'_, '_>) -> Box<dyn Drawable> {
        let plugin = PelicanUI::init(ctx);
        ctx.configure_plugin(plugin);

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

create_entry_points!(MyApp, MyBackgroundApp);
