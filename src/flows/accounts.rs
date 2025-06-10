#![allow(dead_code)]

use pelican_ui::events::{Event, OnEvent, Key, NamedKey, KeyboardState, KeyboardEvent, TickEvent};
use pelican_ui::drawable::{Drawable, Component, Align, Span, Image};
use pelican_ui::layout::{Area, SizeRequest, Layout};
use pelican_ui::{Context, Component, ImageOrientation};
use profiles::events::UpdateProfileEvent;
use profiles::{generate_name, OrangeName};
use profiles::service::{Name, Profiles, Profile};
use profiles::plugin::{ProfilePlugin, ProfileRequest};
use profiles::components::{AvatarProfiles, AvatarContentProfiles, TextInputProfiles, DataItemProfiles};
use messages::{Rooms, Room};

use pelican_ui_std::{
    AppPage, Stack, Page,
    Header, IconButton,
    Avatar, AvatarContent,
    AvatarIconStyle,
    ExpandableText,
    TextStyle, Content,
    Offset, TextInput,
    Button, DataItem,
    Bumper, IconButtonRow,
    NavigateEvent,
    ButtonState,
    InputState,
};

use crate::GroupInfo;
use crate::DirectMessage;
use crate::Amount;
use crate::MessagesHome;

use std::sync::mpsc::{self, Receiver};
use std::sync::{Arc, Mutex};
use base64::{engine::general_purpose, Engine as _};
use serde_json::{json, Value};

use image::ImageFormat;

#[derive(Debug, Component, AppPage)]
pub struct Account(Stack, Page, #[skip] Receiver<(Vec<u8>, ImageOrientation)>, #[skip] ButtonState);

impl Account {
    pub fn new(ctx: &mut Context) -> (Self, bool) {
        let orange_name = ctx.state().get::<Name>().0.unwrap();
        let profiles = ctx.state().get::<Profiles>();
        let my_profile = profiles.0.get(&orange_name).unwrap();
        let my_username = my_profile.get("username").map(ToString::to_string).unwrap_or_else(|| {
            let name = generate_name(&orange_name.to_string().as_str());
            ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("username".into(), name.clone()));
            name
        });

        let my_biography = my_profile.get("biography").map(ToString::to_string).unwrap_or_else(|| {
            ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("biography".into(), String::new()));
            String::new()
        });

        let avatar_content = AvatarContentProfiles::from_orange_name(ctx, &orange_name);

        let (sender, receiver) = mpsc::channel();
        let avatar = AvatarProfiles::new_with_edit(ctx, avatar_content, sender);

        let name_input = TextInputProfiles::username(ctx, my_username);
        let bio_input = TextInputProfiles::biography(ctx, my_biography);

        let address_item = DataItemProfiles::address_item(ctx, &String::new());
        let orange_name_item = DataItemProfiles::orange_name_item(ctx, &orange_name);
        let avatar = AvatarProfiles::user(ctx, &orange_name);

        let save = Button::disabled(ctx, "Save", move |ctx: &mut Context| ctx.trigger_event(UpdateProfileEvent));
        let bumper = Bumper::single_button(ctx, save);

        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(name_input), Box::new(bio_input), Box::new(orange_name_item), Box::new(address_item)]);

        let header = Header::home(ctx, "Account");

        (Account(Stack::center(), Page::new(header, content, Some(bumper)), receiver, ButtonState::Default), true)
    }

    fn get_my_profile(ctx: &mut Context) -> (OrangeName, Profile) {
        let orange_name = ctx.state().get::<Name>().0.unwrap();
        let profiles = ctx.state().get::<Profiles>();
        let my_profile = profiles.0.get(&orange_name).unwrap();
        (orange_name, my_profile.clone())
    }

    fn sync_input_value(&mut self, index: usize, actual_value: &str) -> bool {
        let input = &mut self.1.content().find_at::<TextInput>(index).unwrap();
        let current = input.value().to_string();
        let changed = current != actual_value;
        if *input.status() != InputState::Focus && !changed {
            *input.value() = actual_value.to_string();
        }
        changed
    }

    fn update_button_state(&mut self, ctx: &mut Context, name_changed: bool, bio_changed: bool) {
        let button = self.1.bumper().as_mut().unwrap().find::<Button>().unwrap();
        let disabled = *button.status() == ButtonState::Disabled;
        if !disabled {self.3 = *button.status();}
        if (!name_changed && !bio_changed) && !disabled {*button.status() = ButtonState::Disabled;}
        if name_changed || bio_changed {*button.status() = self.3;}
        button.color(ctx);
    }
}

