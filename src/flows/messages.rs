use pelican_ui::events::{Event, OnEvent, Key, NamedKey, KeyboardState, KeyboardEvent, TickEvent};
use pelican_ui::drawable::{Drawable, Component, Align, Span, Image};
use pelican_ui::layout::{Area, SizeRequest, Layout};
use pelican_ui::{Context, Component};
use profiles::service::{Profile, Profiles, Name};
use profiles::components::AvatarContentProfiles;

use messages::{Room, Rooms, Message};
use messages::components::{QuickDeselect, TextMessage, MessageType, ListItemMessages, TextMessageGroup};

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
pub struct MessagesHome(Stack, Page);
impl OnEvent for MessagesHome {}

impl MessagesHome {
    pub fn new(ctx: &mut Context) -> (Self, bool) {

        let header = Header::home(ctx, "Messages");
        let new_message = Button::primary(ctx, "New Message", |ctx: &mut Context| {
            let page = SelectRecipients::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let bumper = Bumper::single_button(ctx, new_message);
        let rooms = ctx.state().get::<Rooms>().0;
        let messages = rooms.into_iter().map(|(id, room)| {
            match room.authors.len() > 1 {
                true => {
                    ListItemMessages::group_message(ctx, &id, 
                        move |ctx: &mut Context| {
                            let page = GroupMessage::new(ctx, &id);
                            ctx.trigger_event(NavigateEvent::new(page));
                        }
                    )
                },
                false => {
                    ListItemMessages::direct_message(ctx, &id,
                        move |ctx: &mut Context| {
                            let page = DirectMessage::new(ctx, &id);
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
        let profiles = ctx.state().get::<Profiles>().0;
        let recipients = profiles.iter().map(|(orange_name, profile)| {
            let avatar = AvatarContent::Icon("profile", AvatarIconStyle::Secondary);
            ListItemMessages::recipient(ctx, orange_name)
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
        let button = Button::primary(ctx, "Continue", move |ctx: &mut Context| {
            // let profiles = ctx.state().get::<Profiles>().0; // get profiles from QuickDeseloct (this might need to be an event)
            // let mut new_room = Room::from(profiles);
            // let page = GroupMessage::new(ctx, &mut new_room);
            // ctx.state().get::<Rooms>().add(new_room); // or dm
            // ctx.trigger_event(NavigateEvent::new(page))
        });

        let bumper = Bumper::single_button(ctx, button);
        (SelectRecipients(Stack::center(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct DirectMessage(Stack, Page);
impl OnEvent for DirectMessage {}

impl DirectMessage {
    pub fn new(ctx: &mut Context, room_id: &uuid::Uuid) -> (Self, bool) {
        let message = "Did you go to the market on Saturday?".to_string();

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let other = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(ctx, vec![Box::new(input)]);
        // let dt1 = "2025-05-19T15:20:11Z".parse::<DateTime<Utc>>().unwrap().with_timezone(&Local);
        // let message = TextMessage::new(ctx, MessageType::Contact, message);
        let content = Content::new(Offset::End, vec![Box::new(other)]);
        let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::chat(ctx, Some(back), None, vec![("Marge Margarine".to_string(), AvatarContent::Icon("profile", AvatarIconStyle::Secondary))]);
        (DirectMessage(Stack::center(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
pub struct GroupMessage(Stack, Page, #[skip] uuid::Uuid);

impl GroupMessage {
    pub fn new(ctx: &mut Context, room_id: &uuid::Uuid) -> (Self, bool) {
        let rooms = ctx.state().get::<Rooms>();
        let room = rooms.0.get(room_id).unwrap();
        let room_id = room_id.clone();

        let messages = room.messages.iter().map(|msg| {
            TextMessage::new(ctx, MessageType::Group, msg.clone())
        }).collect::<Vec<TextMessage>>();

        let messages = TextMessageGroup::new(messages);

        let profile_info = room.authors.iter().map(|orange_name| {
            let profiles = ctx.state().get::<Profiles>();
            let profile = profiles.0.get(orange_name).unwrap();
            let username = profile.get("username").unwrap();
            (username.to_string(), AvatarContentProfiles::from_orange_name(ctx, &orange_name))
        }).collect::<Vec<_>>();

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", 
            move |ctx: &mut Context, string: &mut String| {
                println!("Message: {:?}", string);
                let mut rooms = ctx.state().get::<Rooms>();
                let room = rooms.find(&room_id).unwrap();
                let orange_name = ctx.state().get::<Name>().0.unwrap();
                room.add_message(Message::from(string.to_string(), orange_name));
            }
        )));

        let bumper = Bumper::new(ctx, vec![Box::new(input)]);
       
        // content.set_scroll(Scroll::End);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            let page = MessagesHome::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let info = IconButton::navigation(ctx, "info", move |ctx: &mut Context| {
            let page = GroupInfo::new(ctx, &room_id);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let content = Content::new(Offset::Start, vec![Box::new(messages)]);
        let header = Header::chat(ctx, Some(back), Some(info), profile_info);
        (GroupMessage(Stack::center(), Page::new(header, content, Some(bumper)), room_id), false)
    }
}

impl OnEvent for GroupMessage {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            let messages = &mut *self.1.content().find::<TextMessageGroup>().unwrap();
            let mut rooms = ctx.state().get::<Rooms>();
            let room = rooms.find(&self.2).unwrap();
            // println!("Room ID {:?} and message length {:?}", room.room_id, room.messages.len()); 

            if room.messages.len() != messages.messages().len() {
                println!("changed");
                let new_messages = room.messages.iter().map(|msg| {
                    TextMessage::new(ctx, MessageType::Group, msg.clone())
                }).collect::<Vec<TextMessage>>();

                *messages = TextMessageGroup::new(new_messages);
            }
        }
        true
    }
}

#[derive(Debug, Component, AppPage)]
pub struct GroupInfo(Stack, Page);
impl OnEvent for GroupInfo {}

impl GroupInfo {
    pub fn new(ctx: &mut Context, room_id: &uuid::Uuid) -> (Self, bool) {
        let mut rooms = ctx.state().get::<Rooms>();
        let room = rooms.find(&room_id).unwrap();
        let contacts = room.authors.iter().map(|orange_name| {
            let new_profile = orange_name.clone();
            ListItemMessages::contact(ctx, &orange_name,
                move |ctx: &mut Context| {
                    // ctx.state().set(&CurrentProfile::new(new_profile.clone()));
                    let page = UserAccount::new(ctx, &new_profile.clone());
                    ctx.trigger_event(NavigateEvent::new(page))
                }
            )
        }).collect::<Vec<ListItem>>();

        let text_size = ctx.theme.fonts.size.md;
        let members = format!("This group has {} members.", contacts.len());
        let text = Text::new(ctx, &members, TextStyle::Secondary, text_size, Align::Center);
        let content = Content::new(Offset::Start, vec![Box::new(text), Box::new(ListItemGroup::new(contacts))]);

        let room_id = room_id.clone(); 
        let back = IconButton::navigation(ctx, "left", move |ctx: &mut Context| {
            let page = GroupMessage::new(ctx, &room_id);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let header = Header::stack(ctx, Some(back), "Group Message Info", None);
        (GroupInfo(Stack::center(), Page::new(header, content, None)), false)
    }
}

