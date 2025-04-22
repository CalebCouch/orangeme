use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

#[derive(Debug, Clone, Copy)]
pub struct MessagesHome;

impl PageName for MessagesHome {
    fn build_page(&self, ctx: &mut Context) -> Page {
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
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size, Align::Center);

        let content = if messages.len() > 0 {
            let messages_group = ListItemGroup::new(messages);
            Content::new(Offset::Start, vec![Box::new(messages_group)])
        } else {
            Content::new(Offset::Center, vec![Box::new(instructions)])
        };

        let header = Header::home(ctx, "Messages");
        Page::new(header, content, Some(bumper), true)
    }
}


#[derive(Debug, Clone, Copy)]
pub struct SelectRecipients;

impl PageName for SelectRecipients {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let icon_button = None::<(&'static str, fn(&mut Context, &mut String))>;
        let searchbar = TextInput::new(ctx, None, "Profile name...", None, icon_button);

        let recipients = vec![
            ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Anne Eave", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln"),
            ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Bob David", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln"),
            ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Charlie Charles", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln"),
            ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Danielle Briebs", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln"),
            ListItem::recipient(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), "Ethan Hayes", "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln")
        ];

        let quick_deselect = QuickDeselect::new(recipients);

        let content = Content::new(Offset::Start, vec![Box::new(searchbar), Box::new(quick_deselect)]);

        let back = IconButton::navigation(ctx, "left", None, |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::stack(ctx, Some(back), "Send to contact", None);
        Page::new(header, content, None, false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct DirectMessage;

impl PageName for DirectMessage {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let input = TextInput::new(ctx, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(vec![Box::new(input)]);

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
            "Do you have butter?"
        ];

        let message = Message::new(ctx, MessageType::Contact, messages, contact.clone(), "6:24 AM");

        let content = Content::new(Offset::End, vec![Box::new(message)]);

        let back = IconButton::navigation(ctx, "left", None, |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::chat(ctx, Some(back), None, vec![contact.avatar]);
        Page::new(header, content, None, false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct GroupMessage;

impl PageName for GroupMessage {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let input = TextInput::new(ctx, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(vec![Box::new(input)]);

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
            "Do you have butter?"
        ];

        let message = Message::new(ctx, MessageType::Contact, messages, contact.clone(), "6:24 AM");

        let content = Content::new(Offset::End, vec![Box::new(message)]);

        let back = IconButton::navigation(ctx, "left", None, |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::chat(ctx, Some(back), None, vec![contact.avatar]);
        Page::new(header, content, None, false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct GroupInfo;

impl PageName for GroupInfo {
    fn build_page(&self, ctx: &mut Context) -> Page {
        let input = TextInput::new(ctx, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(vec![Box::new(input)]);

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
            "Do you have butter?"
        ];

        let message = Message::new(ctx, MessageType::Contact, messages, contact.clone(), "6:24 AM");

        let content = Content::new(Offset::End, vec![Box::new(message)]);

        let back = IconButton::navigation(ctx, "left", None, |_ctx: &mut Context| println!("Go Back!"));
        let header = Header::chat(ctx, Some(back), None, vec![contact.avatar]);
        Page::new(header, content, None, false)
    }
}