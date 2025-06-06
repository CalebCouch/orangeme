use pelican_ui::events::{Event, OnEvent, TickEvent};
use pelican_ui::drawable::{Drawable, Component, Align};
use pelican_ui::layout::{Area, SizeRequest, Layout};
use pelican_ui::{Context, Component};

use bitcoin::{
    components::AmountDisplay,
    components::AmountInput,
    components::NumericKeypad,
    components::DataItemBitcoin,
    components::QRCodeScanner,
    components::QRCode,
    events::QRCodeScannedEvent,
    format_usd,
    format_nano_btc,
    NANS
};

use pelican_ui_std::{
    AppPage, Stack, Page,
    Header, IconButton,
    Avatar, AvatarContent,
    AvatarIconStyle, Icon, Text,
    TextStyle, Content,
    Offset, ListItem,
    Button, ButtonState,
    Bumper, TextInput,
    SetActiveInput, IS_MOBILE,
    QuickActions, ListItemSelector,
    NavigateEvent, DataItem,
    Timestamp, ListItemGroup,
};

// use crate::bdk::{BDKPlugin, SendAddress, SendAmount, SendFee, CurrentTransaction};
// use crate::bdk::parse_btc_uri;
// use crate::MSGPlugin;

#[derive(Debug, Component, AppPage)]
pub struct BitcoinHome(Stack, Page);

impl BitcoinHome {
    pub fn new(ctx: &mut Context) -> (Self, bool) {
        let send = Button::primary(ctx, "Send", |ctx: &mut Context| {
            let address = Address::new(ctx);
            ctx.trigger_event(NavigateEvent::new(address))
        });
        let receive = Button::primary(ctx, "Receive", |ctx: &mut Context| {
            let receive = Receive::new(ctx);
            ctx.trigger_event(NavigateEvent::new(receive))
        });
        let header = Header::home(ctx, "Wallet");
        let bumper = Bumper::double_button(ctx, receive, send);
        let content = Content::new(Offset::Center, vec![Box::new(AmountDisplay::new(ctx, "$0.00", "0 nb")) as Box<dyn Drawable>]);
        (BitcoinHome(Stack::center(), Page::new(header, content, Some(bumper))), true)
    }

    fn update_transactions(&mut self, ctx: &mut Context) {
        // let bdk = ctx.get::<BDKPlugin>();
        // let transactions = bdk.get_transactions();
        // let content = &mut self.1.content();

        // if !transactions.is_empty() {
        //     *content.offset() = Offset::Start;
        //     let transactions = transactions.into_iter().map(|t| {
        //         let txid = t.txid;
        //         match t.datetime {
        //             Some(stamp) => ListItem::bitcoin(
        //                 ctx, t.is_received, t.amount.to_btc(), t.price, Timestamp::new(stamp),
        //                 move |ctx: &mut Context| {
        //                     // let tx = ctx.get::<BDKPlugin>().find_transaction(txid).unwrap();
        //                     // ctx.state().set(&CurrentTransaction::new(tx));
        //                     // ViewTransaction::navigate(ctx);
        //                 }
        //             ),
        //             None => ListItem::bitcoin_sending(
        //                 ctx, t.amount.to_btc(), t.price, 
        //                 move |ctx: &mut Context| {
        //                     // let tx = ctx.get::<BDKPlugin>().find_transaction(txid).unwrap();
        //                     // ctx.state().set(&CurrentTransaction::new(tx));
        //                     // ViewTransaction::navigate(ctx)
        //                 }
        //             )
        //         }
        //     }).collect();

        //     let items = &mut content.items();
        //     let new_group = ListItemGroup::new(transactions);
        //     match items.get_mut(1).and_then(|item| item.as_any_mut().downcast_mut::<ListItemGroup>()) {
        //         Some(existing_group) => *existing_group = new_group,
        //         None => items.push(Box::new(new_group)),
        //     }
        // }
    }
}

