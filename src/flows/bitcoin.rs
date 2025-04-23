use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

#[derive(Debug, Clone, Copy)]
pub struct BitcoinHome;
impl PageName for BitcoinHome {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let p = _BitcoinHome::new(ctx);
        let content = Content::new(Offset::Start, vec![Box::new(p.1), Box::new(p.2)]);
        let bumper = Bumper::new(vec![Box::new(p.3), Box::new(p.4)]);
        Page::new(p.0, content, Some(bumper), p.5)
    }
}

#[derive(Debug)]
struct _BitcoinHome(Header, AmountDisplay, ListItem, Button, Button, bool);
impl _BitcoinHome {
    fn new(ctx: &mut Context) -> Self {
        let send = Button::primary(ctx, "Send", |ctx: &mut Context| Address.navigate(ctx));
        let receive = Button::primary(ctx, "Receive", |ctx: &mut Context| Receive.navigate(ctx));
        let transaction = ListItem::bitcoin(ctx, true, 10.00, "Saturday", |ctx: &mut Context|  ViewTransaction.navigate(ctx));
        let amount_display = AmountDisplay::new(ctx, "$10.00", "0.00001234 BTC", None);
        let header = Header::home(ctx, "Wallet");
        _BitcoinHome(header, /* Optional Alert, */ amount_display, transaction, receive, send, true)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Address;

impl PageName for Address {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let p = _Address::new(ctx);
        let content = Content::new(Offset::Start, vec![Box::new(p.2), Box::new(p.3)]);
        let bumper = Bumper::new(vec![Box::new(p.4)]);
        Page::new(p.1, content, Some(bumper), p.5)
    }
}

#[derive(Debug)]
struct _Address(Header, TextInput, QuickActions, Button, #[skip] bool);

impl _Address {
    fn new(ctx: &mut Context) -> Self {
        let continue_btn = Button::disabled(ctx, "Continue", |ctx: &mut Context| Amount.navigate(ctx));
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let address_input = TextInput::new(ctx, None, "Bitcoin address...", None, icon_button);

        let paste = Button::secondary(ctx, Some("paste"), "Paste Clipboard", None, |_ctx: &mut Context| {
            println!("Paste... "); // read_clipboard().unwrap_or("Could not read clipboard.".to_string())
        });

        let scan_qr = Button::secondary(ctx, Some("qr_code"), "Scan QR Code", None, |ctx: &mut Context| ScanQR.navigate(ctx));
        let contact = Button::secondary(ctx, Some("profile"), "Select Contact", None, |ctx: &mut Context| SelectContact.navigate(ctx));
        let quick_actions = QuickActions::new(vec![paste, scan_qr, contact]);

        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Send bitcoin", None);
        _Address(header, address_input, quick_actions, continue_btn, false)
    }
}

impl OnEvent for _Address {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref() {
            println!(" on tick");
            *self.4.status() = if *self.2.get_error() || self.2.get_value().is_empty() {ButtonState::Disabled} else {ButtonState::Default};
            self.4.color(ctx);
        }
        true
    }
}

#[derive(Debug, Clone, Copy)]
pub struct ScanQR;

impl PageName for ScanQR {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let content = Content::new(Offset::Center, vec![Box::new(QRCodeScanner::new(ctx))]);
        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Scan QR Code", None);
        Page::new(header, content, None, false)
    } 
}

#[derive(Debug, Clone, Copy)]
pub struct SelectContact;

