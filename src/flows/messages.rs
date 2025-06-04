use pelican_ui::events::{Event, OnEvent, Key, NamedKey, KeyboardState, KeyboardEvent};
use pelican_ui::drawable::{Drawable, Component, Align, Span, Image};
use pelican_ui::layout::{Area, SizeRequest, Layout};
use pelican_ui::{Context, Component};
use profiles::Profile;

use messages::components::{QuickDeselect, TextMessage, MessageType};

use pelican_ui_std::{
    AppPage, Stack, Page,
    Header, IconButton,
    Avatar, AvatarContent,
    AvatarIconStyle, Icon, Text,
    ExpandableText,
    TextStyle, Content,
    Offset, ListItem,
    Button, ButtonState,
    Bumper, TextInput,
    SetActiveInput, IS_MOBILE,
    QuickActions, ListItemSelector,
    NavigateEvent, DataItem,
    Timestamp, ListItemGroup,
};

use::chrono::{DateTime, Local, Utc};

use crate::UserAccount;
// use crate::MSGPlugin;
// use crate::msg::{CurrentRoom, CurrentProfile};

#[derive(Debug, Component, AppPage)]
pub struct MessagesHome(Stack, Page, #[skip] bool);
impl OnEvent for MessagesHome {}

impl MessagesHome {
    pub fn new(ctx: &mut Context) -> Self {
        let header = Header::home(ctx, "Messages");
        let new_message = Button::primary(ctx, "New Message", |ctx: &mut Context| SelectRecipients::navigate(ctx));
        let bumper = Bumper::single_button(ctx, new_message);
        // let rooms = Vec::new(); //ctx.get::<MSGPlugin>().get_rooms();
        let messages: Vec<ListItem> = vec![]; //rooms.into_iter().map(|r| {
        //     let new_room = r.clone();
        //     match r.profiles.len() > 1 {
        //         true => {
        //             let names = r.profiles.into_iter().map(|p| p.user_name).collect::<Vec<String>>();
        //             ListItemMessages::group_message(ctx, names, move |ctx: &mut Context| {
        //                 // ctx.state().set(&CurrentRoom::new(new_room.clone()));
        //                 // GroupMessage::navigate(ctx)
        //             })
        //         },
        //         false => {
        //             let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
        //             ListItemMessages::direct_message(ctx, avatar, &r.profiles[0].user_name.clone(), &r.messages.last().unwrap().message.clone(), |ctx: &mut Context| DirectMessage::navigate(ctx))
        //         }
        //     }
        // }).collect::<Vec<ListItem>>();
        let text_size = ctx.theme.fonts.size.md;
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size, Align::Center);

        let content = match !messages.is_empty() {
            true => Content::new(Offset::Start, vec![Box::new(ListItemGroup::new(messages))]),
            false => Content::new(Offset::Center, vec![Box::new(instructions)])
        };

        MessagesHome(Stack::center(), Page::new(header, content, Some(bumper)), true)
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

#[derive(Debug, Component, AppPage)]
pub struct SelectRecipients(Stack, Page, #[skip] bool);
impl OnEvent for SelectRecipients {}

impl SelectRecipients {
    pub fn new(ctx: &mut Context) -> Self {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, None, "Profile name...", None, icon_button);
        // let profiles = vec![]; //ctx.get::<MSGPlugin>().get_profiles();
        let recipients: Vec<ListItem> = vec![]; // profiles.iter().map(|p| {
        //     let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
        //     ListItem::recipient(ctx, avatar, p.clone())
        // }).collect::<Vec<ListItem>>();

        let content = match recipients.is_empty() {
            true => {
                let text_size = ctx.theme.fonts.size.md;
                Box::new(Text::new(ctx, "No users found.", TextStyle::Secondary, text_size, Align::Center)) as Box<dyn Drawable>
            },
            false => Box::new(QuickDeselect::new(recipients)) as Box<dyn Drawable>
        };

        let content = Content::new(Offset::Start, vec![Box::new(searchbar), content]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| MessagesHome::navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        let button = Button::primary(ctx, "Continue", |ctx: &mut Context| {
            // let current_room = ctx.state().get::<CurrentRoom>();
            // let profiles = current_room.get().as_ref().unwrap().profiles.clone();
            // ctx.get::<MSGPlugin>().create_room(profiles);
            GroupMessage::navigate(ctx)
        });
        let bumper = Bumper::single_button(ctx, button);
        SelectRecipients(Stack::center(), Page::new(header, content, Some(bumper)), false)
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

#[derive(Debug, Component, AppPage)]
pub struct DirectMessage(Stack, Page, #[skip] bool);
impl OnEvent for DirectMessage {}

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
        DirectMessage(Stack::center(), Page::new(header, content, Some(bumper)), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct GroupMessage(Stack, Page, #[skip] bool);
impl OnEvent for GroupMessage {}

impl GroupMessage {
    pub fn new(ctx: &mut Context) -> Self {
        // let current_room = ctx.state().get::<CurrentRoom>();
        // let current_room = current_room.get().as_ref().unwrap();

        let messages = vec![]; // current_room.messages.iter().map(|msg| {
        //     let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
        //     let auth = msg.author.clone();
        //     let author = (auth.user_name, avatar);
        //     Box::new(TextMessage::new(ctx, MessageType::Group, &msg.message.clone(), author, msg.timestamp.clone())) as Box<dyn Drawable>
        // }).collect::<Vec<Box<dyn Drawable>>>();

        let profile_info = vec![]; //current_room.profiles.iter().map(|p| (p.user_name.clone(), AvatarContent::Icon("profile", AvatarIconStyle::Secondary))).collect::<Vec<_>>();

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(ctx, vec![Box::new(input)]);
       
        let content = Content::new(Offset::Start, messages);
        // content.set_scroll(Scroll::End);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| MessagesHome::navigate(ctx));
        let info = IconButton::navigation(ctx, "info", |ctx: &mut Context| GroupInfo::navigate(ctx));
        let header = Header::chat(ctx, Some(back), Some(info), profile_info);
        GroupMessage(Stack::center(), Page::new(header, content, Some(bumper)), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct GroupInfo(Stack, Page, #[skip] bool);
impl OnEvent for GroupInfo {}

impl GroupInfo {
    pub fn new(ctx: &mut Context) -> Self {
        // let current_room = ctx.state().get::<CurrentRoom>();
        // let current_room = current_room.get().as_ref().unwrap();
        let contacts = vec![]; //current_room.profiles.iter().map(|p| {
        //     let new_profile = p.clone();
        //     ListItem::contact(ctx, 
        //         AvatarContent::Icon("profile", 
        //         AvatarIconStyle::Secondary), 
        //         &new_profile.user_name.clone(), 
        //         &new_profile.identifier.clone(), 
        //         move |ctx: &mut Context| {
        //             // ctx.state().set(&CurrentProfile::new(new_profile.clone()));
        //             UserAccount::navigate(ctx);
        //         }
        //     )
        // }).collect::<Vec<ListItem>>();

        let text_size = ctx.theme.fonts.size.md;
        let members = format!("This group has {} members.", contacts.len());
        let text = Text::new(ctx, &members, TextStyle::Secondary, text_size, Align::Center);
        let content = Content::new(Offset::Start, vec![Box::new(text), Box::new(ListItemGroup::new(contacts))]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| GroupMessage::navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Group Message Info", None);
        GroupInfo(Stack::center(), Page::new(header, content, None), false)
    }
}