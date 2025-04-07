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
        let receive = Button::primary(ctx, "Receive", |_ctx: &mut Context| println!("Receive..."));
        let bumper = Bumper::new(ctx, vec![Box::new(receive), Box::new(send)]);
        
        let transaction = ListItem::bitcoin(ctx, true, 10.00, "Saturday", |_ctx: &mut Context| println!("View transaction..."));
        let amount_display = AmountDisplay::new(ctx, "$10.00", "0.00001234 BTC", None);
        let content = Content::new(ctx, vec![Box::new(amount_display), Box::new(transaction)]);
        
        let header = Header::home(ctx, "Wallet");
        BitcoinHome(Page::new(ctx, header, content, Some(bumper)))
    }

    pub fn page(self) -> Page {self.0}
}

struct Address(AddressHome, ScanQR, SelectContact);

pub struct AddressHome(Page);

impl AddressHome {
    pub fn new(ctx: &mut Context) -> Self {
        let continue_btn = Button::primary(ctx, "Continue", |_ctx: &mut Context| println!("Continue..."));
        let bumper = Bumper::new(ctx, vec![Box::new(continue_btn)]);
        
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let address_input = TextInput::new(ctx, None, "Bitcoin address...", None, icon_button);

        let paste = Button::secondary(ctx, Some("paste"), "Paste Clipboard", None, |_ctx: &mut Context| println!("Paste..."));
        let scan_qr = Button::secondary(ctx, Some("qr_code"), "Scan QR Code", None, |_ctx: &mut Context| println!("Scan..."));
        let contact = Button::secondary(ctx, Some("profile"), "Select Contact", None, |_ctx: &mut Context| println!("Select Contact..."));
        let quick_actions = QuickActions::new(ctx, vec![paste, scan_qr, contact]); // NEEDS WRAPPING

        let content = Content::new(ctx, vec![Box::new(address_input)]);

        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| println!("Go Back!"));
        let header = Header::stack(ctx, Some(back), "Send bitcoin", None);
        AddressHome(Page::new(ctx, header, content, Some(bumper)))
    } // REMOVE TAB NAV - WE ARE IN A FLOW

    pub fn page(self) -> Page {self.0}
}

struct ScanQR(Page);
struct SelectContact(Page);
struct Amount(Page);
struct Speed(Page);
struct Confirm(Page);
struct Success(Page);

struct Receive(Page);

struct ViewTransaction(Page);