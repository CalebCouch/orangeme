use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

use pelican_ui_profiles::prelude::*;
use pelican_ui_bitcoin::prelude::*;
use pelican_ui_messages::prelude::*;

use ucp_rust::screens::*;
use crate::BDKPlugin;
use crate::UCPPlugin;

#[derive(Debug, Copy, Clone)]
pub enum AccountsFlow {
    Account,
    GetCredentials,
    SophtronPolicy,
    UserAccount,
    BlockUser,
    UserBlocked,
    UnblockUser,
    UserUnblocked,
}

impl AppFlow for AccountsFlow {
    fn get_page(&self, ctx: &mut Context) -> (Box<dyn AppPage>, bool) {
        match self {
            AccountsFlow::Account => (Box::new(Account::new(ctx)) as Box<dyn AppPage>, true),
            AccountsFlow::GetCredentials => (Box::new(GetCredentials::new(ctx)) as Box<dyn AppPage>, false),
            AccountsFlow::SophtronPolicy => (Box::new(SophtronPolicy::new(ctx)) as Box<dyn AppPage>, false),
            AccountsFlow::UserAccount => (Box::new(UserAccount::new(ctx)) as Box<dyn AppPage>, false),
            AccountsFlow::BlockUser => (Box::new(BlockUser::new(ctx)) as Box<dyn AppPage>, false),
            AccountsFlow::UserBlocked => (Box::new(UserBlocked::new(ctx)) as Box<dyn AppPage>, false),
            AccountsFlow::UnblockUser => (Box::new(UnblockUser::new(ctx)) as Box<dyn AppPage>, false),
            AccountsFlow::UserUnblocked => (Box::new(UserUnblocked::new(ctx)) as Box<dyn AppPage>, false),
        }
    }
}

#[derive(Debug, Component)]
pub struct Account(Stack, Page);
impl OnEvent for Account {}
impl AppPage for Account {}

impl Account {
    pub fn new(ctx: &mut Context) -> Self {
        let header = Header::home(ctx, "Account");
        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), Some(("edit", AvatarIconStyle::Secondary)), false, 128.0, None);
        
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

        let get = Button::secondary(ctx, Some("credential"), "Get Credentials", None, |ctx: &mut Context| AccountsFlow::GetCredentials.navigate(ctx));
        let credentials = DataItem::new(ctx, None, "Verifable credentials", Some("Earn trust with badges that verify you're a real person, over 18, and more."), None, None, Some(vec![get]));

        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(name_input), Box::new(about_input), Box::new(credentials), Box::new(identity), Box::new(address)]);

        Account(Stack::center(), Page::new(header, content, Some(bumper)))
    }
}

#[derive(Debug, Component)]
pub struct GetCredentials(Stack, Page);
impl OnEvent for GetCredentials {}
impl AppPage for GetCredentials {}

impl GetCredentials {
    pub fn new(ctx: &mut Context) -> Self {
        ctx.get::<UCPPlugin>().set_back(Box::new(|ctx: &mut Context| AccountsFlow::GetCredentials.navigate(ctx)));
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| AccountsFlow::Account.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Get credentials", None);
        
        let button = Button::primary(ctx, "Continue", |ctx: &mut Context| AccountsFlow::SophtronPolicy.navigate(ctx));
        let bumper = Bumper::single_button(ctx, button);

        let credentials = ListItemGroup::new(vec![
            Credential::NotABot.get(ctx),
            Credential::RealName.get(ctx),
            Credential::USAccount.get(ctx),
            Credential::EighteenPlus.get(ctx)
        ]);

        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.h5;
        let instructions = ExpandableText::new(ctx, "Verify your information to add these verified credentials to your Orange profile:", TextStyle::Heading, text_size, Align::Center);

        let content = Content::new(Offset::Start, vec![Box::new(instructions), Box::new(credentials)]);

        GetCredentials(Stack::center(), Page::new(header, content, Some(bumper)))
    }
}

#[derive(Debug, Component)]
pub struct SophtronPolicy(Stack, Page);
impl OnEvent for SophtronPolicy {}
impl AppPage for SophtronPolicy {}

