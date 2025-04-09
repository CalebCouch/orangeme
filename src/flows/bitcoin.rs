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

pub struct Address(AddressHome, ScanQR, SelectContact);

pub struct AddressHome(Page);

impl AddressHome {
    pub fn new(ctx: &mut Context) -> Self {
        let continue_btn = Button::primary(ctx, "Continue", |_ctx: &mut Context| println!("Continue..."));
        let bumper = Bumper::new(vec![Box::new(continue_btn)]);
        
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let address_input = TextInput::new(ctx, None, "Bitcoin address...", None, icon_button);

        let paste = Button::secondary(ctx, Some("paste"), "Paste Clipboard", None, |_ctx: &mut Context| println!("Paste... {}", crate::clipboard()));
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
pub struct Speed(Page);
pub struct Confirm(Page);
pub struct Success(Page);

pub struct Receive(Page);

pub struct ViewTransaction(Page);