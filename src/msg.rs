use messages::{Room, Message};
use profiles::Profile;
use pelican_ui_std::Timestamp;
use pelican_ui::{Context, Plugin};

use std::sync::{Mutex, Arc};
use std::time::Duration;
use serde::{Serialize, Deserialize};
use chrono::{DateTime, Local, Utc}; // temp
use std::sync::mpsc::{channel, Receiver};

pub struct MSGPlugin {
    // rooms: Arc<Mutex<Vec<Room>>>,
    profiles: Arc<Mutex<Vec<Profile>>>,
    receiver: Receiver<String>,
}

impl MSGPlugin {
    pub async fn _init(&mut self) {
        println!("Initialized MSG");
    }

    // pub fn get_rooms(&mut self) -> Vec<Room> {
    //     self.rooms.lock().unwrap().to_vec()
    // }

    // pub fn create_room(&mut self, profiles: Vec<Profile>) {
    //     self.rooms.lock().unwrap().to_vec().push(Room::new(profiles, Vec::new()));
    // }

    pub fn get_profiles(&mut self) -> Vec<Profile> {
        self.profiles.lock().unwrap().to_vec()
    }

    // get all profiles
    // create room (members shared with?)
    // read room (room) -> (Vec<Message>)
    // get rooms -> (Vec<Room>)
    // new message (msg, room)

    // read user Profile
}

// let (sender, receiver) = mpsc::channel();
// (
//     Some(IconButton::input(ctx, icon, move |_| {sender.send(0).unwrap();})),
//     Some((receiver, Box::new(on_click) as SubmitCallback)),
// )

impl Plugin for MSGPlugin {
    async fn background_tasks(_ctx: &mut HeadlessContext) -> Tasks {
        vec![]
    }

    async fn new(_ctx: &mut Context, _h_ctx: &mut HeadlessContext) -> (Self, Tasks) {
        // let rooms = Arc::new(Mutex::new(Vec::new()));
        let profiles = Arc::new(Mutex::new(Vec::new()));
        let (_sender, receiver) = channel();
        (MSGPlugin{
            // rooms: rooms.clone(),
            profiles: profiles.clone(),
            receiver,
        // }, tasks![GetRooms(rooms), GetProfiles(profiles)])
        }, tasks![GetProfiles(profiles)])
    }
}

pub struct GetRooms(Arc<Mutex<Vec<Room>>>);
#[async_trait]
impl Task for GetRooms {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(10))}

    async fn run(&mut self, _h_ctx: &mut HeadlessContext) {
        // Get Rooms
        let rooms = fake_rooms();
        *self.0.lock().unwrap() = rooms;
    }
}

#[derive(Serialize, Deserialize, Default, Clone, Debug)]
pub struct CurrentRoom(Option<Room>);

impl CurrentRoom {
    pub fn new(new: Room) -> Self {
        CurrentRoom(Some(new))
    }

    pub fn get(&self) -> &Option<Room> { &self.0 }
}


pub struct GetProfiles(Arc<Mutex<Vec<Profile>>>);
#[async_trait]
impl Task for GetProfiles {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(10))}

    async fn run(&mut self, _h_ctx: &mut HeadlessContext) {
        // Get Profiles
        let profiles = fake_profiles();
        *self.0.lock().unwrap() = profiles;
    }
}

#[derive(Serialize, Deserialize, Default, Clone, Debug)]
pub struct CurrentProfile(Option<Profile>);

impl CurrentProfile {
    pub fn new(new: Profile) -> Self {
        CurrentProfile(Some(new))
    }

    pub fn get(&self) -> &Option<Profile> { &self.0 }
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