impl OnEvent for Account {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            let (orange_name, my_profile) = Self::get_my_profile(ctx);
            let my_username = my_profile.get("username").unwrap();
            let my_biography = my_profile.get("biography").unwrap();

            let avatar = self.1.content().find::<Avatar>().unwrap();
            AvatarProfiles::try_update(ctx, avatar, self.2.try_recv());

            let name_changed = self.sync_input_value(1, &my_username);
            let bio_changed = self.sync_input_value(2, &my_biography);

            self.update_button_state(ctx, name_changed, bio_changed);
        } else if let Some(UpdateProfileEvent) = event.downcast_ref::<UpdateProfileEvent>() {
            let (orange_name, my_profile) = Self::get_my_profile(ctx);
            let my_username = my_profile.get("username").unwrap();
            let my_biography = my_profile.get("biography").unwrap();

            let name_value = self.1.content().find_at::<TextInput>(1).unwrap().value().to_string();
            let bio_value = self.1.content().find_at::<TextInput>(2).unwrap().value().to_string();

            println!("Saving...");
            if name_value != *my_username {
                ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("username".to_string(), name_value));
            }
            if bio_value != *my_biography {
                ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("biography".to_string(), bio_value));
            }
            println!("Profile saved...");
        }

        true
    }
}

#[derive(Debug, Component, AppPage)]
pub struct UserAccount(Stack, Page);
impl OnEvent for UserAccount {}

impl UserAccount {
    pub fn new(
        ctx: &mut Context,
        orange_name: &OrangeName,
        account_return: (Box<dyn AppPage>, bool),
    ) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(orange_name).unwrap();
        let username = user.get("username").unwrap();

        let my_orange_name = ctx.state().get::<Name>().0.unwrap();
        let my_profile = profiles.0.get(&my_orange_name).unwrap();
        let is_blocked = my_profile.get("blocked_orange_names")
            .and_then(|s| serde_json::from_str::<Vec<String>>(s).ok())
            .map_or(false, |list| list.contains(&orange_name.to_string()));

        let account_return = Arc::new(Mutex::new(Some(account_return)));

        let messages = Self::messages(ctx, orange_name.clone(), account_return.clone());
        let bitcoin = Self::bitcoin(ctx);
        let block = Self::block(ctx, orange_name.clone(), account_return.clone(), is_blocked);

        let buttons = IconButtonRow::new(ctx, vec![messages, bitcoin, block]);

        let back = IconButton::navigation(ctx, "left", move |ctx| {
            let page = account_return.clone().lock().unwrap().take().unwrap();
            ctx.trigger_event(NavigateEvent(Some(page.0), page.1));
        });

        let address = DataItemProfiles::address_item(ctx, "");
        let orange_name_item = DataItemProfiles::orange_name_item(ctx, orange_name);
        let about_me = DataItemProfiles::biography_item(ctx, user);
        let avatar = AvatarProfiles::user(ctx, orange_name);

