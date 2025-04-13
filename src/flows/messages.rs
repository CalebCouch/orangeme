use rust_on_rails::prelude::*;
use rust_on_rails::prelude::Text as BasicText;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

pub struct MessagesHome(Page);

impl MessagesHome {
    pub fn new(ctx: &mut Context) -> Self {
        let new_message = Button::primary(ctx, "New Message", |_ctx: &mut Context| println!("New..."));
        let bumper = Bumper::new(vec![Box::new(new_message)]);

        // let messages = vec![
        //     ListItem::direct_message(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Ella Couch", "How has it been being so dang dum", |_: &mut Context|()),
        //     ListItem::group_message(ctx, vec!["Evan Mcmaine", "Ethan Hayes", "Marge Margarine", "Ella Couch"], |_: &mut Context|()),
        //     ListItem::direct_message(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Marge Margarine", "How has it been being so dang dum", |_: &mut Context|()),
        //     ListItem::direct_message(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Robert H.", "How has it been being so dang dum", |_: &mut Context|()),
        // ];

        let messages = Vec::new();
        let text_size = ctx.get::<PelicanUI>().theme.fonts.size.md;
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size);
    
        let content = if messages.len() > 0 {
            let messages_group = ListItemGroup::new(ctx, messages);
            Content::new(Offset::Start, vec![Box::new(messages_group)])
        } else {
            Content::new(Offset::Center, vec![Box::new(instructions)])
        };

        let header = Header::home(ctx, "Messages");
        MessagesHome(Page::new(header, content, Some(bumper)))
    }

    pub fn page(self) -> Page {self.0}
}


// struct NewMessageFlow(SelectRecipients, Option<DirectMessageFlow>, Option<GroupMessageFlow>);

// impl NewMessageFlow {
//     pub fn new(is_group: bool) -> Self {
//         let (direct, group) = match is_group {
//             true => (None, Some(GroupMessageFlow::new())),
//             false => (Some(DirectMessageFlow::new(), None))
//         };
//         NewMessageFlow(direct, group)
//     }
// }

pub struct SelectRecipients(Page);

impl SelectRecipients {
    pub fn new(ctx: &mut Context) -> Self {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, "Profile name...", None, icon_button);

        let contacts = vec![
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Anne Eave", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| ctx.trigger_event(AddContactEvent("Anne Eave"))),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Bob David", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| ctx.trigger_event(AddContactEvent("Bob David"))),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Charlie Charles", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| ctx.trigger_event(AddContactEvent("Charlie Charles"))),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Danielle Briebs", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| ctx.trigger_event(AddContactEvent("Danielle Briebs"))),
            ListItem::contact(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Ethan Hayes", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln", |ctx: &mut Context| ctx.trigger_event(AddContactEvent("Ethan Hayes")))
        ];

        let quick_deselect = QuickDeselect::new(ctx, contacts);

        let content = Content::new(Offset::Start, vec![Box::new(searchbar), Box::new(quick_deselect)]);

        let back = IconButton::navigation(ctx, "left", |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        SelectRecipients(Page::new(header, content, None))
    } // REMOVE TAB NAV - WE ARE IN A FLOW

    pub fn page(self) -> Page {self.0}
}

// struct DirectMessageFlow(DirectMessage);


pub struct DirectMessage(Page);



// struct GroupMessageFlow(GroupMessage, GroupMessageInfo);


pub struct GroupMessage(Page);



pub struct GroupMessageInfo(Page);

