use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

#[derive(Debug, Copy, Clone)]
pub enum MessagesFlow {
    MessagesHome,
    SelectRecipients,
    DirectMessage,
    GroupMessage,
    GroupInfo,
}

impl AppFlow for MessagesFlow {
    fn get_page(&self, ctx: &mut Context) -> Box<dyn AppPage> {
        match self {
            MessagesFlow::MessagesHome => Box::new(MessagesHome::new(ctx)) as Box<dyn AppPage>,
            MessagesFlow::SelectRecipients => Box::new(SelectRecipients::new(ctx)) as Box<dyn AppPage>,
            MessagesFlow::DirectMessage => Box::new(DirectMessage::new(ctx)) as Box<dyn AppPage>,
            MessagesFlow::GroupMessage => Box::new(GroupMessage::new(ctx)) as Box<dyn AppPage>,
            MessagesFlow::GroupInfo => Box::new(GroupInfo::new(ctx)) as Box<dyn AppPage>,
        }
    }
}

#[derive(Debug, Component)]
pub struct MessagesHome(Stack, Page);
impl OnEvent for MessagesHome {}
impl AppPage for MessagesHome {}

impl MessagesHome {
    pub fn new(ctx: &mut Context) -> Self {
        let header = Header::home(ctx, "Messages");
        let new_message = Button::primary(ctx, "New Message", |ctx: &mut Context| MessagesFlow::SelectRecipients.navigate(ctx));
        let bumper = Bumper::single_button(new_message);
        let messages = Vec::new();
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size, Align::Center);

        let content = if messages.len() > 0 {
            let messages_group = ListItemGroup::new(messages);
            Content::new(Offset::Start, vec![Box::new(messages_group)])
        } else {
            Content::new(Offset::Center, vec![Box::new(instructions)])
        };

        MessagesHome(Stack::center(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
pub struct SelectRecipients(Stack, Page);
impl OnEvent for SelectRecipients {}
impl AppPage for SelectRecipients {}

impl SelectRecipients {
    pub fn new(ctx: &mut Context) -> Self {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, None, "Profile name...", None, icon_button);
        let quick_deselect = QuickDeselect::new(get_recipients(ctx));
        let content = Content::new(Offset::Start, vec![Box::new(searchbar), Box::new(quick_deselect)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| MessagesFlow::MessagesHome.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        let continue_btn = Button::primary(ctx, "Continue", |ctx: &mut Context| MessagesFlow::GroupMessage.navigate(ctx));
        let bumper = Bumper::single_button(continue_btn);
        SelectRecipients(Stack::center(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
pub struct DirectMessage(Stack, Page);
impl OnEvent for DirectMessage {}
impl AppPage for DirectMessage {}

impl DirectMessage {
    pub fn new(ctx: &mut Context) -> Self {
        let contact = Profile {
            name: "Marge Margarine",
            nym: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln",
            about: "Probably butter.",
            avatar: AvatarContent::Icon("profile", AvatarIconStyle::Secondary),
        };

        let messages = vec![
            "Did you go to the market on Saturday?",
            "Hello!?",
            "I need butter from the market that was on Saturday, but I couldn't go!",
            "🧈 🧈 🧈",
            "Do you have butter?"
        ];

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(vec![Box::new(input)]);
        let message = Message::new(ctx, MessageType::Contact, messages, contact.clone(), "6:24 AM");
        let content = Content::new(Offset::End, vec![Box::new(message)]);
        let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::chat(ctx, Some(back), None, vec![contact.avatar]);
        DirectMessage(Stack::center(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
pub struct GroupMessage(Stack, Page);
impl OnEvent for GroupMessage {}
impl AppPage for GroupMessage {}

impl GroupMessage {
    pub fn new(ctx: &mut Context) -> Self {
        let contact = Profile {
            name: "Marge Margarine",
            nym: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln",
            about: "Probably butter.",
            avatar: AvatarContent::Icon("profile", AvatarIconStyle::Secondary),
        };

        let messages = vec![
            "Did you go to the market on Saturday?",
            "Hello!?",
            "I need butter from the market that was on Saturday, but I couldn't go!",
            "🧈 🧈 🧈",
            "Do you have butter?"
        ];

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(vec![Box::new(input)]);
        let message = Message::new(ctx, MessageType::Contact, messages, contact.clone(), "6:24 AM");
        let content = Content::new(Offset::End, vec![Box::new(message)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| MessagesFlow::MessagesHome.navigate(ctx));
        let info = IconButton::navigation(ctx, "info", |ctx: &mut Context| MessagesFlow::GroupInfo.navigate(ctx));
        let header = Header::chat(ctx, Some(back), Some(info), vec![contact.avatar]);
        GroupMessage(Stack::center(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
pub struct GroupInfo(Stack, Page);
impl OnEvent for GroupInfo {}
impl AppPage for GroupInfo {}

impl GroupInfo {
    pub fn new(ctx: &mut Context) -> Self {
        let contacts = get_contacts(ctx);
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
        let members = format!("This group has {} members.", contacts.len());
        let members = Box::leak(members.into_boxed_str());
        let text = Text::new(ctx, members, TextStyle::Secondary, text_size, Align::Center);
        let content = Content::new(Offset::Start, vec![Box::new(text), Box::new(ListItemGroup::new(contacts))]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context| MessagesFlow::GroupMessage.navigate(ctx));
        let header = Header::stack(ctx, Some(back), "Group Message Info", None);
        GroupInfo(Stack::center(), Page::new(header, content, None, false))
    }
}

pub fn get_recipients(ctx: &mut Context) -> Vec<ListItem> {
    vec![
        ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Anne Eave", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln"),
        ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Bob David", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln"),
        ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Charlie Charles", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln"),
        ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Danielle Briebs", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln"),
        ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Ethan Hayes", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln")
    ]
}

pub fn get_contacts(ctx: &mut Context) -> Vec<ListItem> {
    vec![
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Anne Eave", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| crate::ProfilesFlow::UserProfile.navigate(ctx)),
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Bob David", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| crate::ProfilesFlow::UserProfile.navigate(ctx)),
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Charlie Charles", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| crate::ProfilesFlow::UserProfile.navigate(ctx)),
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Danielle Briebs", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| crate::ProfilesFlow::UserProfile.navigate(ctx)),
        ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Ethan A.", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| crate::ProfilesFlow::UserProfile.navigate(ctx))
    ]
}