        let header = Header::stack(ctx, Some(back), &username, None);
        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(buttons), Box::new(about_me), Box::new(orange_name_item), Box::new(address)]);

        (UserAccount(Stack::center(), Page::new(header, content, None)), false)
    }

    pub fn block(
        ctx: &mut Context,
        orange_name: OrangeName,
        account_return: Arc<Mutex<Option<(Box<dyn AppPage>, bool)>>>,
        is_blocked: bool,
    ) -> (&'static str, Box<dyn FnMut(&mut Context)>) {
        let label = if is_blocked { "unblock" } else { "block" };
        let closure = Box::new(move |ctx: &mut Context| {
            let (page, with_nav) = match is_blocked { 
                true => {
                    let (page, with_nav) = UnblockUser::new(ctx, &orange_name, account_return.lock().unwrap().take().unwrap());
                    (page.into_boxed(), with_nav)
                },
                false => { 
                    let (page, with_nav) = BlockUser::new(ctx, &orange_name, account_return.lock().unwrap().take().unwrap());
                    (page.into_boxed(), with_nav)
                }
            };

            ctx.trigger_event(NavigateEvent(Some(page), with_nav));
        });

        (label, closure)
    }

    pub fn messages(ctx: &mut Context, orange_name: OrangeName, account_return: Arc<Mutex<Option<(Box<dyn AppPage>, bool)>>>) -> (&'static str, Box<dyn FnMut(&mut Context)>) {
        let closure = Box::new(move |ctx: &mut Context| {
            let mut rooms = ctx.state().get::<Rooms>();
            for (id, room) in rooms.0.iter() {
                if room.authors.len() == 1 && room.authors[0] == orange_name {
                    let (on_return, with_nav) =
                        UserAccount::new(ctx, &orange_name, account_return.lock().unwrap().take().unwrap());
                    let page = DirectMessage::new(ctx, id, (on_return.into_boxed(), with_nav));
                    ctx.trigger_event(NavigateEvent::new(page));
                    return;
                }
            }

            // Create new DM if none found
            let id = uuid::Uuid::new_v4();
            let (on_return, with_nav) = MessagesHome::new(ctx);
            let (page, with_nav) = DirectMessage::new(ctx, &id, (on_return.into_boxed(), with_nav));
            rooms.add(Room::new(vec![orange_name.clone()]), id);
            ctx.state().set(&rooms);
            ctx.trigger_event(NavigateEvent(Some(page.into_boxed()), with_nav));
        });

        ("messages", closure)
    }

    pub fn bitcoin(ctx: &mut Context) -> (&'static str, Box<dyn FnMut(&mut Context)>) {
        let closure = Box::new(move |ctx: &mut Context| {
            let page = Amount::new(ctx);
            ctx.trigger_event(NavigateEvent::new(page));
        });

        ("bitcoin", closure)
    }
}

#[derive(Debug, Component, AppPage)]
struct BlockUser(Stack, Page);
impl OnEvent for BlockUser {}

impl BlockUser {
    fn new(ctx: &mut Context, orange_name: &OrangeName, account_return: (Box<dyn AppPage>, bool)) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(&orange_name).unwrap();

        let theme = &ctx.theme;
        let text_size = theme.fonts.size.h4;

        let account_return = Arc::new(Mutex::new(Some(account_return)));