impl OnEvent for BitcoinHome {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            // let bdk = ctx.get::<BDKPlugin>();
            let (btc, price) = (0.0, 0.0); //(bdk.get_balance().to_btc(), bdk.get_price());
            let items = &mut *self.1.content().items();
            let display: &mut AmountDisplay = items[0].as_any_mut().downcast_mut::<AmountDisplay>().unwrap();
            *display.usd() = format_usd(btc*price as f64).to_string();
            *display.btc() = format_nano_btc(btc*NANS).to_string();
            self.update_transactions(ctx);
        }
        true
    }
}

#[derive(Debug, Component, AppPage)]
pub struct Address(Stack, Page, #[skip] ButtonState);

impl Address {
    fn new(ctx: &mut Context) -> (Self, bool) {
        let button = Button::disabled(ctx, "Continue", |ctx: &mut Context| {
            let page = Amount::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;

        // let address = None; // ctx.state().get::<SendAddress>(); // optional string
        let address_ref: Option<&str> = None; // address.get().as_ref().map(|x| x.as_str());
        let address_input = TextInput::new(ctx, address_ref, None, "Bitcoin address...", None, icon_button);

        let paste = Button::secondary(ctx, Some("paste"), "Paste Clipboard", None, move |ctx: &mut Context| {
            // let data = ctx.get_clipboard();
            // ctx.trigger_event(SetActiveInput(data))
        });

        let scan_qr = Button::secondary(ctx, Some("qr_code"), "Scan QR Code", None, |ctx: &mut Context| {
            let page = ScanQR::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let contact = Button::secondary(ctx, Some("profile"), "Select Contact", None, |ctx: &mut Context|{
            let page = SelectContact::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let quick_actions = QuickActions::new(vec![paste, scan_qr, contact]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = BitcoinHome::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let header = Header::stack(ctx, Some(back), "Send bitcoin", None);
        let bumper = Bumper::single_button(ctx, button);
        let content = Content::new(Offset::Start, vec![Box::new(address_input), Box::new(quick_actions)]);

       ( Address(Stack::default(), Page::new(header, content, Some(bumper)), ButtonState::Default), false)
    }
}

impl OnEvent for Address {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            let input = &mut *self.1.content().find::<TextInput>().unwrap();
            let input_address = input.value().clone();

            if !input_address.is_empty() {
                // let (address, amount) = ("", None);// parse_btc_uri(input_address);
                *input.value() = "address".to_string();
                // let address = SendAddress::new(address.to_string());
                // if let Some(b) = amount { ctx.state().set(&SendAmount::new(b)) }

                // match address.is_valid() {
                //     true => *input.error() = false,
                //     false => input.set_error(ctx, "Address is not valid.")
                // }

                // ctx.state().set(&address);
            }

            let error = *input.error() || input_address.is_empty();
            let button = self.1.bumper().as_mut().unwrap().find::<Button>().unwrap();
            let disabled = *button.status() == ButtonState::Disabled;

            if !disabled { self.2 = *button.status(); }
            if error && !disabled { *button.status() = ButtonState::Disabled; }
            if !error { *button.status() = self.2; }
            button.color(ctx);
        }
        true
    }
}

#[derive(Debug, Component, AppPage)]
pub struct ScanQR(Stack, Page);

impl ScanQR {
    fn new(ctx: &mut Context) -> (Self, bool) {
        // let content = Content::new(Offset::Center, vec![Box::new(QRCodeScanner::new(ctx))]);
        let content = Content::new(Offset::Center, vec![Box::new(QRCodeScanner::new(ctx))]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = Address::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page));
        });
        let header = Header::stack(ctx, Some(back), "Scan QR Code", None);

        (ScanQR(Stack::default(), Page::new(header, content, None)), false)
    }
}

impl OnEvent for ScanQR {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(QRCodeScannedEvent(data)) = event.downcast_ref::<QRCodeScannedEvent>() {
            // ctx.state().set(&SendAddress::new(data.to_string()));
            let page = Address::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page));
        }
        true
    }
}

#[derive(Debug, Component, AppPage)]
pub struct SelectContact(Stack, Page);
impl OnEvent for SelectContact {}

