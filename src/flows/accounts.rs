#![allow(dead_code)]

use pelican_ui::events::{Event, OnEvent, Key, NamedKey, KeyboardState, KeyboardEvent, TickEvent};
use pelican_ui::drawable::{Drawable, Component, Align, Span, Image};
use pelican_ui::layout::{Area, SizeRequest, Layout};
use pelican_ui::{Context, Component, ImageOrientation};
use profiles::events::UpdateProfileEvent;
use profiles::{generate_name, OrangeName};
use profiles::service::{Name, Profiles, Profile};
use profiles::plugin::{ProfilePlugin, ProfileRequest};
use profiles::components::avatar::{AvatarProfiles, AvatarContentProfiles};

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

use std::sync::mpsc::{self, Receiver};
use base64::{engine::general_purpose, Engine as _};

use image::ImageFormat;

#[derive(Debug, Component, AppPage)]
pub struct Account(Stack, Page, #[skip] Receiver<(Vec<u8>, ImageOrientation)>, #[skip] ButtonState);

impl Account {
    pub fn new(ctx: &mut Context) -> (Self, bool) {
        let orange_name = ctx.state().get::<Name>().0.unwrap();
        let profiles = ctx.state().get::<Profiles>();
        let my_profile = profiles.0.get(&orange_name).unwrap();
        let my_user_name = my_profile.get("name").map(ToString::to_string).unwrap_or_else(|| {
            let name = generate_name(&orange_name.to_string().as_str());
            ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("name".into(), name.clone()));
            name
        });

        let my_biography = my_profile.get("biography").map(ToString::to_string).unwrap_or_else(|| {
            ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("biography".into(), String::new()));
            String::new()
        });

        let avatar_content = AvatarContentProfiles::from_orange_name(ctx, &orange_name);

        let (sender, receiver) = mpsc::channel();
        let avatar = AvatarProfiles::new_with_edit(ctx, avatar_content, sender);

        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let name_input = TextInput::new(ctx, Some(&my_user_name), Some("Name"), "Account name...", None, icon_button);
        let bio_input = TextInput::new(ctx, Some(&my_biography), Some("About me"), "About me...", None, icon_button);

        let adrs = String::new(); // ctx.get::<BDKPlugin>().get_new_address().to_string();
        let (copy_address, copy_identity) = (adrs.clone(), orange_name.to_string().clone());

        let copy = Button::secondary(ctx, Some("copy"), "Copy", None, move |ctx: &mut Context| ctx.hardware.copy(copy_address.clone()));
        let address = DataItem::new(ctx, None, "Bitcoin address", Some(&adrs), None, None, Some(vec![copy]));

        let copy = Button::secondary(ctx, Some("copy"), "Copy", None, move |ctx: &mut Context| ctx.hardware.copy(copy_identity.clone()));
        let identity = DataItem::new(ctx, None, "Orange Name", Some(orange_name.to_string().as_str()), None, None, Some(vec![copy]));

        let save = Button::disabled(ctx, "Save", move |ctx: &mut Context| ctx.trigger_event(UpdateProfileEvent));
        let bumper = Bumper::single_button(ctx, save);
        let header = Header::home(ctx, "Account");

        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(name_input), Box::new(bio_input), Box::new(identity), Box::new(address)]);

        (Account(Stack::center(), Page::new(header, content, Some(bumper)), receiver, ButtonState::Default), true)
    }
}

impl OnEvent for Account {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            let orange_name = ctx.state().get::<Name>().0.unwrap();
            let profiles = ctx.state().get::<Profiles>();

            let my_profile = profiles.0.get(&orange_name).unwrap();
            let my_username = my_profile.get("name").unwrap_or(&String::new()).to_string();
            let my_biography = my_profile.get("biography").unwrap_or(&String::new()).to_string();

