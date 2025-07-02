use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::prelude::Text;
use crate::BDKPlugin;

#[derive(Debug, Copy, Clone)]
pub enum RoomsFlow { 
Rooms,
JoinRoom,
ChatRoom,
RoomInfo,
}

impl AppFlow for RoomsFlow { 
    fn get_page(&self, ctx: &mut Context) -> Box<dyn AppPage> {
        match self {
            RoomsFlow::Rooms => Box::new(Rooms::new(ctx)) as Box<dyn AppPage>, 
            RoomsFlow::JoinRoom => Box::new(JoinRoom::new(ctx)) as Box<dyn AppPage>,
            RoomsFlow::ChatRoom => Box::new(ChatRoom::new(ctx)) as Box<dyn AppPage>, 
            RoomsFlow::RoomInfo => Box::new(RoomInfo::new(ctx)) as Box<dyn AppPage>,
        }
    }
}

#[derive(Debug, Component)]
pub struct Rooms(Stack, Page);
impl OnEvent for Rooms {}
impl AppPage for Rooms {}

pub struct RoomsInfo {
    name: &'static str,
    members: usize,
    description: &'static str,
    avatar: AvatarContent,
}

impl Rooms {
    fn new(ctx: &mut Context) -> Self { 
        let header = Header::home(ctx, "Rooms");
        let rooms = vec![
            RoomsInfo {
                name: "Chris Slaughter's Room",
                members: 243,
                description: "A room for all of Chris Slaughter’s friends.",
                avatar: AvatarContent::Icon("profile", AvatarIconStyle::Secondary),
            },
            RoomsInfo {
                name: "Ella's Room",
                members: 242,
                description: "A room for everyone except Chris.",
                avatar: AvatarContent::Icon("profile", AvatarIconStyle::Secondary),
            },
        ];

        let mut room_cards = Vec::new();
        for room in rooms {

            room_cards.push(Card::new(ctx,
                room.avatar,
                room.name,
                Box::leak(format!("{} Members", room.members).into_boxed_str()),
                room.description,
                |ctx:&mut Context|{RoomsFlow::JoinRoom.navigate(ctx)}
            
            ))
        }
        let cards_group = CardGroup::new(room_cards);
        let content = Content::new(Offset::Start, vec![Box::new(cards_group) as Box<dyn Drawable>]);
        let create_button = Button::primary(ctx, "Create Room", |ctx| {
            println!("Navigate to create room");
        });
        let bumper = Bumper::single_button(create_button);
        Rooms (Stack::center(), Page::new(header, content, Some(bumper), true))
    }
}

#[derive(Debug, Component)]
pub struct JoinRoom(Stack, Page);
impl OnEvent for JoinRoom {}
impl AppPage for JoinRoom {}

pub struct GroupMessageInfo {
    content: &'static str,
    name: &'static str,
    time: &'static str,
    avatar: AvatarContent,
}

impl JoinRoom {
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
            "😁😁😁",
            "Do you have butter?"
        ];
        let header = Header::home(ctx, "Chris Slaughter's Room");
        let message = Message::new(ctx, MessageType::Rooms, messages, contact.clone(), "6:24 AM");
        let content = Content::new(Offset::End, vec![Box::new(message)]);

        let join_button = Button::primary(ctx, "Join Room",|ctx:&mut Context|{RoomsFlow::ChatRoom.navigate(ctx)});    
        let bumper = Bumper::single_button(join_button);
        JoinRoom (Stack::center(), Page::new(header, content, Some(bumper), true))
    }
}

#[derive(Debug, Component)]
pub struct ChatRoom(Stack, Page);
impl OnEvent for ChatRoom {}
impl AppPage for ChatRoom {}

impl ChatRoom {
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
            "😁😁😁",
            "Do you have butter?"
        ];
        let header = Header::home(ctx, "Chris Slaughter's Room");

        let input = TextInput::new(ctx, None, None, "Message...", None, Some(("send", |_: &mut Context, string: &mut String| println!("Message: {:?}", string))));
        let bumper = Bumper::new(vec![Box::new(input)]);
        let message = Message::new(ctx, MessageType::Contact, messages, contact.clone(), "6:24 AM");
        let content = Content::new(Offset::End, vec![Box::new(message)]);
        let back = IconButton::navigation(ctx, "left", |ctx: &mut Context|{});
        let info = IconButton::navigation(ctx, "info", |ctx: &mut Context|{});
        let header = Header::chat(ctx, Some(back), Some(info), vec![contact.avatar]);
        ChatRoom(Stack::center(), Page::new(header, content, Some(bumper), false))
    }
}

#[derive(Debug, Component)]
pub struct RoomInfo(Stack, Page);
impl OnEvent for RoomInfo {}
impl AppPage for RoomInfo {}

impl RoomInfo {
    fn new(ctx: &mut Context) -> Self { 
        let header = Header::home(ctx, "Chris Slaughter's Room");

        let room_information = DataItem::new(ctx, None, "About", Some("room description"), None,
            Some(vec![
                ("Created by", "Chris Slaughter"),
                ("Created", "10/05/24"),
                ("Booted members", "0"),
                ("Members", "3"),
            ]), None
        );
            
        let mut contact_list: Vec<Box<dyn ListItemGroup>> = Vec::new();
        
        let profile = Profile {
            name: "Chris Slaugter",
            nym: "did::nym::xiCoiaLi8Twaix29aiLatixohRiioNNln",
            avatar: AvatarContent::Icon("profile", AvatarIconStyle::Secondary),
        };

        contact_list.push(Box::new(ListItemGroup::new(profile))); 
        
        RoomInfo(Stack::center(), Page::new(header, room_information, contact_list, true))
    }
}