#![allow(dead_code)]

use pelican_ui::events::{Event, OnEvent, Key, NamedKey, KeyboardState, KeyboardEvent, TickEvent};
use pelican_ui::drawable::{Drawable, Component, Align, Span, Image};
use pelican_ui::layout::{Area, SizeRequest, Layout};
use pelican_ui::{Context, Component, ImageOrientation};
use profiles::{Profile, generate_name};
use profiles::service::{Name, Profiles};
use profiles::plugin::{ProfilePlugin, ProfileRequest};

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
};

// use ucp_rust::screens::*;
// use crate::msg::CurrentProfile;
// use crate::BDKPlugin;
// use crate::UCPPlugin;

use crate::GroupInfo;
use crate::DirectMessage;
use crate::Amount;

use std::sync::mpsc::{self, Receiver};

#[derive(Debug, Component, AppPage)]
pub struct Account(Stack, Page, #[skip] bool, #[skip] Receiver<(Vec<u8>, ImageOrientation)>);

impl Account {
    pub fn new(ctx: &mut Context) -> Self {
        let orange_name = ctx.state().get::<Name>().0.unwrap();
        let profiles = ctx.state().get::<Profiles>();
        let my_profile = profiles.0.get(&orange_name).unwrap();

        let header = Header::home(ctx, "Account");
        let (sender, receiver) = mpsc::channel();

        let avatar = Avatar::new(
            ctx,
            AvatarContent::Icon("profile", AvatarIconStyle::Secondary),
            Some(("edit", AvatarIconStyle::Secondary)),
            false,
            128.0,
            Some(Box::new(move |ctx: &mut Context| {
                // ctx.open_photo_picker(sender.clone());
            })),
        );
        
        let save = Button::disabled(ctx, "Save", |_ctx: &mut Context| println!("Save changes..."));
        let bumper = Bumper::single_button(ctx, save);

        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let name_input = TextInput::new(ctx, None, Some("Name"), "Account name...", None, icon_button);
        let about_input = TextInput::new(ctx, None, Some("About me"), "About me...", None, icon_button);

        let adrs = String::new(); // ctx.get::<BDKPlugin>().get_new_address().to_string();        
        let copy = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let address = DataItem::new(ctx, None, "Bitcoin address", Some(&adrs), None, None, Some(vec![copy]));


        let copy = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let identity = DataItem::new(ctx, None, "Orange Name", Some(orange_name.to_string().as_str()), None, None, Some(vec![copy]));

        // let get = Button::secondary(ctx, Some("credential"), "Get Credentials", None, |ctx: &mut Context| GetCredentials::navigate(ctx));
        // let credentials = DataItem::new(ctx, None, "Verifable credentials", Some("Earn trust with badges that verify you're a real person, over 18, and more."), None, None, Some(vec![get]));

        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(name_input), Box::new(about_input), Box::new(identity), Box::new(address)]);

        Account(Stack::center(), Page::new(header, content, Some(bumper)), true, receiver)
    }
}

impl OnEvent for Account {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref::<TickEvent>() {
            let orange_name = ctx.state().get::<Name>().0.unwrap();
            let profiles = ctx.state().get::<Profiles>();
            let my_profile = profiles.0.get(&orange_name).unwrap();
            println!("MY PROFILE Contains {:?}", my_profile);
            let my_user_name = match my_profile.get("name") {
                Some(n) => n.to_string(),
                None => {
                    let name = generate_name(orange_name.to_string().as_str());
                    println!("Your new name is {:?}", name);
                    ctx.get::<ProfilePlugin>().request(ProfileRequest::InsertField("name".to_string(), name.clone()));
                    name
                }
            };

            println!("User name is {:?}", my_user_name);
                
            let item = &mut *self.1.content().items()[1];
            if let Some(input) = item.as_any_mut().downcast_mut::<TextInput>() {
                *input.value() = my_user_name;
                // println!("Input content is {:?}", input.value());
            }
            if let Ok((bytes, orientation)) = self.3.try_recv() {
                let item = &mut *self.1.content().items()[0];
                if let Some(avatar) = item.as_any_mut().downcast_mut::<Avatar>() {
                    // println!("bytes {:?}", bytes);
                    if let Ok(dynamic) = image::load_from_memory(&bytes) {
                        let image = dynamic.to_rgba8();
                        let image = orientation.apply_to(image::DynamicImage::ImageRgba8(image));
                        let image = ctx.assets.add_image(image.into());
                        avatar.set_content(AvatarContent::Image(image));
                    } else {
                        println!("Invalid Bytes");
                    }
                }
            }
        }
        true
    }
}


// #[derive(Debug, Component)]
// pub struct GetCredentials(Stack, Page);
// impl OnEvent for GetCredentials {}
// impl AppPage for GetCredentials {}

