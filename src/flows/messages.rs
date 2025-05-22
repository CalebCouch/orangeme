use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;
use pelican_ui_messages::prelude::*;

use::chrono::{DateTime, Local, Utc};

use crate::MSGPlugin;
use crate::msg::{CurrentRoom};

#[derive(Debug, Copy, Clone)]
pub enum MessagesFlow {
    MessagesHome,
    SelectRecipients,
    DirectMessage,
    GroupMessage,
    GroupInfo,
}

impl AppFlow for MessagesFlow {
    fn get_page(&self, ctx: &mut Context) -> (Box<dyn AppPage>, bool) {
        match self {
            MessagesFlow::MessagesHome => (Box::new(MessagesHome::new(ctx)) as Box<dyn AppPage>, true),
            MessagesFlow::SelectRecipients => (Box::new(SelectRecipients::new(ctx)) as Box<dyn AppPage>, false),
            MessagesFlow::DirectMessage => (Box::new(DirectMessage::new(ctx)) as Box<dyn AppPage>, false),
            MessagesFlow::GroupMessage => (Box::new(GroupMessage::new(ctx)) as Box<dyn AppPage>, false),
            MessagesFlow::GroupInfo => (Box::new(GroupInfo::new(ctx)) as Box<dyn AppPage>, false),
        }
    }
}

#[derive(Debug, Component)]
pub struct MessagesHome(Stack, Page);
impl OnEvent for MessagesHome {}
impl AppPage for MessagesHome {}

impl MessagesHome {
    pub fn new(ctx: &mut Context) -> Self {
        let header = Header::home(ctx, "Messages");
        let new_message = Button::primary(ctx, "New Message", |ctx: &mut Context| MessagesFlow::SelectRecipients.navigate(ctx));
        let bumper = Bumper::single_button(ctx, new_message);
        let rooms = ctx.get::<MSGPlugin>().get_rooms();
        let messages = rooms.into_iter().map(|r| {
            let new_room = r.clone();
            match r.profiles.len() > 1 {
                true => {
                    let names = r.profiles.into_iter().map(|p| p.user_name).collect::<Vec<String>>();
                    ListItem::group_message(ctx, names, move |ctx: &mut Context| {
                        ctx.state().set(&CurrentRoom::new(new_room.clone()));
                        MessagesFlow::GroupMessage.navigate(ctx)
                    })
                },
                false => {
                    let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
                    ListItem::direct_message(ctx, avatar, &r.profiles[0].user_name.clone(), &r.messages.last().unwrap().message.clone(), |ctx: &mut Context| MessagesFlow::DirectMessage.navigate(ctx))
                }
            }
        }).collect::<Vec<ListItem>>();
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size, Align::Center);

        let content = match !messages.is_empty() {
            true => Content::new(Offset::Start, vec![Box::new(ListItemGroup::new(messages))]),
            false => Content::new(Offset::Center, vec![Box::new(instructions)])
        };

        MessagesHome(Stack::center(), Page::new(header, content, Some(bumper)))
    }
}

// impl OnEvent for BitcoinHome {
//     fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
//         if let Some(TickEvent) = event.downcast_ref() {
//             let bdk = ctx.get::<BDKPlugin>();
//             let (btc, price) = (bdk.get_balance().to_btc(), bdk.get_price());
//             let items = &mut *self.1.content().items();
//             let display: &mut AmountDisplay = items[0].as_any_mut().downcast_mut::<AmountDisplay>().unwrap();
//             *display.usd() = format_usd(btc*price as f64).to_string();
//             *display.btc() = format_nano_btc(btc*NANS).to_string();
//             self.update_transactions(ctx);
//         }
//         true
//     }
// }

// pub fn direct_message(
//     ctx: &mut Context,
//     data: AvatarContent,
//     name: &str,
//     recent: &str,
//     on_click: impl FnMut(&mut Context) + 'Static

// pub fn group_message(
//     ctx: &mut Context,
//     names: Vec<&str>,
//     on_click: impl FnMut(&mut Context) + 'static

#[derive(Debug, Component)]
pub struct SelectRecipients(Stack, Page);
impl OnEvent for SelectRecipients {}
impl AppPage for SelectRecipients {}

impl SelectRecipients {
    pub fn new(ctx: &mut Context) -> Self {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, None, "Profile name...", None, icon_button);
        let profiles = ctx.get::<MSGPlugin>().get_profiles();
        let recipients = profiles.iter().map(|p| {
            let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
            ListItem::recipient(ctx, avatar, p.clone())
        }).collect::<Vec<ListItem>>();

        let content = match recipients.is_empty() {
            true => {
                let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
                Box::new(Text::new(ctx, "No users found.", TextStyle::Secondary, text_size, Align::Center)) as Box<dyn Drawable>
            },
            false => Box::new(QuickDeselect::new(recipients)) as Box<dyn Drawable>
        };

