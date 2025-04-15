use pelican_ui::prelude::*;
use rust_on_rails::prelude::*;
mod bitcoin;
pub use bitcoin::*;
mod messages;
pub use messages::*;
mod profiles;
pub use profiles::*;

#[derive(Copy, Clone, Debug)]
pub enum AppPage {
    /* [ Bitcoin ] */
    BitcoinHome,
    ViewTransaction,
    Receive,
    Address,
    ScanQR,
    SelectContact,
    Amount,
    Speed,
    Confirm,
    Success,

    /* [ Messages ] */
    MessagesHome,
    SelectRecipients,
    DirectMessage,
    GroupMessage,
    GroupInfo,

    /* [ Profiles ] */
    MyProfile,
    UserProfile,
    BlockUser,
    UserBlocked,
}

impl Application for AppPage {
    type ApplicationPage = AppPage;
}

impl AppPage {
    pub fn navigate(self, ctx: &mut Context) {
        ctx.trigger_event(NavigateEvent::<AppPage>(self));
    }
}

impl ApplicationPages for AppPage {
    fn build_screen(&self, ctx: &mut Context) -> Page {
        match self {
            AppPage::BitcoinHome => bitcoin_home(ctx),
            AppPage::ViewTransaction => view_transaction(ctx),
            AppPage::Receive => receive(ctx),
            AppPage::Address => address(ctx),
            AppPage::ScanQR => scan_qr(ctx),
            AppPage::SelectContact => select_contact(ctx),
            AppPage::Amount => amount(ctx),
            AppPage::Speed => speed(ctx),
            AppPage::Confirm => confirm(ctx),
            AppPage::Success => success(ctx),
    
            AppPage::MessagesHome => messages_home(ctx),
            AppPage::SelectRecipients => select_recipients(ctx),
            AppPage::DirectMessage => direct_message(ctx),
            AppPage::GroupMessage => group_message(ctx),
            AppPage::GroupInfo => group_info(ctx),
    
            AppPage::MyProfile => my_profile(ctx),
            AppPage::UserProfile => user_profile(ctx),
            AppPage::BlockUser => block_user(ctx),
            AppPage::UserBlocked => user_blocked(ctx),
        }
    }    
}

// pub struct MessageHome(Page);
// pub struct ProfileHome(Page);
// pub struct BitcoinHome(Page);

// pub struct ViewTransaction(Page);
// pub struct Receive(Page);

// pub struct Address(Page);
// pub struct ScanQR(Page);
// pub struct SelectContact(Page);

// pub struct Amount(Page);
// pub struct Speed(Page);
// pub struct Connfirm(Page);
// pub struct Success(Page);

// pub struct SelectRecipients(Page);

// pub struct DirectMessage(Page);

// pub struct GroupMessage(Page);
// pub struct GroupMessageInfo(Page);

// pub struct UserProfile(Page);

// pub struct BlockUser(Page);
// pub struct UserBlocked(Page);