impl SelectContact {
    fn new(ctx: &mut Context) -> (Self, bool) {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, None, "Profile name...", None, icon_button);
        // let profiles = vec![]; //ctx.get::<MSGPlugin>().get_profiles();
        let contacts: Vec<ListItem> = vec![]; //profiles.iter().map(|p| {
        //     let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
        //     ListItem::recipient(ctx, avatar, p.clone())
        // }).collect::<Vec<ListItem>>();
        let contact_list = ListItemGroup::new(contacts);
        let content = Content::new(Offset::Start, vec![Box::new(searchbar), Box::new(contact_list)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = Address::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page));
        });
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        (SelectContact(Stack::default(), Page::new(header, content, None)), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct Amount(Stack, Page, #[skip] ButtonState);

impl Amount {
    pub fn new(ctx: &mut Context) -> (Self, bool) {

        let price = 0.0; //ctx.get::<BDKPlugin>().get_price();
        // let amount = ctx.state().get::<SendAmount>();
        let btc = 0.0; //amount.get().to_btc().to_string().parse::<f64>().unwrap();
        let nano_btc = btc*NANS;
        let usd = 0.0; // btc*price as f64;

        let mut amount_display = AmountInput::new(ctx, Some((usd, &format_nano_btc(nano_btc))));
        *amount_display.price() = price;
        // let bdk = ctx.get::<BDKPlugin>();
        let balance = 0.0; // bdk.get_balance().to_btc() as f32;
        let dust_limit = 0.0; //bdk.get_dust_limit();

        amount_display.set_max((balance-dust_limit)*price);

        // ctx.state().set(&SendAmount::new(*amount_display.btc() as f64));

        let address = ""; // ctx.state().get::<SendAddress>().as_address();
        // let amount = ctx.state().get::<SendAmount>();

        if *amount_display.btc() > dust_limit {
            let (standard, priority) = (0.0, 0.0); //ctx.get::<BDKPlugin>().estimate_fees(*bdk::Amount::from_btc(0.0), address);
            // let standard = standard.to_btc().to_string().parse::<f32>().unwrap();
            // let priority = priority.to_btc().to_string().parse::<f32>().unwrap();
            amount_display.set_max(((balance-dust_limit)-priority)*price);
            amount_display.set_min(standard*price);
        }

        amount_display.validate(ctx);

        let on_click = |ctx: &mut Context| {
            let page = Speed::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        };

        let button = match *amount_display.error() {
            true => Button::disabled(ctx, "Continue", on_click),
            false => Button::primary(ctx, "Continue", on_click)
        };

        let numeric_keypad = NumericKeypad::new(ctx);
        let mut content: Vec<Box<dyn Drawable>> = vec![Box::new(amount_display)];
        IS_MOBILE.then(|| content.push(Box::new(numeric_keypad)));
        let content = Content::new(Offset::Center, content);

        let bumper = Bumper::single_button(ctx, button);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = Address::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page));
        });
        let header = Header::stack(ctx, Some(back), "Bitcoin amount", None);
        (Amount(Stack::default(), Page::new(header, content, Some(bumper)), ButtonState::Default), false)
    }
}

impl OnEvent for Amount {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            let amount = &mut *self.1.content().find::<AmountInput>().unwrap();
            // ctx.state().set(&SendAmount::new(*amount.btc() as f64));
            let error = *amount.error();
            let button = &mut self.1.bumper().as_mut().unwrap().find::<Button>().unwrap();
            let disabled = *button.status() == ButtonState::Disabled;

            if !disabled { self.2 = *button.status(); }
            if error && !disabled { *button.status() = ButtonState::Disabled; }
            if !error { *button.status() = self.2; }
            button.color(ctx);
        }
        true
    }
}


#[derive(Debug, Component, AppPage)]
pub struct Speed(Stack, Page);

