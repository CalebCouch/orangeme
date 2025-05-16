use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;
use chrono::{Local, DateTime, Datelike, Timelike};
use crate::BDKPlugin;
use crate::get_contacts;

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
impl AppPage for BitcoinHome {}

impl BitcoinHome {
    pub fn new(ctx: &mut Context) -> Self {
        let send = Button::primary(ctx, "Send", |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx) );
        let receive = Button::primary(ctx, "Receive", |ctx: &mut Context| BitcoinFlow::Receive.navigate(ctx) );
        let header = Header::home(ctx, "Wallet");
        let bumper = Bumper::double_button(ctx, receive, send);
        let content = Content::new(Offset::Center, vec![Box::new(AmountDisplay::new(ctx, "$0.00", "0.00000000 BTC")) as Box<dyn Drawable>]);
        BitcoinHome(Stack::center(), Page::new(header, content, Some(bumper), false))
    }

    fn update_transactions(&mut self, ctx: &mut Context) {
        let bdk = ctx.get::<BDKPlugin>();
        let btc = bdk.get_balance().to_btc() as f32;
        let transactions = bdk.get_transactions();
        let content = &mut self.1.content();

        if !transactions.is_empty() {
            *content.offset() = Offset::Start;
            let transactions = transactions.into_iter().map(|t| {
                let txid = t.txid.clone();
                ListItem::bitcoin(
                    ctx, 
                    t.is_received, 
                    ((t.amount.to_btc() as f64) * t.price) as f32,
                    &t.datetime.map(|dt| format_date(&dt).to_string()).unwrap_or("-".to_string()),  
                    move |ctx: &mut Context| {
                        ctx.get::<BDKPlugin>().set_transaction(txid);
                        BitcoinFlow::ViewTransaction.navigate(ctx)
                    }
                )
            }).collect();

            let items = &mut content.items();
            let new_group = ListItemGroup::new(transactions);
            match items.get_mut(1).and_then(|item| item.as_any_mut().downcast_mut::<ListItemGroup>()) {
                Some(existing_group) => *existing_group = new_group,
                None => items.push(Box::new(new_group)),
            }
        }
    }
}

impl OnEvent for BitcoinHome {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref() {
            let bdk = ctx.get::<BDKPlugin>();
            let (btc, price) = (bdk.get_balance().to_btc() as f32, bdk.get_price());
            let items = &mut *self.1.content().items();
            let display: &mut AmountDisplay = items[0].as_any_mut().downcast_mut::<AmountDisplay>().unwrap();
            *display.usd() = format!("${:.2}", btc*price);
            *display.btc() = format!("{:.8} BTC", btc);
            self.update_transactions(ctx);
        }
        true
    }
}