            if let Ok((bytes, orientation)) = self.2.try_recv() {
                match image::load_from_memory(&bytes) {
                    Ok(dynamic) => {
                        let image = orientation.apply_to(image::DynamicImage::ImageRgba8(dynamic.to_rgba8()));
                        let mut png_bytes = Vec::new();
                        image.write_to(&mut std::io::Cursor::new(&mut png_bytes), ImageFormat::Png).unwrap();
                        let base64_png = general_purpose::STANDARD.encode(&png_bytes);

                        ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("avatar".to_string(), base64_png));
                        let asset_image = ctx.assets.add_image(image.into());
                        let avatar = self.1.content().find::<Avatar>().unwrap();
                        avatar.set_content(AvatarContent::Image(asset_image));
                    },
                    Err(e) => println!("Failed {:?}", e)
                }
            }

            let name_input = self.1.content().find_at::<TextInput>(1).unwrap();
            let name_value = name_input.value().to_string();
            let name_changed = name_value != my_username;
            let _ = (*name_input.status() != InputState::Focus && !name_changed).then(|| *name_input.value() = my_username.clone());
        
            let bio_input = self.1.content().find_at::<TextInput>(2).unwrap();
            let bio_value = bio_input.value().to_string();
            let bio_changed = bio_value != my_biography;
            let _ = (*bio_input.status() != InputState::Focus && !bio_changed).then(|| *bio_input.value() = my_biography.clone());

            let button = self.1.bumper().as_mut().unwrap().find::<Button>().unwrap();
            let not_disabled = *button.status() == ButtonState::Disabled;
            not_disabled.then(|| self.3 = *button.status());

            *button.status() = (name_changed || bio_changed).then_some(self.3)
                .or_else(|| not_disabled.then_some(ButtonState::Disabled))
                .unwrap_or_else(|| *button.status());

            button.color(ctx);

        } else if let Some(UpdateProfileEvent) = event.downcast_ref::<UpdateProfileEvent>() {
            let orange_name = ctx.state().get::<Name>().0.unwrap();
            let profiles = ctx.state().get::<Profiles>();

            let my_profile = profiles.0.get(&orange_name).unwrap();
            let my_username = my_profile.get("name").unwrap_or(&String::new()).to_string();
            let my_biography = my_profile.get("biography").unwrap_or(&String::new()).to_string();

            let name_value = self.1.content().find_at::<TextInput>(1).unwrap().value().to_string();
            let bio_value = self.1.content().find_at::<TextInput>(2).unwrap().value().to_string();

            println!("Saving...");
            if name_value != my_username {
                ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("name".to_string(), name_value));
            }
            if bio_value != my_biography {
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
    pub fn new(ctx: &mut Context, orange_name: &OrangeName) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(&orange_name).unwrap();

        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| {
            // let page = GroupInfo::new(ctx);
            // ctx.trigger_event(NavigateEvent::new(page))
        });

        let orange_name_for_block = orange_name.clone();
        let orange_name_for_messages = orange_name.clone();

        let buttons = IconButtonRow::new(ctx, vec![
            ("messages", Box::new(move |ctx: &mut Context| {
                // let page = DirectMessage::new(ctx, &orange_name_for_messages);
                // ctx.trigger_event(NavigateEvent::new(page))
            }) as Box<dyn FnMut(&mut Context)>),
            ("bitcoin", Box::new(|ctx: &mut Context| {
                let page = Amount::new(ctx);
                ctx.trigger_event(NavigateEvent::new(page))
            }) as Box<dyn FnMut(&mut Context)>),
            ("block", Box::new(move |ctx: &mut Context| {
                let page = BlockUser::new(ctx, &orange_name_for_block);
                ctx.trigger_event(NavigateEvent::new(page))
            }) as Box<dyn FnMut(&mut Context)>),
        ]);

        let adrs = String::new(); //ctx.get::<BDKPlugin>().get_new_address().to_string();        
        let copy_address = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let address = DataItem::new(ctx, None, "Bitcoin address", Some(&adrs), None, None, Some(vec![copy_address]));

        let copy_orange_name = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let orange_name_item = DataItem::new(ctx, None, "Orange Name", Some(orange_name.to_string().as_str()), None, None, Some(vec![copy_orange_name]));

        let temp_bio = "No bio yet.".to_string();
        let biography = user.get("biography").unwrap_or(&temp_bio);
        let about_me = DataItem::new(ctx, None, "About me", Some(&biography), None, None, None);
        let avatar = AvatarProfiles::user(ctx, orange_name);

        let username = user.get("username").unwrap();
        let header = Header::stack(ctx, Some(back), &username, None);
        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(buttons), Box::new(about_me), Box::new(orange_name_item), Box::new(address)]);

        (UserAccount(Stack::center(), Page::new(header, content, None)), false)
    }
}