impl PageName for SelectContact {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, "Profile name...", None, icon_button);

        let contacts = vec![
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Anne Eave", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context|  Address.navigate(ctx)),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Bob David", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context|  Address.navigate(ctx)),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Charlie Charles", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context|  Address.navigate(ctx)),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Danielle Briebs", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context|  Address.navigate(ctx)),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Ethan A.", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context|  Address.navigate(ctx))
        ];

        let contact_list = ListItemGroup::new(contacts);

        let content = Content::new(Offset::Start, vec![Box::new(searchbar), Box::new(contact_list)]);

        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        Page::new(header, content, None, false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Amount;

impl PageName for Amount {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let is_mobile = pelican_ui::config::IS_MOBILE;
        let id = ElementID::new();
        let continue_btn = Button::disabled(ctx, "Continue", |ctx: &mut Context| Speed.navigate(ctx));
        let bumper = Bumper::new(vec![Box::new(continue_btn)]);
        
        let amount_display = AmountInput::new(ctx, Some(vec![id]));
        let numeric_keypad = NumericKeypad::new(ctx);

        let mut content: Vec<Box<dyn Drawable>> = vec![Box::new(amount_display)];
        is_mobile.then(|| content.push(Box::new(numeric_keypad)));
        let content = Content::new(Offset::Center, content);

        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Bitcoin amount", None);
        Page::new(header, content, Some(bumper), false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Speed;

impl PageName for Speed {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let continue_btn = Button::primary(ctx, "Continue", |ctx: &mut Context| Confirm.navigate(ctx));
        let bumper = Bumper::new(vec![Box::new(continue_btn)]);
        
        let speed_selector = ListItemSelector::new(ctx,
            ("Standard", "Arrives in ~2 hours", "$0.18 Bitcoin network fee"),
            ("Priority", "Arrives in ~30 minutes", "$0.35 Bitcoin network fee"),
            None, None
        );

        let content = Content::new(Offset::Start, vec![Box::new(speed_selector)]);

        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| Amount.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Transaction speed", None);
        Page::new(header, content, Some(bumper), false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Confirm;

impl PageName for Confirm {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let continue_btn = Button::primary(ctx, "Continue", |ctx: &mut Context| Success.navigate(ctx));
        let bumper = Bumper::new(vec![Box::new(continue_btn)]);

        let edit_amount = Button::secondary(ctx, Some("edit"), "Edit Amount", None, |ctx: &mut Context| Amount.navigate(ctx));
        let edit_speed = Button::secondary(ctx, Some("edit"), "Edit Speed", None, |ctx: &mut Context| Speed.navigate(ctx));
        let edit_address = Button::secondary(ctx, Some("edit"), "Edit Address", None, |ctx: &mut Context| Address.navigate(ctx));

        let confirm_amount = DataItem::new(ctx,
            None, //Some("2"),
            "Confirm amount",
            None,
            None,
            Some(vec![
                ("Amount sent (BTC)", "0.00001234 BTC"),
                ("Send speed", "Standard (2 hours)"),
                ("Amount sent", "$10.00"),
                ("Network fee", "$0.18"),
                ("Total", "$10.18")
            ]),
            Some(vec![edit_amount, edit_speed])
        );

        let confirm_address = DataItem::new(ctx,
            None, // Some("1"),
            "Confirm address",
            Some("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"),
            Some("Bitcoin sent to the wrong address can never be recovered."),
            None,
            Some(vec![edit_address])
        );

        let content = Content::new(Offset::Start, vec![Box::new(confirm_address), Box::new(confirm_amount)]);

        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| Speed.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Confirm send", None);
        Page::new(header, content, Some(bumper), false)
    } 
}

#[derive(Debug, Clone, Copy)]
pub struct Success;

impl PageName for Success {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let contact = None; //Some(AvatarContent::Icon("profile", AvatarIconStyle::Secondary));

        let theme = &ctx.get::<PelicanUI>().theme;
        let (color, text_size) = (theme.colors.text.heading, theme.fonts.size.h4);

        let continue_btn = Button::close(ctx, "Continue", |ctx: &mut Context| BitcoinHome.navigate(ctx));
        let bumper = Bumper::new(vec![Box::new(continue_btn)]);

        let (text, splash) = if let Some(c) = contact {
            ("You sent $10.00 to Ella Couch", Box::new(Avatar::new(ctx, c, None, false, 96.0)) as Box<dyn Drawable>)
        } else {
            ("You sent $10.00", Box::new(Icon::new(ctx, "bitcoin", color, 96.0)) as Box<dyn Drawable>)
        };

        let text = Text::new(ctx, text, TextStyle::Heading, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![splash, Box::new(text)]);

        let close = IconButton::close(ctx, None, |ctx: &mut Context| BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(close), "Send confirmed", None);
        Page::new(header, content, Some(bumper), false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Receive;

impl PageName for Receive {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
        let share_btn = Button::primary(ctx, "Share", |ctx: &mut Context| println!("Sharing..."));
        let bumper = Bumper::new(vec![Box::new(share_btn)]);

        let qr_code = QRCode::new(ctx, "children are a little bit stinky sometimes. if bit stinky sometimes. if we're being honest i hate caleb he really smells like a small child that you found at apark and it has a full diaper and no one is changing the child and you hate the kid but he follows you everywhere. he pooped on the slide");

        let text = Text::new(ctx, "Scan to receive bitcoin.", TextStyle::Secondary, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![Box::new(qr_code), Box::new(text)]); //Box::new(qr_code), Box::new(text)

        let close = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(close), "Receive bitcoin", None);
        Page::new(header, content, Some(bumper), false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct ViewTransaction;

impl PageName for ViewTransaction {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let is_received = false;

        let done_btn = Button::close(ctx, "Done", |ctx: &mut Context| BitcoinHome.navigate(ctx));
        let bumper = Bumper::new(vec![Box::new(done_btn)]);

        let (address, amount, title) = if is_received {
            ("Received at address", "Amount received", "Received bitcoin")
        } else {("Send to address", "Amount sent", "Sent bitcoin")};
        let btc = format!("{} (BTC)", amount);

        let mut details = vec![
            ("Date", "11/2/25"),
            ("Time", "11:27 PM"),
            (address, "7ElaxC8...x1l"),
            (Box::leak(btc.into_boxed_str()), "0.00001234 BTC"),
            ("Bitcoin price", "$85,989.66"),
            (amount, "$10.00"),
        ];

        (!is_received).then(|| details.push(("Network fee", "$0.18")));
        (!is_received).then(|| details.push(("Total", "$10.18")));

        let details = DataItem::new(ctx, None, "Transaction details", None, None, Some(details), None);
        let amount_display = AmountDisplay::new(ctx, "$10.00", "0.00001234 BTC", None);
        
        let content = Content::new(Offset::Center, vec![Box::new(amount_display), Box::new(details)]); //Box::new(qr_code), Box::new(text)

        let close = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(close), title, None);
        Page::new(header, content, Some(bumper), false)
    }
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