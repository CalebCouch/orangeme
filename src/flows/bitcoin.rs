use rust_on_rails::prelude::*;
use rust_on_rails::prelude::Text as BasicText;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

pub enum BitcoinFlow {
    Home(BitcoinHome),
    SendFlow(Address, Amount, Speed, Confirm, Success),
    ReceiveFlow(Receive),
    ViewTransactionFlow(ViewTransaction)
}

pub struct BitcoinHome(Page);

// impl BitcoinHome {
//     pub fn new(ctx: &mut Context) -> Self {
//         let send = Button::primary(ctx, "Send", |_ctx: &mut Context| println!("Send..."));
//         let receive = Button::primary(ctx, "Receive", |_ctx: &mut Context| send_push("Received Bitcoin", "You received $10.00"));
//         let bumper = Bumper::new(vec![Box::new(receive), Box::new(send)]);
        
//         let transaction = ListItem::bitcoin(ctx, true, 10.00, "Saturday", |_ctx: &mut Context| println!("View transaction..."));
//         let amount_display = AmountDisplay::new(ctx, "$10.00", "0.00001234 BTC", None);

//         let content = Content::new(Offset::Start, vec![
//             Box::new(amount_display), 
//             Box::new(transaction)
//         ]);
        
//         let header = Header::home(ctx, "Wallet");
//         BitcoinHome(Page::new(header, content, Some(bumper)))
//     }

//     pub fn page(self) -> Page {self.0}
// }

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

// impl AddressHome {
//     pub fn new(ctx: &mut Context) -> Self {
//         let continue_btn = Button::primary(ctx, "Continue", |_ctx: &mut Context| println!("Continue..."));
//         let bumper = Bumper::new(vec![Box::new(continue_btn)]);
        
//         let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
//         let address_input = TextInput::new(ctx, None, "Bitcoin address...", None, icon_button);

//         let paste = Button::secondary(ctx, Some("paste"), "Paste Clipboard", None, |_ctx: &mut Context| { 
//             println!("Paste... {}",  read_clipboard().unwrap_or("Could not read clipboard.".to_string()))
//         });
//         let scan_qr = Button::secondary(ctx, Some("qr_code"), "Scan QR Code", None, |_ctx: &mut Context| println!("Scan..."));
//         let contact = Button::secondary(ctx, Some("profile"), "Select Contact", None, |_ctx: &mut Context| println!("Select Contact..."));
//         let quick_actions = QuickActions::new(vec![paste, scan_qr, contact]);

//         let content = Content::new(Offset::Start, vec![
//             Box::new(address_input), 
//             Box::new(quick_actions)
//         ]);

//         let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
//         let header = Header::stack(ctx, Some(back), "Send bitcoin", None);
//         AddressHome(Page::new(header, content, Some(bumper)))
//     } // REMOVE TAB NAV - WE ARE IN A FLOW

//     pub fn page(self) -> Page {self.0}
// }

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

// impl ScanQR {
//     pub fn new(ctx: &mut Context) -> Self {
//         // #[cfg(target_os = "ios")]
//         capture();

//         let content = Content::new(Offset::Center, vec![Box::new(QRCodeScanner::new(ctx))]);
//         let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
//         let header = Header::stack(ctx, Some(back), "Scan QR Code", None);
//         ScanQR(Page::new(header, content, None))
//     } 

//     pub fn page(self) -> Page {self.0}
// }

pub struct SelectContact(Page);

// impl SelectContact {
//     pub fn new(ctx: &mut Context) -> Self {
//         let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
//         let searchbar = TextInput::new(ctx, None, "Profile name...", None, icon_button);

//         let contacts = vec![
//             ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Anne Eave", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact...")),
//             ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Bob David", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact...")),
//             ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Charlie Charles", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact...")),
//             ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Danielle Briebs", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact...")),
//             ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Ethan A.", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |_ctx: &mut Context| println!("Select Contact..."))
//         ];

//         let contact_list = ListItemGroup::new(ctx, contacts);

//         let content = Content::new(Offset::Start, vec![Box::new(searchbar), Box::new(contact_list)]);

//         let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
//         let header = Header::stack(ctx, Some(back), "Send to contact", None);
//         SelectContact(Page::new(header, content, None))
//     } // REMOVE TAB NAV - WE ARE IN A FLOW

//     pub fn page(self) -> Page {self.0}
// }

pub struct Amount(Page);

// impl Amount {
//     pub fn new(ctx: &mut Context) -> Self {
//         let is_mobile = pelican_ui::config::IS_MOBILE;
//         let continue_btn = Button::primary(ctx, "Continue", |_ctx: &mut Context| println!("Continue..."));
//         let bumper = Bumper::new(vec![Box::new(continue_btn)]);
        
//         let amount_display = AmountInput::new(ctx);
//         let numeric_keypad = NumericKeypad::new(ctx);

//         let mut content: Vec<Box<dyn Drawable>> = vec![Box::new(amount_display)];
//         is_mobile.then(|| content.push(Box::new(numeric_keypad)));
//         let content = Content::new(Offset::Center, content);

//         let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
//         let header = Header::stack(ctx, Some(back), "Bitcoin amount", None);
//         Amount(Page::new(header, content, Some(bumper)))
//     } // REMOVE TAB NAV - WE ARE IN A FLOW

//     pub fn page(self) -> Page {self.0}
// }

pub struct Speed(Page);