#[derive(Debug, Component, AppPage)]
struct BlockUser(Stack, Page);
impl OnEvent for BlockUser {}

impl BlockUser {
    fn new(ctx: &mut Context, orange_name: &OrangeName) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(&orange_name).unwrap();

        let theme = &ctx.theme;
        let text_size = theme.fonts.size.h4;

        let account_orange_name = orange_name.clone();
        let go_account = move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &account_orange_name);
            ctx.trigger_event(NavigateEvent::new(page))
        };

        let block_orange_name = orange_name.clone();
        let confirm = Button::primary(ctx, "Block", move |ctx: &mut Context| {
            let page = UserBlocked::new(ctx, &block_orange_name);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let cancel = Button::close(ctx, "Cancel", go_account.clone());
        let back = IconButton::navigation(ctx, "left", go_account);

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
    fn new(ctx: &mut Context, orange_name: &OrangeName) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(&orange_name).unwrap();

        let theme = &ctx.theme;
        let text_size = theme.fonts.size.h4;

        let close_orange_name = orange_name.clone();
        let go_close = move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &close_orange_name);
            ctx.trigger_event(NavigateEvent::new(page))
        };

        let close = Button::close(ctx, "Done", go_close.clone());
        let bumper = Bumper::single_button(ctx, close);
        let avatar = AvatarProfiles::new_with_block(ctx, orange_name);

        let username = user.get("username").unwrap();
        let msg = format!("{} has been blocked", username);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let close = IconButton::close(ctx, go_close);

        let header = Header::stack(ctx, Some(close), "User blocked", None);
        (UserBlocked(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}

#[derive(Debug, Component, AppPage)]
struct UnblockUser(Stack, Page);
impl OnEvent for UnblockUser {}

impl UnblockUser {
    fn new(ctx: &mut Context, orange_name: &OrangeName) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(&orange_name).unwrap();

        let text_size = ctx.theme.fonts.size.h4;

        let account_orange_name = orange_name.clone();
        let go_account = move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &account_orange_name);
            ctx.trigger_event(NavigateEvent::new(page))
        };

        let unblock_orange_name = orange_name.clone();
        let confirm = Button::primary(ctx, "Unblock", move |ctx: &mut Context| {
            let page = UserUnblocked::new(ctx, &unblock_orange_name);
            ctx.trigger_event(NavigateEvent::new(page))
        });

        let cancel = Button::close(ctx, "Cancel", go_account.clone());
        let back = IconButton::navigation(ctx, "left", go_account);

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
    fn new(ctx: &mut Context, orange_name: &OrangeName) -> (Self, bool) {
        let profiles = ctx.state().get::<Profiles>();
        let user = profiles.0.get(&orange_name).unwrap();

        let text_size = ctx.theme.fonts.size.h4;

        let close_orange_name = orange_name.clone();
        let go_close = move |ctx: &mut Context| {
            let page = UserAccount::new(ctx, &close_orange_name);
            ctx.trigger_event(NavigateEvent::new(page))
        };
        
        let close = Button::close(ctx, "Done", go_close.clone());
        let bumper = Bumper::single_button(ctx, close);
        let avatar = AvatarProfiles::new_with_unblock(ctx, orange_name);

        let username = user.get("username").unwrap();
        let msg = format!("{} has been unblocked", username);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let close = IconButton::close(ctx, go_close);
        let header = Header::stack(ctx, Some(close), "User unblocked", None);
        (UserUnblocked(Stack::default(), Page::new(header, content, Some(bumper))), false)
    }
}