        let content = Content::new(Offset::Start, vec![Box::new(searchbar), content]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| MessagesFlow::MessagesHome.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        let button = Button::primary(ctx, "Continue", |ctx: &mut Context| {
            let current_room = ctx.state().get::<CurrentRoom>();
            let profiles = current_room.get().as_ref().unwrap().profiles.clone();
            ctx.get::<MSGPlugin>().create_room(profiles);
            MessagesFlow::GroupMessage.navigate(ctx)
        });
        let bumper = Bumper::single_button(ctx, button);
        SelectRecipients(Stack::center(), Page::new(header, content, Some(bumper)))
    }
}


// impl OnEvent for Speed {
//     fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
//         if let Some(TickEvent) = event.downcast_ref() {
//             let item = &mut *self.1.content().items()[1];
//             if let Some(selector) = item.as_any_mut().downcast_mut::<QuickDeselect>() {
//                 let members = selector.get_profiles();
//                 ctx.state().set(CurrentRoom::new(Room::new(members, Vec::new())));
//             }
//         }
//         true
//     }
// }

#[derive(Debug, Component)]
pub struct DirectMessage(Stack, Page);
impl OnEvent for DirectMessage {}
impl AppPage for DirectMessage {}

impl DirectMessage {
    pub fn new(ctx: &mut Context) -> Self {
        let message = "Did you go to the market on Saturday?".to_string();

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(ctx, vec![Box::new(input)]);
        let dt1 = "2025-05-19T15:20:11Z".parse::<DateTime<Utc>>().unwrap().with_timezone(&Local);
        let message = TextMessage::new(ctx, MessageType::Contact, &message, ("Marge".to_string(), AvatarContent::Icon("profile", AvatarIconStyle::Secondary)), Timestamp::new(dt1));
        let content = Content::new(Offset::End, vec![Box::new(message)]);
        let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::chat(ctx, Some(back), None, vec![("Marge Margarine".to_string(), AvatarContent::Icon("profile", AvatarIconStyle::Secondary))]);
        DirectMessage(Stack::center(), Page::new(header, content, Some(bumper)))
    }
}

#[derive(Debug, Component)]
pub struct GroupMessage(Stack, Page);
impl OnEvent for GroupMessage {}
impl AppPage for GroupMessage {}

impl GroupMessage {
    pub fn new(ctx: &mut Context) -> Self {
        let current_room = ctx.state().get::<CurrentRoom>();
        let current_room = current_room.get().as_ref().unwrap();

        let messages = current_room.messages.iter().map(|msg| {
            let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
            let auth = msg.author.clone();
            let author = (auth.user_name, avatar);
            Box::new(TextMessage::new(ctx, MessageType::Group, &msg.message.clone(), author, msg.timestamp.clone())) as Box<dyn Drawable>
        }).collect::<Vec<Box<dyn Drawable>>>();

        let profile_info = current_room.profiles.iter().map(|p| (p.user_name.clone(), AvatarContent::Icon("profile", AvatarIconStyle::Secondary))).collect::<Vec<_>>();

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(ctx, vec![Box::new(input)]);
       
        let content = Content::new(Offset::Start, messages);
        // content.set_scroll(Scroll::End);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| MessagesFlow::MessagesHome.navigate(ctx));
        let info = IconButton::navigation(ctx, "info", |ctx: &mut Context| MessagesFlow::GroupInfo.navigate(ctx));
        let header = Header::chat(ctx, Some(back), Some(info), profile_info);
        GroupMessage(Stack::center(), Page::new(header, content, Some(bumper)))
    }
}

#[derive(Debug, Component)]
pub struct GroupInfo(Stack, Page);
impl OnEvent for GroupInfo {}
impl AppPage for GroupInfo {}

impl GroupInfo {
    pub fn new(ctx: &mut Context) -> Self {
        let current_room = ctx.state().get::<CurrentRoom>();
        let current_room = current_room.get().as_ref().unwrap();
        let contacts = current_room.profiles.iter().map(|p| {
            ListItem::contact(ctx, 
                AvatarContent::Icon("profile", 
                AvatarIconStyle::Secondary), 
                &p.user_name.clone(), 
                &p.identifier.clone(), 
                |_ctx: &mut Context| {
                    // set current contact
                    // go to contacts page
                }
            )
        }).collect::<Vec<ListItem>>();

        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
        let members = format!("This group has {} members.", contacts.len());
        let text = Text::new(ctx, &members, TextStyle::Secondary, text_size, Align::Center);
        let content = Content::new(Offset::Start, vec![Box::new(text), Box::new(ListItemGroup::new(contacts))]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| MessagesFlow::GroupMessage.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Group Message Info", None);
        GroupInfo(Stack::center(), Page::new(header, content, None))
    }
}