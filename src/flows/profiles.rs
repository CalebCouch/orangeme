use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;

#[derive(Debug, Clone, Copy)]
pub struct MyProfile;

impl PageName for MyProfile {
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
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size);

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
pub struct UserProfile;

impl PageName for UserProfile {
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
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size);

        let content = if messages.len() > 0 {
            let messages_group = ListItemGroup::new(messages);
            Content::new(Offset::Start, vec![Box::new(messages_group)])
        } else {
            Content::new(Offset::Center, vec![Box::new(instructions)])
        };

        let header = Header::home(ctx, "Messages");
        Page::new(header, content, Some(bumper), false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct BlockUser;

impl PageName for BlockUser {
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
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size);

        let content = if messages.len() > 0 {
            let messages_group = ListItemGroup::new(messages);
            Content::new(Offset::Start, vec![Box::new(messages_group)])
        } else {
            Content::new(Offset::Center, vec![Box::new(instructions)])
        };

        let header = Header::home(ctx, "Messages");
        Page::new(header, content, Some(bumper), false)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct UserBlocked;

impl PageName for UserBlocked {
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
        let instructions = Text::new(ctx, "No messages yet.\nGet started by messaging a friend.", TextStyle::Secondary, text_size);

        let content = if messages.len() > 0 {
            let messages_group = ListItemGroup::new(messages);
            Content::new(Offset::Start, vec![Box::new(messages_group)])
        } else {
            Content::new(Offset::Center, vec![Box::new(instructions)])
        };

        let header = Header::home(ctx, "Messages");
        Page::new(header, content, Some(bumper), false)
    }
}