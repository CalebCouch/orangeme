use rust_on_rails::prelude::*;

use serde::{Serialize, Deserialize};
use std::time::{Instant, Duration};
use chrono::{DateTime, Utc};
use std::sync::Arc;
use std::ops::Sub;

//  #[derive(Serialize, Deserialize, Default, Debug)]
//  pub struct Price(f64);

//  async fn get_price() -> (Option<Duration>, Box<dyn FnOnce(&mut State) + Send>) {
//      println!("getting_price");
//      std::thread::sleep(Duration::from_secs(1));
//      println!("got_price");
//      let got_price = Price(1.0);
//      (
//          Some(Duration::from_secs(4)),
//          Box::new(move |state: &mut State| state.set(&got_price))
//      )
//  }
//async fn root(ctx: &mut Context<'_>) -> Box<dyn Drawable> {
//}
//  ctx.schedule_task(Duration::from_secs(0), get_price);
//      ctx.schedule_task(Duration::from_secs(5), async || {
//          //std::thread::sleep(Duration::from_secs(5));
//          println!("5 sec tick");
//          (Some(Duration::from_secs(5)), Box::new(move |state: &mut State| {}) as Callback)
//      });


#[derive(Serialize, Deserialize, Default, Debug)]
pub struct Timestamp(DateTime<Utc>);

#[derive(Serialize, Deserialize, Default, Debug)]
pub struct Count(u64);


#[derive(Serialize, Deserialize, Default, Debug)]
pub struct CacheCount(u64);

pub struct MyBackgroundApp;

impl BackgroundApp for MyBackgroundApp {
    const LOG_LEVEL: log::Level = log::Level::Error;

    async fn new(ctx: &mut AsyncContext) -> Self {
        MyBackgroundApp
    }
    async fn on_tick(&mut self, ctx: &mut AsyncContext) {
        println!("on_background");
        if ctx.cache.get::<Timestamp>().await.0 < Utc::now().sub(Duration::from_secs(5)) {
            ctx.cache.set(Timestamp(Utc::now())).await;
            let count = ctx.cache.get::<CacheCount>().await.0;
            println!("on_background+tick: {}", count+1);
            ctx.cache.set(CacheCount(count+1)).await;
        }
    }
}

pub struct MyApp;

impl App for MyApp {
    const LOG_LEVEL: log::Level = log::Level::Error;

    async fn new(ctx: &mut Context) -> Self {MyApp}

    async fn on_resume<W: HasWindowHandle + HasDisplayHandle>(
        &mut self, ctx: &mut Context, window: Arc<W>, width: u32, height: u32, scale_factor: f64
    ) {
        println!("Resumed");
    }

    async fn on_async_tick(ctx: &mut AsyncContext) -> Callback {
        std::thread::sleep(std::time::Duration::from_secs(1));
        let cache_count = ctx.cache.get::<CacheCount>().await.0;
        println!("Async Tick 1 secs apart, cache_count: {}", cache_count);
        Box::new(move |state: &mut State| {
            let count = state.get::<Count>().0;
            state.set(&CacheCount(cache_count));
            state.set(&Count(count + 1));
        })
    }

    fn on_pause(&mut self, ctx: &mut Context) {println!("Paused");}
    fn on_close(self, ctx: &mut Context) {println!("Closed");}

    fn on_tick(&mut self, ctx: &mut Context) {println!("Tick: {}, Cache: {}", ctx.state.get::<Count>().0, ctx.state.get::<CacheCount>().0);}

    fn on_event(&mut self, ctx: &mut Context, event: Event) {}
}

create_entry_points!(MyApp, MyBackgroundApp);
