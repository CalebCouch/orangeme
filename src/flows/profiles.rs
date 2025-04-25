use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

use crate::BDKPlugin;

#[derive(Debug, Copy, Clone)]
pub enum ProfilesFlow {
    Account,
    // UserProfile,
    // BlockUser,
    // UserBlocked
    // UnblockUser
    // UserUnblocked
}

impl AppFlow for ProfilesFlow {
    fn get_page(&self, ctx: &mut Context) -> Box<dyn AppPage> {
        match self {
            ProfilesFlow::Account => Box::new(Account::new(ctx)) as Box<dyn AppPage>,
            // ProfilesFlow::UserProfile => Box::new(UserProfile::new(ctx)) as Box<dyn AppPage>,
            // ProfilesFlow::BlockUser => Box::new(BlockUser::new(ctx)) as Box<dyn AppPage>,
            // ProfilesFlow::UserBlocked => Box::new(UserBlocked::new(ctx)) as Box<dyn AppPage>,
            // ProfilesFlow::UnblockUser => Box::new(UnblockUser::new(ctx)) as Box<dyn AppPage>,
            // ProfilesFlow::UserUnblocked => Box::new(UserUnblocked::new(ctx)) as Box<dyn AppPage>,
        }
    }
}

#[derive(Debug, Component)]
pub struct Account(Stack, Page);
impl OnEvent for Account {}
impl AppPage for Account { fn get(&self) -> &Page {&self.1} }

impl Account {
    pub fn new(ctx: &mut Context) -> Self {
        let header = Header::home(ctx, "Account");
        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), Some(("edit", AvatarIconStyle::Secondary)), false, 128.0);
        let save = Button::disabled(ctx, "Save", |_ctx: &mut Context| println!("Save changes..."));
        let bumper = Bumper::single_button(save);
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let name_input = TextInput::new(ctx, Some("Name"), "Account name...", None, icon_button);
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let about_input = TextInput::new(ctx, Some("About me"), "About me...", None, icon_button);

        let adrs = ctx.get::<BDKPlugin>().get_new_address().to_string();        
        let copy_address = Button::secondary(ctx, Some("copy"), "Copy", None, |ctx: &mut Context| println!("Copy"));
        let address = DataItem::new(ctx, None, "Bitcoin address", Some(Box::leak(adrs.into_boxed_str())), None, None, Some(vec![copy_address]));
        let copy_nym = Button::secondary(ctx, Some("copy"), "Copy", None, |ctx: &mut Context| println!("Copy"));
        let nym = DataItem::new(ctx, None, "Orange NYM", Some("did::nym::38iKdailTwedpr92Daixx90et"), None, None, Some(vec![copy_nym]));

        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(name_input), Box::new(about_input), Box::new(nym), Box::new(address)]);

        Account(Stack::center(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
pub struct UserProfile(Stack, Page);
impl OnEvent for UserProfile {}
impl AppPage for UserProfile { fn get(&self) -> &Page {&self.1} }

impl UserProfile {
    pub fn new(ctx: &mut Context) -> Self {
        let user = Profile {
            name: "Marge Margarine",
            nym: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln",
            about: "Probably butter.",
            avatar: AvatarContent::Icon("profile", AvatarIconStyle::Secondary),
        };

        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| crate::BitcoinFlow::Address.navigate(ctx));
        let header = Header::stack(ctx, Some(back), user.name, None);

        let avatar = Avatar::new(ctx, user.avatar, None, false, 128.0);

        let buttons = IconButtonRow::new(ctx, vec![
            ("messages", Box::new(|ctx: &mut Context| crate::MessagesFlow::DirectMessage.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("bitcoin", Box::new(|ctx: &mut Context| crate::BitcoinFlow::Amount.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            // ("block", |ctx: &mut Context| ProfilesFlow::BlockUser.navigate(ctx))
        ]);

        let adrs = ctx.get::<BDKPlugin>().get_new_address().to_string();        
        let copy_address = Button::secondary(ctx, Some("copy"), "Copy", None, |ctx: &mut Context| println!("Copy"));
        let address = DataItem::new(ctx, None, "Bitcoin address", Some(Box::leak(adrs.into_boxed_str())), None, None, Some(vec![copy_address]));

        let copy_nym = Button::secondary(ctx, Some("copy"), "Copy", None, |ctx: &mut Context| println!("Copy"));
        let nym = DataItem::new(ctx, None, "Orange NYM", Some(user.nym), None, None, Some(vec![copy_nym]));

        let about_me = DataItem::new(ctx, None, "About me", Some(user.about), None, None, None);
        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(buttons), Box::new(about_me), Box::new(nym), Box::new(address)]);

        UserProfile(Stack::center(), Page::new(header, content, None, false))
    }
}
// Add an on-click for avatar's with flair