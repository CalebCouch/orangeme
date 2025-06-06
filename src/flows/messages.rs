use pelican_ui::events::{Event, OnEvent, Key, NamedKey, KeyboardState, KeyboardEvent};
use pelican_ui::drawable::{Drawable, Component, Align, Span, Image};
use pelican_ui::layout::{Area, SizeRequest, Layout};
use pelican_ui::{Context, Component};
use profiles::Profile;
use messages::Room;

use messages::components::{QuickDeselect, TextMessage, MessageType, ListItemMessages};

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
use crate::msg::{AllRooms, AllProfiles, fake_profiles};

// use crate::MSGPlugin;
// use crate::msg::{CurrentRoom, CurrentProfile};

#[derive(Debug, Component, AppPage)]
pub struct MessagesHome(Stack, Page);
impl OnEvent for MessagesHome {}

impl MessagesHome {
    pub fn new(ctx: &mut Context) -> (Self, bool) {
        ctx.state().set(&AllRooms::new());
        ctx.state().set(&AllProfiles::new());

        let header = Header::home(ctx, "Messages");
        let new_message = Button::primary(ctx, "New Message", |ctx: &mut Context| {
            let page = SelectRecipients::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });
        let bumper = Bumper::single_button(ctx, new_message);
        let rooms: &mut Vec<Room> = ctx.state().get::<AllRooms>().get();
        let messages = rooms.iter_mut().map(|r| {
            match r.profiles.len() > 1 {
                true => {
                    let names = r.profiles.iter().map(|p| p.user_name.clone()).collect::<Vec<String>>();
                    ListItemMessages::group_message(ctx, names, 
                        |ctx: &mut Context| {
                            let page = GroupMessage::new(ctx, r);
                            ctx.trigger_event(NavigateEvent::new(page));
                        }
                    )
                },
                false => {
                    let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
                    ListItemMessages::direct_message(ctx, avatar, 
                        &r.profiles[0].user_name.clone(), 
                        &r.messages.last().unwrap().message.clone(), 
                        |ctx: &mut Context| {
                            let page = DirectMessage::new(ctx);
                            ctx.trigger_event(NavigateEvent::new(page));
                        }
                    )
                }
            }
        }).collect::<Vec<ListItem>>();
        let text_size = ctx.theme.fonts.size.md;
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size, Align::Center);

        let content = match !messages.is_empty() {
            true => Content::new(Offset::Start, vec![Box::new(ListItemGroup::new(messages))]),
            false => Content::new(Offset::Center, vec![Box::new(instructions)])
        };

        (MessagesHome(Stack::center(), Page::new(header, content, Some(bumper))), true)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct SelectRecipients(Stack, Page);
impl OnEvent for SelectRecipients {}

impl SelectRecipients {
    pub fn new(ctx: &mut Context) -> (Self, bool) {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, None, "Profile name...", None, icon_button);
        let profiles = ctx.state().get::<AllProfiles>().0;
        let recipients = profiles.iter().map(|p| {
            let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
            ListItemMessages::recipient(ctx, avatar, p.clone())
        }).collect::<Vec<ListItem>>();

        let content = match recipients.is_empty() {
            true => {
                let text_size = ctx.theme.fonts.size.md;
                Box::new(Text::new(ctx, "No users found.", TextStyle::Secondary, text_size, Align::Center)) as Box<dyn Drawable>
            },
            false => Box::new(QuickDeselect::new(recipients)) as Box<dyn Drawable>
        };

        let content = Content::new(Offset::Start, vec![Box::new(searchbar), content]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = MessagesHome::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        let button = Button::primary(ctx, "Continue", |ctx: &mut Context| {
            let new_room = Room::from(profiles);
            let page = GroupMessage::new(ctx, &mut new_room);
            ctx.state().get::<AllRooms>().add(new_room); // or dm
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let bumper = Bumper::single_button(ctx, button);
        (SelectRecipients(Stack::center(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct DirectMessage(Stack, Page);
impl OnEvent for DirectMessage {}

impl DirectMessage {
    pub fn new(ctx: &mut Context) -> (Self, bool) {
        let message = "Did you go to the market on Saturday?".to_string();

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(ctx, vec![Box::new(input)]);
        let dt1 = "2025-05-19T15:20:11Z".parse::<DateTime<Utc>>().unwrap().with_timezone(&Local);
        let message = TextMessage::new(ctx, MessageType::Contact, &message, ("Marge".to_string(), AvatarContent::Icon("profile", AvatarIconStyle::Secondary)), Timestamp::new(dt1));
        let content = Content::new(Offset::End, vec![Box::new(message)]);
        let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::chat(ctx, Some(back), None, vec![("Marge Margarine".to_string(), AvatarContent::Icon("profile", AvatarIconStyle::Secondary))]);
        (DirectMessage(Stack::center(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct GroupMessage(Stack, Page);
impl OnEvent for GroupMessage {}

impl GroupMessage {
    pub fn new(ctx: &mut Context, room: &mut Room) -> (Self, bool) {

        let messages = room.messages.iter().map(|msg| {
            let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
            let auth = msg.author.clone();
            let author = (auth.user_name, avatar);
            Box::new(TextMessage::new(ctx, MessageType::Group, &msg.message.clone(), author, msg.timestamp.clone())) as Box<dyn Drawable>
        }).collect::<Vec<Box<dyn Drawable>>>();

        let profile_info = room.profiles.iter().map(|p| (p.user_name.clone(), AvatarContent::Icon("profile", AvatarIconStyle::Secondary))).collect::<Vec<_>>();

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(ctx, vec![Box::new(input)]);
       
        let content = Content::new(Offset::Start, messages);
        // content.set_scroll(Scroll::End);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = MessagesHome::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let info = IconButton::navigation(ctx, "info", |ctx: &mut Context| {
            let page = GroupInfo::new(ctx, room);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let header = Header::chat(ctx, Some(back), Some(info), profile_info);
        (GroupMessage(Stack::center(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct GroupInfo(Stack, Page);
impl OnEvent for GroupInfo {}

impl GroupInfo {
    pub fn new(ctx: &mut Context, room: &mut Room) -> (Self, bool) {
        // let current_room = ctx.state().get::<CurrentRoom>();
        // let current_room = current_room.get().as_ref().unwrap();
        let contacts = room.profiles.iter().map(|p| {
            let new_profile = p.clone();
            ListItemMessages::contact(ctx, 
                AvatarContent::Icon("profile", 
                AvatarIconStyle::Secondary), 
                &new_profile.user_name.clone(), 
                &new_profile.identifier.clone(), 
                move |ctx: &mut Context| {
                    // ctx.state().set(&CurrentProfile::new(new_profile.clone()));
                    let page = UserAccount::new(ctx);
                    ctx.trigger_event(NavigateEvent::new(page))
                }
            )
        }).collect::<Vec<ListItem>>();

        let text_size = ctx.theme.fonts.size.md;
        let members = format!("This group has {} members.", contacts.len());
        let text = Text::new(ctx, &members, TextStyle::Secondary, text_size, Align::Center);
        let content = Content::new(Offset::Start, vec![Box::new(text), Box::new(ListItemGroup::new(contacts))]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = GroupMessage::new(ctx, room);
            ctx.trigger_event(NavigateEvent::new(page))
        });
        
        let header = Header::stack(ctx, Some(back), "Group Message Info", None);
        (GroupInfo(Stack::center(), Page::new(header, content, None)), false)
    }
}