impl SophtronPolicy {
    pub fn new(ctx: &mut Context) -> Self {
        ctx.get::<UCPPlugin>().set_on_return(Box::new(|ctx: &mut Context| AccountsFlow::Account.navigate(ctx))); // success

        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| AccountsFlow::GetCredentials.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Get credentials", None);
        
        let button = Button::primary(ctx, "Continue", |ctx: &mut Context| UCPFlow::SelectInstitution.navigate(ctx));
        let bumper = Bumper::single_button(ctx, button);

        let img = image::load_from_memory(&ctx.load_file("sophtron.png").unwrap()).unwrap();
        let image = Image{shape: ShapeType::Rectangle(0.0, (94.0, 94.0)), image: ctx.add_image(img.into()), color: None};

        let text_size = ctx.get::<PelicanUI>().theme.fonts.size;
        let instructions = ExpandableText::new(ctx, "Orange uses Sophtron to verify your credentials with your bank account.", TextStyle::Heading, text_size.h5, Align::Center);

        let bullet_a = BulletedText::new(ctx, "Sophtron never uses or shares your data with anyone else.", TextStyle::Primary, text_size.md, Align::Left);
        let bullet_b = BulletedText::new(ctx, "Sophtron will retrieve your data only once. After issuing your credentials, the data Sophtron accesses will be deleted.", TextStyle::Primary, text_size.md, Align::Left);
        let bullet_c = BulletedText::new(ctx, "Sophtron will never use or sell your data even in an anonymized form.", TextStyle::Primary, text_size.md, Align::Left);
        let content = Content::new(Offset::Start, vec![Box::new(image), Box::new(instructions), Box::new(bullet_a), Box::new(bullet_b), Box::new(bullet_c)]);

        SophtronPolicy(Stack::center(), Page::new(header, content, Some(bumper)))
    }
}

#[derive(Debug, Component)]
pub struct UserAccount(Stack, Page);
impl OnEvent for UserAccount {}
impl AppPage for UserAccount {}

impl UserAccount {
    pub fn new(ctx: &mut Context) -> Self {
        let user = Profile {
            user_name: "Marge Margarine".to_string(),
            identifier: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln".to_string(),
            biography: "Probably butter.".to_string(),
            blocked_dids: Vec::new()
        };

        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| crate::MessagesFlow::GroupInfo.navigate(ctx));
        let header = Header::stack(ctx, Some(back), &user.user_name, None);

        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), None, false, 128.0, None);

        let buttons = IconButtonRow::new(ctx, vec![
            ("messages", Box::new(|ctx: &mut Context| crate::MessagesFlow::DirectMessage.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("bitcoin", Box::new(|ctx: &mut Context| crate::BitcoinFlow::Amount.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("unblock", Box::new(|ctx: &mut Context| crate::AccountsFlow::UnblockUser.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
        ]);

        let adrs = ctx.get::<BDKPlugin>().get_new_address().to_string();        
        let copy_address = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let address = DataItem::new(ctx, None, "Bitcoin address", Some(&adrs), None, None, Some(vec![copy_address]));

        let copy_nym = Button::secondary(ctx, Some("copy"), "Copy", None, |_ctx: &mut Context| println!("Copy"));
        let nym = DataItem::new(ctx, None, "Orange Identity", Some(&user.identifier), None, None, Some(vec![copy_nym]));

        let about_me = DataItem::new(ctx, None, "About me", Some(&user.biography), None, None, None);
        let content = Content::new(Offset::Start, vec![Box::new(avatar), Box::new(buttons), Box::new(about_me), Box::new(nym), Box::new(address)]);

        UserAccount(Stack::center(), Page::new(header, content, None))
    }
}

#[derive(Debug, Component)]
struct BlockUser(Stack, Page);
impl OnEvent for BlockUser {}
impl AppPage for BlockUser {}
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
        let cancel = Button::close(ctx, "Cancel", |ctx: &mut Context| AccountsFlow::UserAccount.navigate(ctx));
        let confirm = Button::primary(ctx, "Block", |ctx: &mut Context| AccountsFlow::UserBlocked.navigate(ctx));
        let bumper = Bumper::double_button(ctx, cancel, confirm);

        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), 
            Some(("block", AvatarIconStyle::Danger)), false, 96.0, None
        );

        let msg = format!("Are you sure you want to block {}?", user.user_name);
        let text = Text::new(ctx, &msg, TextStyle::Heading, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| AccountsFlow::UserAccount.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Block user", None);
        BlockUser(Stack::default(), Page::new(header, content, Some(bumper)))
    }
}

#[derive(Debug, Component)]
struct UserBlocked(Stack, Page);
impl OnEvent for UserBlocked {}
impl AppPage for UserBlocked {}
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
        let close = Button::close(ctx, "Done", |ctx: &mut Context| AccountsFlow::UserAccount.navigate(ctx));
        let bumper = Bumper::single_button(ctx, close);

        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), 
            Some(("block", AvatarIconStyle::Danger)), false, 96.0, None
        );

        let msg = format!("{} has been blocked", user.user_name);
        let text = Text::new(ctx, &msg, TextStyle::Heading, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let close = IconButton::close(ctx, |ctx: &mut Context| AccountsFlow::UserAccount.navigate(ctx));
        let header = Header::stack(ctx, Some(close), "User blocked", None);
        UserBlocked(Stack::default(), Page::new(header, content, Some(bumper)))
    }
}