        let confirm_orange_name = orange_name.clone();
        let confirm_account_return = account_return.clone();
        let confirm = Button::primary(ctx, "Block", move |ctx: &mut Context| {
            let page = UserBlocked::new(ctx, &confirm_orange_name, confirm_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let cancel_orange_name = orange_name.clone();
        let cancel_account_return = account_return.clone();
        let cancel = Button::close(ctx, "Cancel", move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &cancel_orange_name, cancel_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let back_orange_name = orange_name.clone();
        let back_account_return = account_return.clone();
        let back = IconButton::navigation(ctx, "left", move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &back_orange_name, back_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let bumper = Bumper::double_button(ctx, cancel, confirm);
        let avatar = AvatarProfiles::new_with_block(ctx, orange_name);

        let username = user.get("username").unwrap();
        let msg = format!("Are you sure you want to block {}?", username);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let header = Header::stack(ctx, Some(back), "Block user", None);
        (BlockUser(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
struct UserBlocked(Stack, Page);
impl OnEvent for UserBlocked {}

impl UserBlocked {
    fn new(ctx: &mut Context, orange_name: &OrangeName, account_return: (Box<dyn AppPage>, bool)) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(&orange_name).unwrap();
        let my_orange_name = ctx.state().get::<Name>().0.unwrap();
        let my_profile = profiles.0.get(&my_orange_name).unwrap();

        let blocked = match my_profile.get("blocked_orange_names") {
            Some(names) => {
                match serde_json::from_str::<Value>(names) {
                    Ok(Value::Array(mut list)) => {
                        list.push(json!(orange_name));
                        Value::Array(list)
                    },
                    _ => json!([orange_name])
                }
            },
            None => {
                json!([orange_name])
            }
        };

        ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("blocked_orange_names".into(), blocked.to_string()));

        let theme = &ctx.theme;
        let text_size = theme.fonts.size.h4;
        let account_return = Arc::new(Mutex::new(Some(account_return)));

        let button_orange_name = orange_name.clone();
        let button_account_return = account_return.clone();
        let button = Button::close(ctx, "Done",  move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &button_orange_name, button_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let bumper = Bumper::single_button(ctx, button);
        let avatar = AvatarProfiles::new_with_block(ctx, orange_name);

        let username = user.get("username").unwrap();
        let msg = format!("{} has been blocked", username);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);

        let close_orange_name = orange_name.clone();
        let close_account_return = account_return.clone();
        let close = IconButton::close(ctx,  move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &close_orange_name, close_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let header = Header::stack(ctx, Some(close), "User blocked", None);
        (UserBlocked(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
struct UnblockUser(Stack, Page);
impl OnEvent for UnblockUser {}

impl UnblockUser {
    fn new(ctx: &mut Context, orange_name: &OrangeName, account_return: (Box<dyn AppPage>, bool)) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(&orange_name).unwrap();

        let text_size = ctx.theme.fonts.size.h4;

        let account_return = Arc::new(Mutex::new(Some(account_return)));

        let unblock_orange_name = orange_name.clone();
        let unblock_account_return = account_return.clone();
        let confirm = Button::primary(ctx, "Unblock", move |ctx: &mut Context| {
            let page = UserUnblocked::new(ctx, &unblock_orange_name, unblock_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let cancel_orange_name = orange_name.clone();
        let cancel_account_return = account_return.clone();
        let cancel = Button::close(ctx, "Cancel", move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &cancel_orange_name, cancel_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let back_orange_name = orange_name.clone();
        let back_account_return = account_return.clone();
        let back = IconButton::navigation(ctx, "left", move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &back_orange_name, back_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let bumper = Bumper::double_button(ctx, cancel, confirm);
        let avatar = AvatarProfiles::new_with_unblock(ctx, orange_name); 
        
        let username = user.get("username").unwrap();
        let msg = format!("Are you sure you want to unblock {}?", username);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let header = Header::stack(ctx, Some(back), "Unblock user", None);
        (UnblockUser(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
struct UserUnblocked(Stack, Page);
impl OnEvent for UserUnblocked {}

impl UserUnblocked {
    fn new(ctx: &mut Context, orange_name: &OrangeName, account_return: (Box<dyn AppPage>, bool)) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(&orange_name).unwrap();

        let text_size = ctx.theme.fonts.size.h4;
        let account_return = Arc::new(Mutex::new(Some(account_return)));

        let button_orange_name = orange_name.clone();
        let button_account_return = account_return.clone();
        let button = Button::close(ctx, "Done", move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &button_orange_name, button_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let bumper = Bumper::single_button(ctx, button);
        let avatar = AvatarProfiles::new_with_unblock(ctx, orange_name);

        let username = user.get("username").unwrap();
        let msg = format!("{} has been unblocked", username);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);

        let close_orange_name = orange_name.clone();
        let close_account_return = account_return.clone();
        let close = IconButton::close(ctx, move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &close_orange_name, close_account_return.lock().unwrap().take().unwrap());
            ctx.trigger_event(NavigateEvent::new(page))
        });
        let header = Header::stack(ctx, Some(close), "User unblocked", None);
        (UserUnblocked(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}
