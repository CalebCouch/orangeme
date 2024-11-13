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
        vec![Self::messages_protocol(), Self::rooms_protocol(), Self::profile()]
    }
}




#[derive(JsonSchema, Serialize, Deserialize, Debug, Clone)]
pub struct Profile {
    pub name: String,
    pub did: Did,
    pub pfp: Option<String>,
    pub abt_me: Option<String>,
}

impl Profile {
    pub fn new(
        name: String,
        did: Did,
        pfp: Option<String>,
        abt_me: Option<String>,
    ) -> Self {
        Profile{name, did, pfp, abt_me}
    }
}

#[derive(Clone, Debug)]
pub struct MessagingAgent {
    agent: Agent
}

impl MessagingAgent {
    pub async fn new(id: Identity, path: PathBuf) -> Result<Self, Error> {
        let did_resolver = DefaultDidResolver::new::<SqliteStore>(Some(path.join("DefaultDidResolver"))).await?;
        Ok(MessagingAgent{
            agent: Agent::new(
                Wallet::new(id, Box::new(did_resolver.clone()), None).get_agent_key(&Protocols::rooms_protocol()).await?,
                Protocols::get(), Box::new(did_resolver), None
            )
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
        let profile = if let Some(p) = self.agent.public_read(FiltersBuilder::build(vec![
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
        };
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