#[derive(Debug, Component)]
struct UnblockUser(Stack, Page);
impl OnEvent for UnblockUser {}
impl AppPage for UnblockUser {}
impl UnblockUser {
    fn new(ctx: &mut Context) -> Self {
        let user = Profile {
            user_name: "Marge Margarine".to_string(),
            identifier: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln".to_string(),
            biography: "Probably butter.".to_string(),
            blocked_dids: Vec::new()
        };

        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.h4;
        let cancel = Button::close(ctx, "Cancel", |ctx: &mut Context| AccountsFlow::UserAccount.navigate(ctx));
        let confirm = Button::primary(ctx, "Unblock", |ctx: &mut Context| AccountsFlow::UserUnblocked.navigate(ctx));
        let bumper = Bumper::double_button(ctx, cancel, confirm);
        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), 
            Some(("unblock", AvatarIconStyle::Success)), false, 96.0, None
        );        
        let msg = format!("Are you sure you want to unblock {}?", user.user_name);
        let text = Text::new(ctx, &msg, TextStyle::Heading, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| AccountsFlow::UserAccount.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Unblock user", None);
        UnblockUser(Stack::default(), Page::new(header, content, Some(bumper)))
    }
}

#[derive(Debug, Component)]
struct UserUnblocked(Stack, Page);
impl OnEvent for UserUnblocked {}
impl AppPage for UserUnblocked {}
impl UserUnblocked {
    fn new(ctx: &mut Context) -> Self {
        let user = Profile {
            user_name: "Marge Margarine".to_string(),
            identifier: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln".to_string(),
            biography: "Probably butter.".to_string(),
            blocked_dids: Vec::new()
        };
        
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.h4;
        let close = Button::close(ctx, "Done", |ctx: &mut Context| AccountsFlow::UserAccount.navigate(ctx));
        let bumper = Bumper::single_button(ctx, close);
        let avatar = Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), 
            Some(("unblock", AvatarIconStyle::Success)), false, 96.0, None
        );
        let msg = format!("{} has been unblocked", user.user_name);
        let text = Text::new(ctx, &msg, TextStyle::Heading, text_size, Align::Left);
        let content = Content::new(Offset::Center, vec![Box::new(avatar), Box::new(text)]);
        let close = IconButton::close(ctx, |ctx: &mut Context| AccountsFlow::UserAccount.navigate(ctx));
        let header = Header::stack(ctx, Some(close), "User unblocked", None);
        UserUnblocked(Stack::default(), Page::new(header, content, Some(bumper)))
    }
}