impl Speed {
    fn new(ctx: &mut Context) -> (Self, bool) {
        let price = 0.0; // ctx.get::<BDKPlugin>().get_price();
        let address = ""; //ctx.state().get::<SendAddress>().as_address();
        // let btc = ctx.state().get::<SendAmount>();

        //*amount.get()
        let (standard, priority) = (0.0, 0.0); //ctx.get::<BDKPlugin>().estimate_fees(bdk::Amount::from_btc(0.0), address);
        // ctx.state().set(&SendFee::new(standard, priority, false));

        // let standard = standard.to_btc().to_string().parse::<f32>().unwrap() * price;
        // let priority = priority.to_btc().to_string().parse::<f32>().unwrap() * price;

        let speed_selector = ListItemSelector::new(ctx,
            ("Standard", "Arrives in ~2 hours", Some(&format!("${:.2} Bitcoin network fee", standard))),
            ("Priority", "Arrives in ~30 minutes", Some(&format!("${:.2} Bitcoin network fee", priority))),
            None, None
        );

        let button = Button::primary(ctx, "Continue", |ctx: &mut Context| {
            let page = Confirm::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let bumper = Bumper::single_button(ctx, button);
        let content = Content::new(Offset::Start, vec![Box::new(speed_selector)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = Amount::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let header = Header::stack(ctx, Some(back), "Transaction speed", None);
        (Speed(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}

impl OnEvent for Speed {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            let selector = self.1.content().find::<ListItemSelector>().unwrap();
            // let current = ctx.state().get::<SendFee>();
            // match selector.index() {
            //     Some(0) => ctx.state().set(&SendFee::new(*current.standard_fee(), *current.priority_fee(), false)),
            //     Some(1) => ctx.state().set(&SendFee::new(*current.standard_fee(), *current.priority_fee(), true)),
            //     _ => {}
            // }
        }
        true
    }
}

#[derive(Debug, Component, AppPage)]
pub struct Confirm(Stack, Page);
impl OnEvent for Confirm {}

impl Confirm {
    fn new(ctx: &mut Context) -> (Self, bool) {
        let price = 0.0; //ctx.get::<BDKPlugin>().get_price() as f64;
        // let address = ctx.state().get::<SendAddress>();
        // let amount = ctx.state().get::<SendAmount>();

        // let mut send_fee = ctx.state().get::<SendFee>();
        let fee = 0.0; // send_fee.get_fee().to_btc().to_string().parse::<f64>().unwrap() * price;
        let btc = 0.0; // amount.get().to_btc().to_string().parse::<f64>().unwrap();

        let confirm_address = DataItemBitcoin::confirm_address(
            ctx, "", 
            /*&address.get().as_ref().unwrap().to_string(), */ 
            |ctx: &mut Context| {
                let page = Address::new(ctx);
                ctx.trigger_event(NavigateEvent::new(page))
            }
        );

        let confirm_amount = DataItemBitcoin::confirm_amount(
            ctx, btc, price, fee, false, // *send_fee.priority(), 
            |ctx: &mut Context| {
                let page = Speed::new(ctx);
                ctx.trigger_event(NavigateEvent::new(page));
            },
            |ctx: &mut Context| {
                let page = Address::new(ctx);
                ctx.trigger_event(NavigateEvent::new(page));
            },
        );

        let button = Button::primary(ctx, "Confirm & Send", |ctx: &mut Context| {
            // let address = ctx.state().get::<SendAddress>().as_address();
            // let amount = ctx.state().get::<SendAmount>();
            // let fee_rate = ctx.state().get::<SendFee>().as_rate();
            // ctx.get::<BDKPlugin>().broadcast_transaction(address, *amount.get(), fee_rate);
            let page = Success::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });
        
        let bumper = Bumper::single_button(ctx, button);
        let content = Content::new(Offset::Start, vec![Box::new(confirm_address), Box::new(confirm_amount)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = Speed::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });
        let header = Header::stack(ctx, Some(back), "Confirm send", None);
        (Confirm(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct Success(Stack, Page);
impl OnEvent for Success {}

impl Success {
    fn new(ctx: &mut Context) -> (Self, bool) {
        let contact = None; //Some(AvatarContent::Icon("profile", AvatarIconStyle::Secondary)); // Don't forget arrow when sending to contact.
        let theme = &ctx.theme;
        let (color, text_size) = (theme.colors.text.heading, theme.fonts.size.h4);

        let go_home = |ctx: &mut Context| {
            let page = BitcoinHome::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        };

        let button = Button::close(ctx, "Continue", go_home);
        let bumper = Bumper::single_button(ctx, button);

        let (text, splash) = if let Some(c) = contact {
            ("You sent $10.00 to Ella Couch", Box::new(Avatar::new(ctx, c, None, false, 96.0, None)) as Box<dyn Drawable>)
        } else {
            ("You sent $10.00", Box::new(Icon::new(ctx, "bitcoin", color, 96.0)) as Box<dyn Drawable>)
        };

        let text = Text::new(ctx, text, TextStyle::Heading, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![splash, Box::new(text)]);
        let close = IconButton::close(ctx, go_home);
        let header = Header::stack(ctx, Some(close), "Send confirmed", None);
        (Success(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct Receive(Stack, Page);
impl OnEvent for Receive {}

impl Receive {
    fn new(ctx: &mut Context) -> (Self, bool) {
        let text_size = ctx.theme.fonts.size.md;
        let adrs = String::new(); //ctx.get::<BDKPlugin>().get_new_address().to_string();
        let qr_code = QRCode::new(ctx, &adrs);
        let text = Text::new(ctx, "Scan to receive bitcoin.", TextStyle::Secondary, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![Box::new(qr_code), Box::new(text)]);
        let button = if IS_MOBILE {
            Button::primary(ctx, "Share", move |ctx: &mut Context| {}) // ctx.share(&adrs.clone())) // ctx.share(&adrs.clone(), &image_bytes) 
        } else {
            Button::primary(ctx, "Copy Address", move |ctx: &mut Context| {})// ctx.set_clipboard(adrs.clone()) )
        };

        let bumper = Bumper::single_button(ctx, button);
        let close = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = BitcoinHome::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });
        let header = Header::stack(ctx, Some(close), "Receive bitcoin", None);
        (Receive(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}

// #[derive(Debug, Component, AppPage)]
// pub struct ViewTransaction(Stack, Page);
// impl OnEvent for ViewTransaction {}

// impl ViewTransaction {
//     fn new(ctx: &mut Context) -> Self {
//         let current = ctx.state().get::<CurrentTransaction>().get();
//         let tx = current.unwrap();
//         let address = tx.address.map(format_address).unwrap_or("unknown".to_string());
//         let timestamp = tx.datetime.map(Timestamp::new).unwrap_or(Timestamp::pending());
//         let btc = tx.amount.to_btc().to_string().parse::<f64>().unwrap();

//         let (title, data_item) = match tx.is_received {
//             true => {
//                 let data_item = DataItem::received_tx(ctx, timestamp, btc, tx.price, &address);
//                 ("Received bitcoin", data_item)
//             }
//             false => {
//                 let fee = tx.fee.unwrap().to_btc().to_string().parse::<f64>().unwrap()*tx.price;
//                 let data_item = DataItem::sent_tx(ctx, timestamp, btc, tx.price, fee, &address);
//                 ("Sent bitcoin", data_item)
//             }
//         };

//         let nano_btc = &format_nano_btc(btc * NANS);
//         let usd_fmt = format_usd(btc*tx.price);
//         let amount_display = AmountDisplay::new(ctx, &usd_fmt, nano_btc);
//         let content = Content::new(Offset::Center, vec![Box::new(amount_display), Box::new(data_item)]);
//         let close = IconButton::navigation(ctx, "left", |ctx: &mut Context| BitcoinHome::navigate(ctx));
//         let header = Header::stack(ctx, Some(close), title, None);
//         let button = Button::close(ctx, "Done", |ctx: &mut Context| BitcoinHome::navigate(ctx));
//         let bumper = Bumper::single_button(ctx, button);
//         ViewTransaction(Stack::default(), Page::new(header, content, Some(bumper)), false)
//     }
// }