// impl GetCredentials {
//     pub fn new(ctx: &mut Context) -> Self {
//         ctx.get::<UCPPlugin>().set_back(Box::new(|ctx: &mut Context| GetCredentials::navigate(ctx)));
//         let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| Account::navigate(ctx));
//         let header = Header::stack(ctx, Some(back), "Get credentials", None);
        
//         let button = Button::primary(ctx, "Continue", |ctx: &mut Context| SophtronPolicy::navigate(ctx));
//         let bumper = Bumper::single_button(ctx, button);

//         let credentials = ListItemGroup::new(vec![
//             Credential::NotABot.get(ctx),
//             Credential::RealName.get(ctx),
//             Credential::USAccount.get(ctx),
//             Credential::EighteenPlus.get(ctx)
//         ]);

//         let text_size = ctx.theme.fonts.size.h5;
//         let instructions = ExpandableText::new(ctx, "Verify your information to add these verified credentials to your Orange profile:", TextStyle::Heading, text_size, Align::Center);

//         let content = Content::new(Offset::Start, vec![Box::new(instructions), Box::new(credentials)]);

//         GetCredentials(Stack::center(), Page::new(header, content, Some(bumper)))
//     }
// }

// #[derive(Debug, Component)]
// pub struct SophtronPolicy(Stack, Page);
// impl OnEvent for SophtronPolicy {}
// impl AppPage for SophtronPolicy {}

// impl SophtronPolicy {
//     pub fn new(ctx: &mut Context) -> Self {
//         ctx.get::<UCPPlugin>().set_on_return(Box::new(|ctx: &mut Context| Account::navigate(ctx))); // success

//         let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| GetCredentials::navigate(ctx));
//         let header = Header::stack(ctx, Some(back), "Get credentials", None);
        
//         let button = Button::primary(ctx, "Continue", |ctx: &mut Context| UCPFlow::SelectInstitution::navigate(ctx));
//         let bumper = Bumper::single_button(ctx, button);

//         let img = image::load_from_memory(&ctx.load_file("sophtron.png").unwrap()).unwrap();
//         let image = Image{shape: ShapeType::Rectangle(0.0, (94.0, 94.0)), image: ctx.add_image(img.into()), color: None};

//         let text_size = ctx.theme.fonts.size;
//         let instructions = ExpandableText::new(ctx, "Orange uses Sophtron to verify your credentials with your bank account.", TextStyle::Heading, text_size.h5, Align::Center);

//         let bullet_a = BulletedText::new(ctx, "Sophtron never uses or shares your data with anyone else.", TextStyle::Primary, text_size.md, Align::Left);
//         let bullet_b = BulletedText::new(ctx, "Sophtron will retrieve your data only once. After issuing your credentials, the data Sophtron accesses will be deleted.", TextStyle::Primary, text_size.md, Align::Left);
//         let bullet_c = BulletedText::new(ctx, "Sophtron will never use or sell your data even in an anonymized form.", TextStyle::Primary, text_size.md, Align::Left);
//         let content = Content::new(Offset::Start, vec![Box::new(image), Box::new(instructions), Box::new(bullet_a), Box::new(bullet_b), Box::new(bullet_c)]);

//         SophtronPolicy(Stack::center(), Page::new(header, content, Some(bumper)))
//     }
// }