#[derive(Debug, Component)]
struct Address(Stack, Page, #[skip] ButtonState);
impl AppPage for Address {}
impl Address {
    fn new(ctx: &mut Context) -> Self {
        let address = ctx.get::<BDKPlugin>().get_recipient_address();
        let continue_btn = Button::disabled(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::Amount.navigate(ctx));
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;

        let address_string = address.map(|add| add.to_string());
        let address_ref: Option<&'static str> = address_string
            .as_ref().map(|s| Box::leak(s.clone().into_boxed_str()) as &'static str);

        let address_input = TextInput::new(ctx, address_ref, None, "Bitcoin address...", None, icon_button);

        let paste = Button::secondary(ctx, Some("paste"), "Paste Clipboard", None, move |ctx: &mut Context| {
            let data = ctx.get_clipboard();
            ctx.trigger_event(SetActiveInput(Box::leak(data.into_boxed_str())))
        });

        let scan_qr = Button::secondary(ctx, Some("qr_code"), "Scan QR Code", None, |ctx: &mut Context| BitcoinFlow::ScanQR.navigate(ctx));
        let contact = Button::secondary(ctx, Some("profile"), "Select Contact", None, |ctx: &mut Context| BitcoinFlow::SelectContact.navigate(ctx));
        let quick_actions = QuickActions::new(vec![paste, scan_qr, contact]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Send bitcoin", None);
        let bumper = Bumper::single_button(ctx, continue_btn);
        let content = Content::new(Offset::Start, vec![Box::new(address_input), Box::new(quick_actions)]);

        Address(Stack::default(), Page::new(header, content, Some(bumper), false), ButtonState::Default)
    }
}

impl OnEvent for Address {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        let bdk = ctx.get::<BDKPlugin>();
        if let Some(TickEvent) = event.downcast_ref() {
            let item = &mut *self.1.content().items()[0];
            let input: &mut TextInput = item.as_any_mut().downcast_mut::<TextInput>().unwrap();

            let input_address = input.get_value();
            let is_valid = bdk.set_recipient_address(input_address.to_string());

            let error = *input.get_error() || input.get_value().is_empty() || !is_valid;
            let item = &mut self.1.bumper().as_mut().unwrap().items()[0];
            let button: &mut Button = item.as_any_mut().downcast_mut::<Button>().unwrap();
            let disabled = *button.status() == ButtonState::Disabled;

            if !disabled { self.2 = *button.status(); }
            if error && !disabled { *button.status() = ButtonState::Disabled; }
            if !error { *button.status() = self.2; }
            button.color(ctx);
        }
        true
    }
}

#[derive(Debug, Component)]
struct ScanQR(Stack, Page);
impl OnEvent for ScanQR {}
impl AppPage for ScanQR {}
impl ScanQR {
    fn new(ctx: &mut Context) -> Self {
        let content = Content::new(Offset::Center, vec![Box::new(QRCodeScanner::new(ctx))]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Scan QR Code", None);

        ScanQR(Stack::default(), Page::new(header, content, None, false))
    }
}

#[derive(Debug, Component)]
struct SelectContact(Stack, Page);
impl OnEvent for SelectContact {}
impl AppPage for SelectContact {}
impl SelectContact {
    fn new(ctx: &mut Context) -> Self {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, None, "Profile name...", None, icon_button);
        let contact_list = ListItemGroup::new(get_contacts(ctx));
        let content = Content::new(Offset::Start, vec![Box::new(searchbar), Box::new(contact_list)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        SelectContact(Stack::default(), Page::new(header, content, None, false))
    }
}

#[derive(Debug, Component)]
struct Amount(Stack, Page, #[skip] ButtonState);
impl AppPage for Amount {}
impl Amount {
    fn new(ctx: &mut Context) -> Self {
        let is_mobile = pelican_ui::config::IS_MOBILE;
        let button = Button::disabled(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::Speed.navigate(ctx));
        let bumper = Bumper::single_button(ctx, button);
        let amount_display = AmountInput::new(ctx);
        let numeric_keypad = NumericKeypad::new(ctx);
        let mut content: Vec<Box<dyn Drawable>> = vec![Box::new(amount_display)];
        is_mobile.then(|| content.push(Box::new(numeric_keypad)));
        let content = Content::new(Offset::Center, content);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| BitcoinFlow::Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Bitcoin amount", None);
        Amount(Stack::default(), Page::new(header, content, Some(bumper), false), ButtonState::Default)
    }
}

impl OnEvent for Amount {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref() {
            let bdk = ctx.get::<BDKPlugin>();
            let price = bdk.get_price();

            let item = &mut *self.1.content().items()[0];
            let amount = item.as_any_mut().downcast_mut::<AmountInput>().unwrap();
            let balance = bdk.get_balance().to_btc() as f32;
            let dust_limit = bdk.get_dust_limit();

            let usd = amount.usd().trim_start_matches('$').parse::<f32>().unwrap();
            *amount.btc() = usd/price;
            amount.set_max((balance+dust_limit)*price);

            if *amount.btc() > dust_limit && *amount.btc() < balance {
                let fee = bdk.get_fees(*amount.btc() as f64).0;
                amount.set_min(fee*price);
            }

            let error = *amount.error();
            let item = &mut self.1.bumper().as_mut().unwrap().items()[0];
            let button: &mut Button = item.as_any_mut().downcast_mut::<Button>().unwrap();
            let disabled = *button.status() == ButtonState::Disabled;

            if !disabled { self.2 = *button.status(); }
            if error && !disabled { *button.status() = ButtonState::Disabled; }
            if !error { *button.status() = self.2; }
            button.color(ctx);
        }
        true
    }
}


#[derive(Debug, Component)]
struct Speed(Stack, Page);
impl OnEvent for Speed {}
impl AppPage for Speed {}
impl Speed {
    fn new(ctx: &mut Context) -> Self {
        let speed_selector = ListItemSelector::new(ctx,
            ("Standard", "Arrives in ~2 hours", Some("$0.18 Bitcoin network fee")),
            ("Priority", "Arrives in ~30 minutes", Some("$0.35 Bitcoin network fee")),
            None, None
        );

        let button = Button::primary(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::Confirm.navigate(ctx));
        let bumper = Bumper::single_button(ctx, button);
        let content = Content::new(Offset::Start, vec![Box::new(speed_selector)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| BitcoinFlow::Amount.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Transaction speed", None);
        Speed(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
struct Confirm(Stack, Page);
impl OnEvent for Confirm {}
impl AppPage for Confirm {}
impl Confirm {
    fn new(ctx: &mut Context) -> Self {
        let button = Button::primary(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::Success.navigate(ctx));
        let bumper = Bumper::single_button(ctx, button);
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
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| BitcoinFlow::Speed.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Confirm send", None);
        Confirm(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
struct Success(Stack, Page);
impl OnEvent for Success {}
impl AppPage for Success {}
impl Success {
    fn new(ctx: &mut Context) -> Self {
        let contact = None; //Some(AvatarContent::Icon("profile", AvatarIconStyle::Secondary));
        let theme = &ctx.get::<PelicanUI>().theme;
        let (color, text_size) = (theme.colors.text.heading, theme.fonts.size.h4);
        let button = Button::close(ctx, "Continue", |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let bumper = Bumper::single_button(ctx, button);

        let (text, splash) = if let Some(c) = contact {
            ("You sent $10.00 to Ella Couch", Box::new(Avatar::new(ctx, c, None, false, 96.0, None)) as Box<dyn Drawable>)
        } else {
            ("You sent $10.00", Box::new(Icon::new(ctx, "bitcoin", color, 96.0)) as Box<dyn Drawable>)
        };

        let text = Text::new(ctx, text, TextStyle::Heading, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![splash, Box::new(text)]);
        let close = IconButton::close(ctx, |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(close), "Send confirmed", None);
        Success(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
struct Receive(Stack, Page);
impl OnEvent for Receive {}
impl AppPage for Receive {}
impl Receive {
    fn new(ctx: &mut Context) -> Self {
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
        let adrs = ctx.get::<BDKPlugin>().get_new_address().to_string();
        let qr_code = QRCode::new(ctx, Box::leak(adrs.clone().into_boxed_str()));
        let text = Text::new(ctx, "Scan to receive bitcoin.", TextStyle::Secondary, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![Box::new(qr_code), Box::new(text)]);

        let button = if pelican_ui::config::IS_MOBILE {
            Button::primary(ctx, "Share", |_ctx: &mut Context| println!("Sharing...")) 
        } else {
            Button::primary(ctx, "Copy Address", move |ctx: &mut Context| ctx.set_clipboard(adrs.clone()) )
        };

        let bumper = Bumper::single_button(ctx, button);
        let close = IconButton::navigation(ctx, "left", |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(close), "Receive bitcoin", None);
        Receive(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
struct ViewTransaction(Stack, Page);
impl OnEvent for ViewTransaction {}
impl AppPage for ViewTransaction {}
impl ViewTransaction {
    fn new(ctx: &mut Context) -> Self {
        let tx = ctx.get::<BDKPlugin>().current_transaction().unwrap();
        let button = Button::close(ctx, "Done", |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let bumper = Bumper::single_button(ctx, button);

        let (address_t, amount_t, title) = match tx.is_received {
            true => ("Received at address", "Amount received", "Received bitcoin"),
            false => ("Send to address", "Amount sent", "Sent bitcoin")
        };

        let address = tx.address.map(|a| {
            let a = a.to_string();
            format!("{}...{}", &a[..7], &a[a.len().saturating_sub(3)..])
        }).unwrap_or("unknown".to_string());

        let (date, time): (String, String) = tx.datetime.map(|dt| {
            (dt.format("%-m/%-d/%y").to_string(), dt.format("%-I:%M %p").to_string())
        }).unwrap_or(("-".to_string(), "-".to_string()));

        let btc_a = tx.amount.to_btc() as f64;
        let usd_a = btc_a * tx.price;
        let usd = format!("${:.2}", usd_a);
        let price = format_thousand(tx.price);
        let btc = static_from(format!("{:.8} BTC", btc_a));
        let usd = static_from(usd);

        let mut details: Vec<(&'static str, &'static str)> = vec![
            ("Date", static_from(date)),
            ("Time", static_from(time)),
            (address_t, static_from(address)),
            (static_from(format!("{} (BTC)", amount_t)), btc),
            ("Bitcoin price", static_from(price)),
            (amount_t, usd),
        ];

        (!tx.is_received).then(|| tx.fee.map(|fee| {
            let fee = (fee.to_btc() as f64)*tx.price;
            details.push(("Network fee", static_from(format!("${:.2}", fee))));
            details.push(("Total", static_from(format_thousand(fee+usd_a))));
        }));

        let details = DataItem::new(ctx, None, "Transaction details", None, None, Some(details), None);
        let amount_display = AmountDisplay::new(ctx, usd, btc);
        let content = Content::new(Offset::Center, vec![Box::new(amount_display), Box::new(details)]); //Box::new(qr_code), Box::new(text)
        let close = IconButton::navigation(ctx, "left", |ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx));
        let header = Header::stack(ctx, Some(close), title, None);
        ViewTransaction(Stack::default(), Page::new(header, content, Some(bumper), false))
    }
}

pub fn format_date(dt: &DateTime<Local>) -> String {
    // let dt = dt.format("%Y-%m-%d %H:%M:%S");
    let today = Local::now().date_naive();
    let date = dt.date_naive();

    match date == today {
        true => {
            let hour = dt.hour();
            let minute = dt.minute();
            let (hour12, am_pm) = match hour == 0 {
                true => (12, "AM"),
                false if hour < 12 => (hour, "AM"),
                false if hour == 12 => (12, "PM"),
                false => (hour - 12, "PM")
            };
            format!("{:02}:{:02} {}", hour12, minute, am_pm)
        },
        false if date == today.pred_opt().unwrap_or(today) => "Yesterday".to_string(),
        false if date.iso_week() == today.iso_week() => format!("{}", dt.format("%A")),
        false if date.year() == today.year() => format!("{}", dt.format("%B %-d")),
        false => format!("{}", dt.format("%m/%d/%y"))
    }
}

pub fn static_from(s: String) -> &'static str {
    Box::leak(s.into_boxed_str())
}

pub fn format_thousand(t: f64) -> String {
    let dollars = t.trunc() as u64;
    let cents = (t.fract() * 100.0).round() as u64;

    let mut dollar_str = dollars.to_string();
    let mut chars = dollar_str.chars().rev().collect::<Vec<_>>();
    for i in (3..chars.len()).step_by(3) {
        chars.insert(i, ',');
    }
    let formatted_dollars = chars.into_iter().rev().collect::<String>();

    format!("${}.{:02}", formatted_dollars, cents)
}