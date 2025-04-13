
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

#[cfg(target_os = "ios")]
extern "C" {
    fn get_clipboard_string() -> *const std::os::raw::c_char;
}

pub fn clipboard() -> String {
    #[cfg(target_os = "ios")]
    unsafe {
        let ptr = get_clipboard_string();
        if ptr.is_null() {
            return String::new();
        }

        let cstr = std::ffi::CStr::from_ptr(ptr);
        let string = cstr.to_string_lossy().into_owned();

        return string
    }

    String::new()
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

        // let theme = &ctx.get::<PelicanUI>().theme;      
        
        // scan_qr();
        

        // let flow = OrangeFlow::Bitcoin(BitcoinFlow::Home(page));
        // let text = pelican_ui::prelude::Text::new(ctx, "Test Text", TextStyle::Primary, 48);
        // let size = Size::max()
        // Box::new(text)

        // let flow = BitcoinFlow::Home(BitcoinHome::new(ctx));
        let page = SelectRecipients::new(ctx).page();
        Box::new(Interface::new(ctx, page))

        // Box::new(Button::secondary(ctx, Some("edit"), "Edit Address", None, |_ctx: &mut Context| println!("Button")))

    }
}

create_entry_points!(MyApp, MyBackgroundApp);
