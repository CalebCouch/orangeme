
use pelican_ui::prelude::*;
use rust_on_rails::prelude::*;

// pub type BitcoinHome = Page;


// pub struct AddressFlow(Address, ScanQR, SelectContact);

// pub struct SendFlow(AddressFlow, Amount, Speed, Confirm, Success);

// pub type MessagesHome = Page;


// pub struct BitcoinFlow(BitcoinHome, SendFlow);
// pub struct MessagesFlow(MessageHome);

// pub struct OrangeFlow(BitcoinFlow, MessagesFlow);

// ------------------------------------------------------------

// struct AppFlow(BitcoinHome, MessagesHome);

// struct BitcoinHome;

// struct SendFlow(Address, Amount, Speed, Confirm, Success);

// struct Address(Home, ScanQR, SelectContact);
// pub type ScanQR = Page;
// pub type SelectContact = Page;
// pub type Amount = Page;
// pub type Speed = Page;
// pub type Confirm = Page;
// pub type Success = Page;

// struct ReceiveFlow(Receive) 
// pub type Receive = Page;

// pub type MessagesHome = Page;

// struct NewMessageFlow(SelectRecipients, Either<DirectMessageFlow, GroupMessageFlow>);
// pub type SelectRecipients = Page;

// struct DirectMessageFlow(DirectMessage);
// pub type DirectMessage = Page;

// struct GroupMessageFlow(GroupMessage, GroupMessageInfo);
// pub type GroupMessage = Page;
// pub type GroupMessageInfo = Page;

// struct AppFlow(BitcoinHome, MessagesHome);

// struct Bitcoin(BitcoinHome, SendFlow, ReceiveFlow);
// struct Messages(MessagesHome, DirectMessageFlow, GroupMessageFlow, NewMessageFlow);




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
        let page = ScanQR::new(ctx).page();
        Box::new(Interface::new(ctx, page))

        // Box::new(Button::secondary(ctx, Some("edit"), "Edit Address", None, |_ctx: &mut Context| println!("Button")))

    }
}

create_entry_points!(MyApp);
