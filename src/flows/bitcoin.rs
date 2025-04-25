use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

#[derive(Debug, Copy, Clone)]
pub enum BitcoinFlow {
    BitcoinHome,
    Receive,
    Address,
    ScanQR,
    SelectContact,
    Amount,
    Speed,
    Confirm,
    Success,
    ViewTransaction,
}

impl AppFlow for BitcoinFlow {
    fn get_page(&self, ctx: &mut Context) -> Box<dyn AppPage> {
        match self {
            BitcoinFlow::BitcoinHome => Box::new(BitcoinHome::new(ctx)) as Box<dyn AppPage>,
            BitcoinFlow::Receive => Box::new(Receive::new(ctx)) as Box<dyn AppPage>,
            BitcoinFlow::Address => Box::new(Address::new(ctx)) as Box<dyn AppPage>,
            BitcoinFlow::ScanQR => Box::new(ScanQR::new(ctx)) as Box<dyn AppPage>,
            BitcoinFlow::SelectContact => Box::new(SelectContact::new(ctx)) as Box<dyn AppPage>,
            BitcoinFlow::Amount => Box::new(Amount::new(ctx)) as Box<dyn AppPage>,
            BitcoinFlow::Speed => Box::new(Speed::new(ctx)) as Box<dyn AppPage>,
            BitcoinFlow::Confirm => Box::new(Confirm::new(ctx)) as Box<dyn AppPage>,
            BitcoinFlow::Success => Box::new(Success::new(ctx)) as Box<dyn AppPage>,
            BitcoinFlow::ViewTransaction => Box::new(ViewTransaction::new(ctx)) as Box<dyn AppPage>,
        }
    }
}

#[derive(Debug, Component)]
pub struct BitcoinHome(Stack, Page);
impl OnEvent for BitcoinHome {}
impl AppPage for BitcoinHome { fn get(&self) -> &Page {&self.1} }

impl BitcoinHome {
    pub fn new(ctx: &mut Context) -> Self {
        let send = Button::primary(ctx, "Send", |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx) );
        let receive = Button::primary(ctx, "Receive", |ctx: &mut Context| BitcoinFlow::Receive.navigate(ctx) );
        let transaction = ListItem::bitcoin(ctx, true, 10.00, "Saturday", |ctx: &mut Context| BitcoinFlow::ViewTransaction.navigate(ctx) );
        let amount_display = AmountDisplay::new(ctx, "$10.00", "0.00001234 BTC", None);
        let header = Header::home(ctx, "Wallet");
        let bumper = Bumper::double_button(receive, send);
        let content = Content::new(Offset::Start, vec![Box::new(amount_display), Box::new(transaction)]);

