use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

use pelican_ui_profiles::prelude::*;

// use ucp_rust::screens::*;
use crate::msg::CurrentProfile;
use crate::BDKPlugin;
// use crate::UCPPlugin;

use crate::GroupInfo;
use crate::DirectMessage;
use crate::Amount;

use std::sync::{Arc, Mutex};
use std::sync::mpsc::{self, Receiver, Sender};

#[derive(Debug, Component, AppPage)]
pub struct Account(Stack, Page, #[skip] bool, #[skip] Receiver<Vec<u8>>);

impl Account {
    pub fn new(ctx: &mut Context) -> Self {
        let header = Header::home(ctx, "Account");
        let (sender, receiver) = mpsc::channel();

        let avatar = Avatar::new(
            ctx,
            AvatarContent::Icon("profile", AvatarIconStyle::Secondary),
            Some(("edit", AvatarIconStyle::Secondary)),
            false,
            128.0,
            Some(Box::new(move |ctx: &mut Context| {
                ctx.open_photo_picker(sender.clone());
            })),
        );
        
        let save = Button::disabled(ctx, "Save", |_ctx: &mut Context| println!("Save changes..."));
        let bumper = Bumper::single_button(ctx, save);

        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let name_input = TextInput::new(ctx, None, Some("Name"), "Account name...", None, icon_button);
        let about_input = TextInput::new(ctx, None, Some("About me"), "About me...", None, icon_button);

        let adrs = ctx.get::<BDKPlugin>().get_new_address().to_string();        
        let copy = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let address = DataItem::new(ctx, None, "Bitcoin address", Some(&adrs), None, None, Some(vec![copy]));
        let copy = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let identity = DataItem::new(ctx, None, "Orange Identity", Some("did::nym::38iKdailTwedpr92Daixx90et"), None, None, Some(vec![copy]));

        // let get = Button::secondary(ctx, Some("credential"), "Get Credentials", None, |ctx: &mut Context| GetCredentials::navigate(ctx));
        // let credentials = DataItem::new(ctx, None, "Verifable credentials", Some("Earn trust with badges that verify you're a real person, over 18, and more."), None, None, Some(vec![get]));

        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(name_input), Box::new(about_input), Box::new(identity), Box::new(address)]);

        Account(Stack::center(), Page::new(header, content, Some(bumper)), true, receiver)
    }
}

impl OnEvent for Account {
    fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
        if let Some(TickEvent) = event.downcast_ref() {
            if let Ok(bytes) = self.3.try_recv() {
                let item = &mut *self.1.content().items()[0];
                if let Some(avatar) = item.as_any_mut().downcast_mut::<Avatar>() {
                    // println!("bytes {:?}", bytes);
                    if let Ok(dynamic) = image::load_from_memory(&bytes) {
                        let rgba_image = dynamic.to_rgba8();
                        let image = image::imageops::rotate90(&rgba_image);
                        let image = ctx.add_image(image);
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

//         let text_size = ctx.get::<PelicanUI>().theme.fonts.size.h5;
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

//         let text_size = ctx.get::<PelicanUI>().theme.fonts.size;
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
        let user = ctx.state().get::<CurrentProfile>();
        let user = user.get().clone().unwrap();

        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| GroupInfo::navigate(ctx));
        let header = Header::stack(ctx, Some(back), &user.user_name, None);

        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), None, false, 128.0, None);

        let buttons = IconButtonRow::new(ctx, vec![
            ("messages", Box::new(|ctx: &mut Context| DirectMessage::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("bitcoin", Box::new(|ctx: &mut Context| Amount::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("unblock", Box::new(|ctx: &mut Context| UnblockUser::navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
        ]);

        let adrs = ctx.get::<BDKPlugin>().get_new_address().to_string();        
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

        let theme = &ctx.get::<PelicanUI>().theme;
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

        let theme = &ctx.get::<PelicanUI>().theme;
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

        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.h4;
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
        
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.h4;
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
