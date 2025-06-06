use messages::{Room, Message};
use profiles::Profile;
use pelican_ui_std::Timestamp;
use pelican_ui::{Context, Plugin};

use std::sync::{Mutex, Arc};
use std::time::Duration;
use serde::{Serialize, Deserialize};
use chrono::{DateTime, Local, Utc}; // temp
use std::sync::mpsc::{channel, Receiver};

// pub struct MSGPlugin {
//     // rooms: Arc<Mutex<Vec<Room>>>,
//     profiles: Arc<Mutex<Vec<Profile>>>,
//     receiver: Receiver<String>,
// }

// impl MSGPlugin {
//     pub async fn _init(&mut self) {
//         println!("Initialized MSG");
//     }

//     // pub fn get_rooms(&mut self) -> Vec<Room> {
//     //     self.rooms.lock().unwrap().to_vec()
//     // }

//     // pub fn create_room(&mut self, profiles: Vec<Profile>) {
//     //     self.rooms.lock().unwrap().to_vec().push(Room::new(profiles, Vec::new()));
//     // }

//     pub fn get_profiles(&mut self) -> Vec<Profile> {
//         self.profiles.lock().unwrap().to_vec()
//     }

//     // get all profiles
//     // create room (members shared with?)
//     // read room (room) -> (Vec<Message>)
//     // get rooms -> (Vec<Room>)
//     // new message (msg, room)

//     // read user Profile
// }

// // let (sender, receiver) = mpsc::channel();
// // (
// //     Some(IconButton::input(ctx, icon, move |_| {sender.send(0).unwrap();})),
// //     Some((receiver, Box::new(on_click) as SubmitCallback)),
// // )

// impl Plugin for MSGPlugin {
//     async fn background_tasks(_ctx: &mut HeadlessContext) -> Tasks {
//         vec![]
//     }

//     async fn new(_ctx: &mut Context, _h_ctx: &mut HeadlessContext) -> (Self, Tasks) {
//         // let rooms = Arc::new(Mutex::new(Vec::new()));
//         let profiles = Arc::new(Mutex::new(Vec::new()));
//         let (_sender, receiver) = channel();
//         (MSGPlugin{
//             // rooms: rooms.clone(),
//             profiles: profiles.clone(),
//             receiver,
//         // }, tasks![GetRooms(rooms), GetProfiles(profiles)])
//         }, tasks![GetProfiles(profiles)])
//     }
// }

#[derive(Serialize, Deserialize, Default, Clone, Debug)]
pub struct AllMessages(pub Vec<Message>);

impl AllMessages {
    pub fn new() -> Self {
        AllMessages(fake_messages())
    }

    pub fn add(&mut self, new: Message) {
        self.0.push(new);
    }
}


#[derive(Serialize, Deserialize, Default, Clone, Debug)]
pub struct AllRooms(pub Vec<Room>);

impl AllRooms {
    pub fn new() -> Self {
        AllRooms(fake_rooms())
    }

    pub fn add(&mut self, new: Room) {
        self.0.push(new);
    }

    pub fn get(&mut self) -> &mut Vec<Room> {
        &mut self.0
    }
}

#[derive(Serialize, Deserialize, Default, Clone, Debug)]
pub struct AllProfiles(pub Vec<Profile>);

impl AllProfiles {
    pub fn new() -> Self {
        AllProfiles(fake_profiles())
    }
}

fn fake_rooms() -> Vec<Room> {
    vec![
        Room {
            profiles: fake_profiles(),
            messages: fake_messages(),
        },
        Room {
            profiles: fake_profiles(),
            messages: fake_messages(),
        },
        Room {
            profiles: fake_profiles(),
            messages: fake_messages(),
        }
    ]
}

fn fake_messages() -> Vec<Message> {
    let authors = fake_profiles();
    let dt1 = "2025-05-19T08:12:45Z".parse::<DateTime<Utc>>().unwrap().with_timezone(&Local);
    let dt2 = "2025-05-19T10:34:02Z".parse::<DateTime<Utc>>().unwrap().with_timezone(&Local);
    let dt3 = "2025-05-19T12:55:19Z".parse::<DateTime<Utc>>().unwrap().with_timezone(&Local);   

    vec![
        Message {
            message: "I need butter!!".to_string(),
            timestamp: Timestamp::new(dt1),
            author: authors[0].clone(),
        },
        Message {
            message: "I need oil".to_string(),
            timestamp: Timestamp::new(dt2),
            author: authors[1].clone(),
        },
        Message {
            message: "NO! You need margarine.".to_string(),
            timestamp: Timestamp::new(dt3),
            author: authors[2].clone(),
        }
    ]
}

pub 
fn fake_profiles() -> Vec<Profile> {
    vec![
        Profile {
            user_name: "Marge Margarine".to_string(),
            biography: "Probably butter.".to_string(),
            identifier: "did::id::12345".to_string(),
            blocked_dids: Vec::new(),
        },
        Profile {
            user_name: "Billy Butter".to_string(),
            biography: "Can't believe I'm not butter.".to_string(),
            identifier: "did::id::12345".to_string(),
            blocked_dids: Vec::new(),
        },
        Profile {
            user_name: "Olive Oool".to_string(),
            biography: "Better than butter.".to_string(),
            identifier: "did::id::12345".to_string(),
            blocked_dids: Vec::new(),
        },
        Profile {
            user_name: "Clarence Cream".to_string(),
            biography: "Spreadable and dependable.".to_string(),
            identifier: "did::id::67890".to_string(),
            blocked_dids: Vec::new(),
        },
        Profile {
            user_name: "Sunny Spread".to_string(),
            biography: "Shines on toast.".to_string(),
            identifier: "did::id::23456".to_string(),
            blocked_dids: Vec::new(),
        },
        Profile {
            user_name: "Lana Lard".to_string(),
            biography: "Old-fashioned but flavorful.".to_string(),
            identifier: "did::id::34567".to_string(),
            blocked_dids: Vec::new(),
        },
        Profile {
            user_name: "Ghee Goldstein".to_string(),
            biography: "Clarified and classy.".to_string(),
            identifier: "did::id::45678".to_string(),
            blocked_dids: Vec::new(),
        },
        Profile {
            user_name: "Patti Plant-Based".to_string(),
            biography: "Vegan and proud.".to_string(),
            identifier: "did::id::56789".to_string(),
            blocked_dids: Vec::new(),
        },
        Profile {
            user_name: "Rico Ricotta".to_string(),
            biography: "Spreading love and cheese on rice. sorta.".to_string(),
            identifier: "did::id::67891".to_string(),
            blocked_dids: Vec::new(),
        },
        Profile {
            user_name: "Benny Brunch".to_string(),
            biography: "Where butter meets eggs.".to_string(),
            identifier: "did::id::78901".to_string(),
            blocked_dids: Vec::new(),
        },
    ]
}