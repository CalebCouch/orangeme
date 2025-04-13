
use pelican_ui::prelude::*;
use rust_on_rails::prelude::*;

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

impl App for MyApp {
    async fn root(ctx: &mut Context<'_>) -> Box<dyn Drawable> {
        let plugin = PelicanUI::init(ctx);
        ctx.configure_plugin(plugin);

        // let theme = &ctx.get::<PelicanUI>().theme;      
        
        // scan_qr();
        

        // let flow = OrangeFlow::Bitcoin(BitcoinFlow::Home(page));
        // let text = pelican_ui::prelude::Text::new(ctx, "Test Text", TextStyle::Primary, 48);
        // let size = Size::max()
        // Box::new(text)

        // let flow = BitcoinFlow::Home(BitcoinHome::new(ctx));
        let page = Receive::new(ctx).page();
        Box::new(Interface::new(ctx, page))

        // Box::new(Button::secondary(ctx, Some("edit"), "Edit Address", None, |_ctx: &mut Context| println!("Button")))

    }
}

create_entry_points!(MyApp);

#[no_mangle]
pub extern "C" fn ios_background() {
    println!("APP REFRESH CALLED FROM RUST");
}

