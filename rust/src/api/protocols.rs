use super::Error;

use super::structs::Profile;

use schemars::schema::Schema;
use schemars::schema_for;

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
        vec![Self::messages_protocol(), Self::rooms_protocol()]
    }
}


