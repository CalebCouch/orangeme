use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;

pub enum BitcoinFlow {
    Home(BitcoinHome),
    SendFlow(Address, Amount, Speed, Confirm, Success),
    ReceiveFlow(Receive),
    ViewTransactionFlow(ViewTransaction)
}

pub struct BitcoinHome(Page);

impl BitcoinHome {
    pub fn new(ctx: &mut Context) -> Self {
        let send = Button::primary(ctx, "Send", |_ctx: &mut Context| println!("Send..."));
        let receive = Button::primary(ctx, "Receive", |_ctx: &mut Context| send_push("Received Bitcoin", "You received $10.00"));
        let bumper = Bumper::new(vec![Box::new(receive), Box::new(send)]);
        
        let transaction = ListItem::bitcoin(ctx, true, 10.00, "Saturday", |_ctx: &mut Context| println!("View transaction..."));
        let amount_display = AmountDisplay::new(ctx, "$10.00", "0.00001234 BTC", None);

        let content = Content::new(Offset::Start, vec![
            Box::new(amount_display), 
            Box::new(transaction)
        ]);
        
        let header = Header::home(ctx, "Wallet");
        BitcoinHome(Page::new(header, content, Some(bumper)))
    }

    pub fn page(self) -> Page {self.0}
}

extern "C" {
    fn trigger_push_notification(title: *const std::os::raw::c_char, body: *const std::os::raw::c_char);
}

fn send_push(title: &str, body: &str) {
    let c_title = std::ffi::CString::new(title).unwrap();
    let c_body = std::ffi::CString::new(body).unwrap();
    unsafe {
        trigger_push_notification(c_title.as_ptr(), c_body.as_ptr());
    }
}

pub struct Address(AddressHome, ScanQR, SelectContact);

pub struct AddressHome(Page);

impl AddressHome {
    pub fn new(ctx: &mut Context) -> Self {
        let continue_btn = Button::primary(ctx, "Continue", |_ctx: &mut Context| println!("Continue..."));
        let bumper = Bumper::new(vec![Box::new(continue_btn)]);
        
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let address_input = TextInput::new(ctx, None, "Bitcoin address...", None, icon_button);

        let paste = Button::secondary(ctx, Some("paste"), "Paste Clipboard", None, |_ctx: &mut Context| { 
            println!("Paste... {}",  read_clipboard().unwrap_or("Could not read clipboard.".to_string()))
        });
        let scan_qr = Button::secondary(ctx, Some("qr_code"), "Scan QR Code", None, |_ctx: &mut Context| println!("Scan..."));
        let contact = Button::secondary(ctx, Some("profile"), "Select Contact", None, |_ctx: &mut Context| println!("Select Contact..."));
        let quick_actions = QuickActions::new(vec![paste, scan_qr, contact]);

        let content = Content::new(Offset::Start, vec![
            Box::new(address_input), 
            Box::new(quick_actions)
        ]);

        let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::stack(ctx, Some(back), "Send bitcoin", None);
        AddressHome(Page::new(header, content, Some(bumper)))
    } // REMOVE TAB NAV - WE ARE IN A FLOW

    pub fn page(self) -> Page {self.0}
}

extern "C" {
    fn get_clipboard_string() -> *const std::os::raw::c_char;
}

fn read_clipboard() -> Option<String> {
    unsafe {
        let ptr = get_clipboard_string();
        if ptr.is_null() {
            None
        } else {
            Some(std::ffi::CStr::from_ptr(ptr).to_string_lossy().into_owned())
        }
    }
}


pub struct ScanQR(Page);

impl ScanQR {
    pub fn new(ctx: &mut Context) -> Self {
        // #[cfg(target_os = "ios")]
        capture();

        let content = Content::new(Offset::Center, vec![Box::new(QRCodeScanner::new(ctx))]);
        let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::stack(ctx, Some(back), "Scan QR Code", None);
        ScanQR(Page::new(header, content, None))
    } 

    pub fn page(self) -> Page {self.0}
}

pub struct SelectContact(Page);

impl SelectContact {
    pub fn new(ctx: &mut Context) -> Self {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, "Profile name...", None, icon_button);

        let contacts = vec![
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Anne Eave", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact...")),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Bob David", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact...")),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Charlie Charles", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact...")),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Danielle Briebs", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact...")),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Ethan A.", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact..."))
        ];

        let contact_list = ListItemGroup::new(ctx, contacts);

        let content = Content::new(Offset::Start, vec![Box::new(searchbar), Box::new(contact_list)]);

        let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        SelectContact(Page::new(header, content, None))
    } // REMOVE TAB NAV - WE ARE IN A FLOW

    pub fn page(self) -> Page {self.0}
}

pub struct Amount(Page);

impl Amount {
    pub fn new(ctx: &mut Context) -> Self {
        let is_mobile = pelican_ui::config::IS_MOBILE;
        let continue_btn = Button::primary(ctx, "Continue", |_ctx: &mut Context| println!("Continue..."));
        let bumper = Bumper::new(vec![Box::new(continue_btn)]);
        
        let amount_display = AmountInput::new(ctx);
        let numeric_keypad = NumericKeypad::new(ctx);

        let mut content: Vec<Box<dyn Drawable>> = vec![Box::new(amount_display)];
        is_mobile.then(|| content.push(Box::new(numeric_keypad)));
        let content = Content::new(Offset::Center, content);

        let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::stack(ctx, Some(back), "Bitcoin amount", None);
        Amount(Page::new(header, content, Some(bumper)))
    } // REMOVE TAB NAV - WE ARE IN A FLOW

    pub fn page(self) -> Page {self.0}
}

pub struct Speed(Page);
pub struct Confirm(Page);
pub struct Success(Page);

pub struct Receive(Page);

pub struct ViewTransaction(Page);