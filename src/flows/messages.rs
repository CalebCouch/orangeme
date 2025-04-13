use rust_on_rails::prelude::*;

struct MessagesHome(Page);

impl MessagesHome {
    pub fn new() -> Self {
        MessagesHome(
            // Header::home(ctx, "Messages"),
            // ListItemGroup(messages)
            // Bumper("Create new message")
        )
    }
}

struct NewMessageFlow(SelectRecipients, Option<DirectMessageFlow>, Option<GroupMessageFlow>);

impl NewMessageFlow {
    pub fn new(is_group: bool) -> Self {
        let (direct, group) = match is_group {
            true => (None, Some(GroupMessageFlow::new())),
            false => (Some(DirectMessageFlow::new(), None))
        };
        NewMessageFlow(direct, group)
    }
}

struct SelectRecipients(Page);

impl SelectRecipients {
    pub fn new() -> Self {
        SelectRecipients(
            Page::new(
                // Header::stack(ctx, Some(back), "Select recipients", None),
                // Searchbar
                // ListItemGroup(contacts)
                // Bumper("Continue")
            )
        )
    }
}

struct DirectMessageFlow(DirectMessage);

impl DirectMessageFlow {
    pub fn new() -> Self {
        DirectMessageFlow(
            DirectMessage::new(),
        )
    }
}

struct DirectMessage(Page);

impl DirectMessage {
    pub fn new() -> Self {
        DirectMessage(
            Page::new(
                // Header::chat(ctx, Some(back), contacts, None),
                // MessageBubbles
                // Bumper(TextInput -> Publishes messages)
            )
        )
    }
}

struct GroupMessageFlow(GroupMessage, GroupMessageInfo);

impl GroupMessageFlow {
    pub fn new() -> Self {
        GroupMessageFlow(
            GroupMessage::new(),
            GroupMessageInfo::new()
        )
    }
}

struct GroupMessage(Page);

impl GroupMessage {
    pub fn new() -> Self {
        GroupMessage(
            Page::new(
                // Header::chat(ctx, Some(back), contacts, Some(info)),
                // MessageBubbles
                // Bumper(TextInput -> Publishes messages)
            )
        )
    }
}


struct GroupMessageInfo(Page);

impl GroupMessageInfo {
    pub fn new() -> Self {
        GroupMessageInfo(
            Page::new(
                // Header::stack(ctx, "Group members"),
                // Text::new("This group has 3 members"),
                // ListItemGroup::new(contacts)
            )
        )
    }
}