#[derive(Debug, Component, AppPage)]
pub struct UserAccount(Stack, Page, #[skip] bool);
impl OnEvent for UserAccount {}

impl UserAccount {
    pub fn new(ctx: &mut Context) -> Self {
        // let user = ctx.state().get::<CurrentProfile>();
        let user = example_user(); // user.get().clone().unwrap();

        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| GroupInfo::navigate(ctx));
        let header = Header::stack(ctx, Some(back), &user.user_name, None);

        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), None, false, 128.0, None);

        let buttons = IconButtonRow::new(ctx, vec![
            ("messages", Box::new(|ctx: &mut Context| DirectMessage::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("bitcoin", Box::new(|ctx: &mut Context| Amount::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("unblock", Box::new(|ctx: &mut Context| UnblockUser::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
        ]);

        let adrs = String::new(); //ctx.get::<BDKPlugin>().get_new_address().to_string();        
        let copy_address = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let address = DataItem::new(ctx, None, "Bitcoin address", Some(&adrs), None, None, Some(vec![copy_address]));

        let copy_nym = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let nym = DataItem::new(ctx, None, "Orange Identity", Some(&user.identifier), None, None, Some(vec![copy_nym]));

        let about_me = DataItem::new(ctx, None, "About me", Some(&user.biography), None, None, None);
        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(buttons), Box::new(about_me), Box::new(nym), Box::new(address)]);

        UserAccount(Stack::center(), Page::new(header, content, None), false)
    }
}

#[derive(Debug, Component, AppPage)]
struct BlockUser(Stack, Page, #[skip] bool);
impl OnEvent for BlockUser {}

impl BlockUser {
    fn new(ctx: &mut Context) -> Self {
        let user = Profile {
            user_name: "Marge Margarine".to_string(),
            identifier: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln".to_string(),
            biography: "Probably butter.".to_string(),
            blocked_dids: Vec::new()
        };

        let theme = &ctx.theme;
        let text_size = theme.fonts.size.h4;
        let cancel = Button::close(ctx, "Cancel", |ctx: &mut Context| UserAccount::navigate(ctx));
        let confirm = Button::primary(ctx, "Block", |ctx: &mut Context| UserBlocked::navigate(ctx));
        let bumper = Bumper::double_button(ctx, cancel, confirm);

        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), 
            Some(("block", AvatarIconStyle::Danger)), false, 96.0, None
        );

        let msg = format!("Are you sure you want to block {}?", user.user_name);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| UserAccount::navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Block user", None);
        BlockUser(Stack::default(), Page::new(header, content, Some(bumper)), false)
    }
}

#[derive(Debug, Component, AppPage)]
struct UserBlocked(Stack, Page, #[skip] bool);
impl OnEvent for UserBlocked {}

impl UserBlocked {
    fn new(ctx: &mut Context) -> Self {
        let user = Profile {
            user_name: "Marge Margarine".to_string(),
            identifier: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln".to_string(),
            biography: "Probably butter.".to_string(),
            blocked_dids: Vec::new()
        };

        let theme = &ctx.theme;
        let text_size = theme.fonts.size.h4;
        let close = Button::close(ctx, "Done", |ctx: &mut Context| UserAccount::navigate(ctx));
        let bumper = Bumper::single_button(ctx, close);

        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), 
            Some(("block", AvatarIconStyle::Danger)), false, 96.0, None
        );

        let msg = format!("{} has been blocked", user.user_name);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let close = IconButton::close(ctx, |ctx: &mut Context| UserAccount::navigate(ctx));
        let header = Header::stack(ctx, Some(close), "User blocked", None);
        UserBlocked(Stack::default(), Page::new(header, content, Some(bumper)), false)
    }
}

#[derive(Debug, Component, AppPage)]
struct UnblockUser(Stack, Page, #[skip] bool);
impl OnEvent for UnblockUser {}

impl UnblockUser {
    fn new(ctx: &mut Context) -> Self {
        let user = Profile {
            user_name: "Marge Margarine".to_string(),
            identifier: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln".to_string(),
            biography: "Probably butter.".to_string(),
            blocked_dids: Vec::new()
        };

        let text_size = ctx.theme.fonts.size.h4;
        let cancel = Button::close(ctx, "Cancel", |ctx: &mut Context| UserAccount::navigate(ctx));
        let confirm = Button::primary(ctx, "Unblock", |ctx: &mut Context| UserUnblocked::navigate(ctx));
        let bumper = Bumper::double_button(ctx, cancel, confirm);
        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), 
            Some(("unblock", AvatarIconStyle::Success)), false, 96.0, None
        );        
        let msg = format!("Are you sure you want to unblock {}?", user.user_name);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| UserAccount::navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Unblock user", None);
        UnblockUser(Stack::default(), Page::new(header, content, Some(bumper)), false)
    }
}

#[derive(Debug, Component, AppPage)]
struct UserUnblocked(Stack, Page, #[skip] bool);
impl OnEvent for UserUnblocked {}

impl UserUnblocked {
    fn new(ctx: &mut Context) -> Self {
        let user = Profile {
            user_name: "Marge Margarine".to_string(),
            identifier: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln".to_string(),
            biography: "Probably butter.".to_string(),
            blocked_dids: Vec::new()
        };
        
        let text_size = ctx.theme.fonts.size.h4;
        let close = Button::close(ctx, "Done", |ctx: &mut Context| UserAccount::navigate(ctx));
        let bumper = Bumper::single_button(ctx, close);
        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), 
            Some(("unblock", AvatarIconStyle::Success)), false, 96.0, None
        );
        let msg = format!("{} has been unblocked", user.user_name);
        let text = ExpandableText::new(ctx, &msg, TextStyle::Heading, text_size, Align::Center);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let close = IconButton::close(ctx, |ctx: &mut Context| UserAccount::navigate(ctx));
        let header = Header::stack(ctx, Some(close), "User unblocked", None);
        UserUnblocked(Stack::default(), Page::new(header, content, Some(bumper)), false)
    }
}

fn example_user() -> Profile {
    Profile {
        user_name: "Marge Margarine".to_string(),
        biography: "Probably butter.".to_string(),
        identifier: "did::id::12345".to_string(),
        blocked_dids: Vec::new(),
    }
}