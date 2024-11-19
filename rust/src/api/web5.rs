use super::Error;

use super::state::{State, Field};

use simple_database::SqliteStore;
use simple_database::database::{FiltersBuilder, IndexBuilder, Filter};

use web5_rust::dids::{DefaultDidResolver, DhtDocument, Identity, Did};
use web5_rust::{Wallet, Record, Agent};

use serde::{Serialize, Deserialize};
use std::path::PathBuf;

use schemars::schema::Schema;
use schemars::schema_for;
use schemars::JsonSchema;

use web5_rust::{
    ChannelPermissionOptions,
    PermissionOptions,
    ChannelProtocol,
    Protocol,
};

use std::str::FromStr;

const DUMMY_DID: &str = "did:dht:0000000000000000000000000000000000000000000000000000";

pub struct Protocols {}
impl Protocols {
    pub fn profile() -> Protocol {
         Protocol::new(
            "Profile",
            true,
            PermissionOptions::new(true, true, false, None),
            Some(serde_json::to_string(&schema_for!(Profile)).unwrap()),
            None
        ).unwrap()
    }

    pub fn shorthand_conversations() -> Protocol {
        Protocol::new(
            "Shorthand_Conversation",
            true,
            PermissionOptions::new(true, true, false, None),
            Some(serde_json::to_string(&schema_for!(ShorthandConversation)).unwrap()),
            None
        ).unwrap()
    }

    pub fn conversation() -> Protocol {
        Protocol::new(
            "Conversation",
            true,
            PermissionOptions::new(true, true, false, None),
            Some(serde_json::to_string(&schema_for!(Conversation)).unwrap()),
            None
        ).unwrap()
    }

    pub fn message() -> Protocol {
        Protocol::new(
            "Single_Message",
            true,
            PermissionOptions::new(true, true, false, None),
            Some(serde_json::to_string(&schema_for!(Message)).unwrap()),
            None
        ).unwrap()
    }

    pub fn messages_protocol() -> Protocol {
         Protocol::new(
            "Message",
            true,
            PermissionOptions::new(true, true, false, None),
            Some(serde_json::to_string(&Schema::Bool(true)).unwrap()),
            None
        ).unwrap()
    }

    pub fn rooms_protocol() -> Protocol {
        Protocol::new(
            "Room",
            false,
            PermissionOptions::new(true, true, false, Some(
                ChannelPermissionOptions::new(true, true, true)
            )),
            Some(serde_json::to_string(&Schema::Bool(true)).unwrap()),
            Some(ChannelProtocol::new(
                Some(vec![&Self::messages_protocol()])
            ))
        ).unwrap()
    }

    pub fn get() -> Vec<Protocol> {
        vec![Self::messages_protocol(), Self::shorthand_conversations(), Self::conversation(), Self::message(), Self::rooms_protocol(), Self::profile()]
    }
}

#[derive(JsonSchema, Serialize, Deserialize, Debug, Clone)]
pub struct Profile {
    pub name: String,
    pub did: Did,
    pub pfp_path: Option<String>,
    pub abt_me: Option<String>,
}

impl Profile {
    pub fn new(
        name: String,
        did: Did,
        pfp_path: Option<String>,
        abt_me: Option<String>,
    ) -> Self {
        Profile{name, did, pfp_path, abt_me}
    }
}

impl Default for Profile {
    fn default() -> Self {
        Profile::new("Default Name".to_string(), Did::from_str(DUMMY_DID).unwrap(), None, None)
    }
}

#[derive(JsonSchema, Serialize, Deserialize, Debug, Clone)]
pub struct ShorthandConversation {
    pub room_name: String,
    pub photo: Option<String>,
    pub subtext: String,
    pub is_group: bool,
    pub room_id: String,
}

impl ShorthandConversation {
    pub fn new(
        room_name: String,
        photo: Option<String>,
        subtext: String,
        is_group: bool,
        room_id: String
    ) -> Self {
        ShorthandConversation{room_name, photo, subtext, is_group, room_id}
    }
}

#[derive(JsonSchema, Serialize, Deserialize, Debug, Clone)]
pub struct Conversation {
    pub members: Vec<Profile>,
    pub messages: Vec<Message>,
    pub room_id: String,
}

impl Conversation {
    pub fn new(
        members: Vec<Profile>,
        messages: Vec<Message>,
        room_id: String,
    ) -> Self {
        Conversation{members, messages, room_id}
    }
}


#[derive(JsonSchema, Serialize, Deserialize, Debug, Clone)]
pub struct Message {
    pub sender: Profile,
    pub message: String,
    pub date: String,
    pub time: String,
}

impl Message {
    pub fn new(
        sender: Profile,
        message: String,
        date: String,
        time: String,
    ) -> Self {
        Message{sender, message, date, time}
    }
}

#[derive(Clone, Debug)]
pub struct MessagingAgent {
    agent: Agent
}

impl MessagingAgent {
    pub async fn new(id: Identity, path: PathBuf) -> Result<Self, Error> {
        let did_resolver = Box::new(DefaultDidResolver::new::<SqliteStore>(Some(path.join("DefaultDidResolver"))).await?);
        Ok(MessagingAgent{
            agent: Agent::new::<SqliteStore>(
                Wallet::new(id, did_resolver.clone(), None).get_agent_key(&Protocols::rooms_protocol()).await?,
                Protocols::get(), Some(path), Some(did_resolver), None
            ).await?
        })
    }

    pub async fn set_profile(&self, profile: Profile) -> Result<(), Error> {
        let index = IndexBuilder::build(vec![("type", "profile")]);
        let record = Record::new(None, &Protocols::profile(), serde_json::to_vec(&profile)?);
        self.agent.public_update(record, index, None).await?;
        Ok(())
    }

    pub async fn init_profile(&self, state: &State) -> Result<(), Error> {
        let tenant = self.agent.tenant().clone();
        if let Some(p) = self.agent.public_read(FiltersBuilder::build(vec![
            ("author", Filter::equal(tenant.to_string())),
            ("type", Filter::equal("profile"))]
        ), None, None).await?.first() {
            let profile = serde_json::from_slice::<Profile>(&p.1.payload)?;
            state.set(Field::Profile(Some(profile))).await?;
        } else {
            let index = IndexBuilder::build(vec![("type", "profile")]);
            let profile = Profile::new("Default Name".to_string(), tenant, None, None);
            let record = Record::new(None, &Protocols::profile(), serde_json::to_vec(&profile)?);
            self.agent.public_create(record, index, None).await?;
            state.set(Field::Profile(Some(profile))).await?;
        }
        Ok(())
    }

    pub async fn sync(&self) -> Result<(), Error> {
        self.agent.scan().await?;
        Ok(())
    }

    pub async fn refresh_state(&self, state: &State) -> Result<(), Error> {
        self.init_profile(state).await?;
        Ok(())
    }
}