// impl Speed {
//     pub fn new(ctx: &mut Context) -> Self {
//         let continue_btn = Button::primary(ctx, "Continue", |_ctx: &mut Context| println!("Continue..."));
//         let bumper = Bumper::new(vec![Box::new(continue_btn)]);
        
//         let speed_selector = ListItemSelector::new(ctx,
//             ("Standard", "Arrives in ~2 hours", "$0.18 Bitcoin network fee"),
//             ("Priority", "Arrives in ~30 minutes", "$0.35 Bitcoin network fee"),
//             None, None
//         );

//         let content = Content::new(Offset::Start, vec![Box::new(speed_selector)]);

//         let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
//         let header = Header::stack(ctx, Some(back), "Transaction speed", None);
//         Speed(Page::new(header, content, Some(bumper)))
//     } // REMOVE TAB NAV - WE ARE IN A FLOW

//     pub fn page(self) -> Page {self.0}
// }

pub struct Confirm(Page);

// impl Confirm {
//     pub fn new(ctx: &mut Context) -> Self {
//         let continue_btn = Button::primary(ctx, "Continue", |_ctx: &mut Context| println!("Continue..."));
//         let bumper = Bumper::new(vec![Box::new(continue_btn)]);

//         let edit_amount = Button::secondary(ctx, Some("edit"), "Edit Amount", None, |_ctx: &mut Context| println!("Edit amount..."));
//         let edit_speed = Button::secondary(ctx, Some("edit"), "Edit Speed", None, |_ctx: &mut Context| println!("Edit speed..."));
//         let edit_address = Button::secondary(ctx, Some("edit"), "Edit Address", None, |_ctx: &mut Context| println!("Edit address..."));

//         let confirm_amount = DataItem::new(ctx,
//             None, //Some("2"),
//             "Confirm amount",
//             None,
//             None,
//             Some(vec![
//                 ("Amount sent (BTC)", "0.00001234 BTC"),
//                 ("Send speed", "Standard (2 hours)"),
//                 ("Amount sent", "$10.00"),
//                 ("Transaction fee", "$0.18"),
//                 ("Transaction total", "$10.18")
//             ]),
//             Some(vec![edit_amount, edit_speed])
//         );

//         let confirm_address = DataItem::new(ctx,
//             None, // Some("1"),
//             "Confirm address",
//             Some("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"),
//             Some("Bitcoin sent to the wrong address can never be recovered."),
//             None,
//             Some(vec![edit_address])
//         );

//         let content = Content::new(Offset::Start, vec![Box::new(confirm_address), Box::new(confirm_amount)]);

//         let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
//         let header = Header::stack(ctx, Some(back), "Confirm send", None);
//         Confirm(Page::new(header, content, Some(bumper)))
//     } // REMOVE TAB NAV - WE ARE IN A FLOW

//     pub fn page(self) -> Page {self.0}
// }

pub struct Success(Page);

// impl Success {
//     pub fn new(ctx: &mut Context) -> Self {
//         let contact = None; //Some(AvatarContent::Icon("profile", AvatarIconStyle::Secondary));

//         let theme = &ctx.get::<PelicanUI>().theme;
//         let (color, text_size) = (theme.colors.text.heading, theme.fonts.size.h4);

//         let continue_btn = Button::close(ctx, "Continue", |_ctx: &mut Context| println!("Continue..."));
//         let bumper = Bumper::new(vec![Box::new(continue_btn)]);

//         let (text, splash) = if let Some(c) = contact {
//             ("You sent $10.00 to Ella Couch", Box::new(Avatar::new(ctx, c, None, false, 96.0)) as Box<dyn Drawable>)
//         } else {
//             ("You sent $10.00", Box::new(Icon::new(ctx, "bitcoin", color, 96)) as Box<dyn Drawable>)
//         };

//         let text = Text::new(ctx, text, TextStyle::Heading, text_size);
//         let content = Content::new(Offset::Center, vec![splash, Box::new(text)]);

//         let close = IconButton::close(ctx, |_ctx: &mut Context| println!("Close, Go Home!"));
//         let header = Header::stack(ctx, Some(close), "Send confirmed", None);
//         Success(Page::new(header, content, Some(bumper)))
//     } // REMOVE TAB NAV - WE ARE IN A FLOW

//     pub fn page(self) -> Page {self.0}
// }

pub struct Receive(Page);

impl Receive {
    pub fn new(ctx: &mut Context) -> Self {
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
        let share_btn = Button::close(ctx, "Share", |_ctx: &mut Context| println!("Sharing..."));
        let bumper = Bumper::new(vec![Box::new(share_btn)]);

        // let qr_code = QRCode::new(ctx, "children are a little bit stinky sometimes. if we're being honest children are a little bit stinky sometimes. if we're being honest children are a little bit stinky sometimes. if we're being honest children are a little bit stinky sometimes. if we're being honest ");

        let text = Text::new(ctx, "Scan to receive bitcoin.", TextStyle::Secondary, text_size);
        let content = Content::new(Offset::Center, vec![Box::new(text)]); //Box::new(qr_code), Box::new(text)

        let close = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::stack(ctx, Some(close), "Receive bitcoin", None);
        Receive(Page::new(header, content, Some(bumper)))
    } // REMOVE TAB NAV - WE ARE IN A FLOW

    pub fn page(self) -> Page {self.0}
}

pub struct ViewTransaction(Page);