use pelican_ui::prelude::*;
use rust_on_rails::prelude::*;
mod bitcoin;
pub use bitcoin::*;
mod messages;
pub use messages::*;
mod profiles;
pub use profiles::*;

// #[derive(Copy, Clone, Debug)]
// pub enum AppPage {
//     /* [ Bitcoin ] */
//     BitcoinHome,
//     ViewTransaction,
//     Receive,
//     Address,
//     ScanQR,
//     SelectContact,
//     Amount,
//     Speed,
//     Confirm,
//     Success,

//     /* [ Messages ] */
//     MessagesHome,
//     SelectRecipients,
//     DirectMessage,
//     GroupMessage,
//     GroupInfo,

//     /* [ Profiles ] */
//     MyProfile,
//     UserProfile,
//     BlockUser,
//     UserBlocked,
// }

// impl AppPage {
// pub fn navigate(self, ctx: &mut Context) {
//     ctx.trigger_event(NavigateEvent::<AppPage>(self));
// }