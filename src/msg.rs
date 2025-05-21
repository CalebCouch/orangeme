use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use std::sync::{Mutex, Arc};
use std::time::Duration;
use serde::{Serialize, Deserialize};
use chrono::{DateTime, Local}; // temp

pub struct MSGPlugin {
    rooms: Arc<Mutex<Vec<Room>>>,
    profiles: Arc<Mutex<Vec<Profile>>>,
}

impl MSGPlugin {
    pub async fn _init(&mut self) {
        println!("Initialized MSG");
    }

    pub fn get_rooms(&mut self) -> Vec<Room> {
        self.rooms.lock().unwrap().to_vec()
    }

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

impl Plugin for MSGPlugin {
    async fn background_tasks(ctx: &mut HeadlessContext) -> Tasks {
        vec![]
    }

    async fn new(_ctx: &mut Context, h_ctx: &mut HeadlessContext) -> (Self, Tasks) {
        let rooms = Arc::new(Mutex::new(Vec::new()));
        let profiles = Arc::new(Mutex::new(Vec::new()));
        (MSGPlugin{
            rooms: rooms.clone(),
            profiles: profiles.clone(),
        }, tasks![GetRooms(rooms), GetProfiles(profiles)])
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Room {
    pub profiles: Vec<Profile>,
    pub messages: Vec<Message>
}

impl Room {
    pub fn new(profiles: Vec<Profile>, messages: Vec<Message>) -> Self {
        Room { profiles, messages }
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Profile {
    pub user_name: String,
    pub biography: String,
    pub identifier: String, // orange identity
    pub blocked_dids: Vec<String>,
    // Bitcoin Wallet Associated???
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Message {
    pub message: String,
    pub timestamp: Timestamp,
    pub author: Profile,
}

pub struct GetRooms(Arc<Mutex<Vec<Room>>>);
#[async_trait]
impl Task for GetRooms {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(10))}

    async fn run(&mut self, h_ctx: &mut HeadlessContext) {
        // Get Rooms
        let rooms = fake_rooms();
        *self.0.lock().unwrap() = rooms;
    }
}

pub struct GetProfiles(Arc<Mutex<Vec<Profile>>>);
#[async_trait]
impl Task for GetProfiles {
    fn interval(&self) -> Option<Duration> {Some(Duration::from_secs(10))}

    async fn run(&mut self, h_ctx: &mut HeadlessContext) {
        // Get Profiles
        let profiles = fake_profiles();
        *self.0.lock().unwrap() = profiles;
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

#[derive(Serialize, Deserialize, Default, Clone, Debug)]
pub struct CurrentProfile(Option<Profile>);

impl CurrentProfile {
    pub fn new(new: Profile) -> Self {
        CurrentProfile(Some(new))
    }

    pub fn get(&self) -> &Option<Profile> { &self.0 }
}

fn fake_profiles() -> Vec<Profile> {
    vec![
        Profile {
            user_name: "Marge Margarine".to_string(),
            biography: "Probably butter.".to_string(),
            identifier: "did::id::12345".to_string(),
            blocked_dids: Vec::new()
        },
        Profile {
            user_name: "Billy Butter".to_string(),
            biography: "Can't believe I'm not butter.".to_string(),
            identifier: "did::id::12345".to_string(),
            blocked_dids: Vec::new()
        },
        Profile {
            user_name: "Olive Oool".to_string(),
            biography: "Better than butter.".to_string(),
            identifier: "did::id::12345".to_string(),
            blocked_dids: Vec::new()
        }
    ]
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
    let dt1: DateTime<Local> = "2025-05-19T08:12:45".parse::<DateTime<Local>>().unwrap();
    let dt2: DateTime<Local> = "2025-05-19T10:34:02".parse::<DateTime<Local>>().unwrap();
    let dt3: DateTime<Local> = "2025-05-19T12:55:19".parse::<DateTime<Local>>().unwrap();

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