        BitcoinHome(Stack::center(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
struct Address(Stack, Page);
impl AppPage for Address { fn get(&self) -> &Page {&self.1} }
impl Address {
    fn new(ctx: &mut Context) -> Self {
        let continue_btn = Button::disabled(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::Amount.navigate(ctx));
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let address_input = TextInput::new(ctx, None, "Bitcoin address...", None, icon_button);
        let paste = Button::secondary(ctx, Some("paste"), "Paste Clipboard", None, |_ctx: &mut Context| {});
        let scan_qr = Button::secondary(ctx, Some("qr_code"), "Scan QR Code", None, |ctx: &mut Context| BitcoinFlow::ScanQR.navigate(ctx));
        let contact = Button::secondary(ctx, Some("profile"), "Select Contact", None, |ctx: &mut Context| BitcoinFlow::SelectContact.navigate(ctx));
        let quick_actions = QuickActions::new(vec![paste, scan_qr, contact]);
        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Send bitcoin", None);
        let bumper = Bumper::single_button(continue_btn);
        let content = Content::new(Offset::Start, vec![Box::new(address_input), Box::new(quick_actions)]);

        Address(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

impl OnEvent for Address {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref() {
            let item = &mut *self.1.content().items()[0];
            let input: &mut TextInput = item.as_any_mut().downcast_mut::<TextInput>().unwrap();
            let disable = (*input.get_error() || input.get_value().is_empty());

            let item = &mut self.1.bumper().as_mut().unwrap().items()[0];
            let button: &mut Button = item.as_any_mut().downcast_mut::<Button>().unwrap();
            *button.status() = if disable { ButtonState::Disabled } else { ButtonState::Default };
            button.color(ctx);
        }
        true
    }
}

#[derive(Debug, Component)]
struct ScanQR(Stack, Page);
impl OnEvent for ScanQR {}
impl AppPage for ScanQR { fn get(&self) -> &Page {&self.1} }
impl ScanQR {
    fn new(ctx: &mut Context) -> Self {
        let content = Content::new(Offset::Center, vec![Box::new(QRCodeScanner::new(ctx))]);
        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Scan QR Code", None);

        ScanQR(Stack::default(), Page::new(header, content, None, false))
    }
}

#[derive(Debug, Component)]
struct SelectContact(Stack, Page);
impl OnEvent for SelectContact {}
impl AppPage for SelectContact { fn get(&self) -> &Page {&self.1} }
impl SelectContact {
    fn new(ctx: &mut Context) -> Self {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, "Profile name...", None, icon_button);
        let contact_list = ListItemGroup::new(get_contacts(ctx));
        let content = Content::new(Offset::Start, vec![Box::new(searchbar), Box::new(contact_list)]);
        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        SelectContact(Stack::default(), Page::new(header, content, None, false))
    }
}

#[derive(Debug, Component)]
struct Amount(Stack, Page);
impl AppPage for Amount { fn get(&self) -> &Page {&self.1} }
impl Amount {
    fn new(ctx: &mut Context) -> Self {
        let is_mobile = pelican_ui::config::IS_MOBILE;
        let bumper = Bumper::single_button(Button::disabled(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::Speed.navigate(ctx)));
        let amount_display = AmountInput::new(ctx);
        let numeric_keypad = NumericKeypad::new(ctx);
        let mut content: Vec<Box<dyn Drawable>> = vec![Box::new(amount_display)];
        is_mobile.then(|| content.push(Box::new(numeric_keypad)));
        let content = Content::new(Offset::Center, content);
        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Bitcoin amount", None);
        Amount(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

impl OnEvent for Amount {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref() {
            let item = &mut *self.1.content().items()[0];
            let disable = *item.as_any_mut().downcast_mut::<AmountInput>().unwrap().has_error();

            let item = &mut self.1.bumper().as_mut().unwrap().items()[0];
            let button: &mut Button = item.as_any_mut().downcast_mut::<Button>().unwrap();
            *button.status() = if disable { ButtonState::Disabled } else { ButtonState::Default };
            button.color(ctx);
        }
        true
    }
}


#[derive(Debug, Component)]
struct Speed(Stack, Page);
impl OnEvent for Speed {}
impl AppPage for Speed { fn get(&self) -> &Page {&self.1} }
impl Speed {
    fn new(ctx: &mut Context) -> Self {
        let speed_selector = ListItemSelector::new(ctx,
            ("Standard", "Arrives in ~2 hours", "$0.18 Bitcoin network fee"),
            ("Priority", "Arrives in ~30 minutes", "$0.35 Bitcoin network fee"),
            None, None
        );

        let bumper = Bumper::single_button(Button::primary(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::Confirm.navigate(ctx)));
        let content = Content::new(Offset::Start, vec![Box::new(speed_selector)]);
        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinFlow::Amount.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Transaction speed", None);
        Speed(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
struct Confirm(Stack, Page);
impl OnEvent for Confirm {}
impl AppPage for Confirm { fn get(&self) -> &Page {&self.1} }
impl Confirm {
    fn new(ctx: &mut Context) -> Self {
        let bumper = Bumper::single_button(Button::primary(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::Success.navigate(ctx)));
        let edit_amount = Button::secondary(ctx, Some("edit"), "Edit Amount", None, |ctx: &mut Context| BitcoinFlow::Amount.navigate(ctx));
        let edit_speed = Button::secondary(ctx, Some("edit"), "Edit Speed", None, |ctx: &mut Context| BitcoinFlow::Speed.navigate(ctx));
        let edit_address = Button::secondary(ctx, Some("edit"), "Edit Address", None, |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx));

        let confirm_amount = DataItem::new(ctx, None, "Confirm amount", None, None,
            Some(vec![
                ("Amount sent (BTC)", "0.00001234 BTC"),
                ("Send speed", "Standard (2 hours)"),
                ("Amount sent", "$10.00"),
                ("Network fee", "$0.18"),
                ("Total", "$10.18")
            ]), Some(vec![edit_amount, edit_speed])
        );

        let confirm_address = DataItem::new(ctx, None, "Confirm address",
            Some("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"),
            Some("Bitcoin sent to the wrong address can never be recovered."),
            None, Some(vec![edit_address])
        );

        let content = Content::new(Offset::Start, vec![Box::new(confirm_address), Box::new(confirm_amount)]);
        let back = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinFlow::Speed.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Confirm send", None);
        Confirm(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
struct Success(Stack, Page);
impl OnEvent for Success {}
impl AppPage for Success { fn get(&self) -> &Page {&self.1} }
impl Success {
    fn new(ctx: &mut Context) -> Self {
        let contact = None; //Some(AvatarContent::Icon("profile", AvatarIconStyle::Secondary));
        let theme = &ctx.get::<PelicanUI>().theme;
        let (color, text_size) = (theme.colors.text.heading, theme.fonts.size.h4);
        let bumper = Bumper::single_button(Button::close(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx)));

        let (text, splash) = if let Some(c) = contact {
            ("You sent $10.00 to Ella Couch", Box::new(Avatar::new(ctx, c, None, false, 96.0)) as Box<dyn Drawable>)
        } else {
            ("You sent $10.00", Box::new(Icon::new(ctx, "bitcoin", color, 96.0)) as Box<dyn Drawable>)
        };

        let text = Text::new(ctx, text, TextStyle::Heading, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![splash, Box::new(text)]);
        let close = IconButton::close(ctx, None, |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(close), "Send confirmed", None);
        Success(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
struct Receive(Stack, Page);
impl OnEvent for Receive {}
impl AppPage for Receive { fn get(&self) -> &Page {&self.1} }
impl Receive {
    fn new(ctx: &mut Context) -> Self {
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
        let address = "3du7i,d57id7d7oid7d5i7odc'clci05d,0id,0i";
        let bumper = Bumper::single_button(Button::primary(ctx, "Share", |ctx: &mut Context| println!("Sharing...")));
        let qr_code = QRCode::new(ctx, address);
        let text = Text::new(ctx, "Scan to receive bitcoin.", TextStyle::Secondary, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![Box::new(qr_code), Box::new(text)]); //Box::new(qr_code), Box::new(text)
        let close = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(close), "Receive bitcoin", None);
        Receive(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
struct ViewTransaction(Stack, Page);
impl OnEvent for ViewTransaction {}
impl AppPage for ViewTransaction { fn get(&self) -> &Page {&self.1} }
impl ViewTransaction {
    fn new(ctx: &mut Context) -> Self {
        let is_received = false;
        let done_btn = Button::close(ctx, "Done", |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
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
        let close = IconButton::navigation(ctx, "left", None, |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(close), title, None);
        ViewTransaction(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

pub fn get_contacts(ctx: &mut Context) -> Vec<ListItem> {
    vec![
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Anne Eave", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context|  BitcoinFlow::Address.navigate(ctx)),
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Bob David", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context|  BitcoinFlow::Address.navigate(ctx)),
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Charlie Charles", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx)),
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Danielle Briebs", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context|  BitcoinFlow::Address.navigate(ctx)),
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Ethan A.", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context|  BitcoinFlow::Address.navigate(ctx))
    ]
}