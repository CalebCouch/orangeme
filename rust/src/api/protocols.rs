use super::Error;

use flutter_rust_bridge::frb;

pub use web5_rust::dwn::protocol::{
    ProtocolDefinition,
    ProtocolActionRule,
    ProtocolStructure,
    ProtocolRuleSet,
    ProtocolAction,
    ProtocolActor,
    ProtocolTypes,
    ProtocolType,
    ProtocolPath,
    ProtocolSize,
    ProtocolUri,
    Protocol,
};
pub use web5_rust::common::structs::DataFormat;

use std::str::FromStr;

#[frb(ignore)]
pub struct SocialProtocol {}
impl SocialProtocol {
    pub fn get() -> Result<ProtocolDefinition, Error> {
        let social_protocol_uri = ProtocolUri::from_str("https://areweweb5yet.com/protocols/social")?;
        Ok(ProtocolDefinition::new(
            social_protocol_uri.clone(),
            true,
            ProtocolTypes::from([
                ("aggregators".to_string(),
                ProtocolType::new(
                    Some(social_protocol_uri.add_path("/schemas/aggregators")?),
                    vec![DataFormat::AppJson]
                )),
                ("follow".to_string(),
                ProtocolType::new(
                    Some(social_protocol_uri.add_path("/schemas/follow")?),
                    vec![DataFormat::AppJson]
                )),
                ("story".to_string(),
                ProtocolType::new(
                    Some(social_protocol_uri.add_path("/schemas/story")?),
                    vec![DataFormat::AppJson]
                )),
                ("comment".to_string(),
                ProtocolType::new(
                    Some(social_protocol_uri.add_path("/schemas/comment")?),
                    vec![DataFormat::AppJson]
                )),
                ("thread".to_string(),
                ProtocolType::new(
                    Some(social_protocol_uri.add_path("/schemas/thread")?),
                    vec![DataFormat::AppJson]
                )),
                ("reply".to_string(),
                ProtocolType::new(
                    Some(social_protocol_uri.add_path("/schemas/reply")?),
                    vec![DataFormat::AppJson]
                )),
                ("media".to_string(),
                ProtocolType::new(
                    Some(social_protocol_uri.add_path("/schemas/media")?),
                    vec![DataFormat::ImgGif, DataFormat::ImgPng, DataFormat::ImgJpeg, DataFormat::VidMp4]
                ))
            ]),
            ProtocolStructure::from([
                ("aggregators".to_string(), ProtocolRuleSet::default()),
                ("follow".to_string(),
                ProtocolRuleSet::new(
                    None,
                    Vec::new(),
                    true,
                    ProtocolSize::default(),
                    None,
                    ProtocolStructure::default()
                )),
                ("story".to_string(),
                ProtocolRuleSet::new(
                    None, //$encryption
                    Vec::new(), //$actions
                    false, //$role
                    ProtocolSize::default(), //$size
                    None, //$tags
                    ProtocolStructure::from([
                        ("media".to_string(),
                        ProtocolRuleSet::new(
                            None,
                            vec![ProtocolActionRule::new(
                                Some(ProtocolActor::Author),
                                None,
                                Some(ProtocolPath::from_str("story").unwrap()),
                                vec![
                                    ProtocolAction::Create,
                                    ProtocolAction::Update,
                                    ProtocolAction::Delete
                                ]
                            )?],
                            false,
                            ProtocolSize::default(),
                            None,
                            ProtocolStructure::default()
                        )),
                        ("comment".to_string(),
                        ProtocolRuleSet::new(
                            None,
                            vec![
                                ProtocolActionRule::new(
                                    Some(ProtocolActor::Anyone), //&who
                                    None, //$role
                                    None, //$of
                                    vec![ //$can
                                        ProtocolAction::Create,
                                        ProtocolAction::Update,
                                        ProtocolAction::Delete
                                    ]
                                )?,
                                ProtocolActionRule::new(
                                    Some(ProtocolActor::Author), //&who
                                    None, //$role
                                    Some(ProtocolPath::from_str("story").unwrap()), //$of
                                    vec![ProtocolAction::CoDelete] //$can
                                )?
                            ],
                            false,
                            ProtocolSize::default(),
                            None,
                            ProtocolStructure::from([
                                ("media".to_string(),
                                ProtocolRuleSet::new(
                                    None,
                                    vec![
                                        ProtocolActionRule::new(
                                            Some(ProtocolActor::Author),
                                            None,
                                            Some(ProtocolPath::from_str("story/comment").unwrap()),
                                            vec![
                                                ProtocolAction::Create,
                                                ProtocolAction::Update,
                                                ProtocolAction::Delete
                                            ]
                                        )?,
                                        ProtocolActionRule::new(
                                            Some(ProtocolActor::Author),
                                            None,
                                            Some(ProtocolPath::from_str("story").unwrap()),
                                            vec![ProtocolAction::CoDelete]
                                        )?
                                    ],
                                    false,
                                    ProtocolSize::default(),
                                    None,
                                    ProtocolStructure::default()
                                ))
                            ])
                        ))
                    ])
                )),
                ("thread".to_string(),
                ProtocolRuleSet::new(
                    None,
                    Vec::new(),
                    true,
                    ProtocolSize::default(),
                    None,
                    ProtocolStructure::from([
                        ("media".to_string(),
                        ProtocolRuleSet::new(
                            None,
                            vec![ProtocolActionRule::new(
                                Some(ProtocolActor::Author), //&who
                                None, //$role
                                Some(ProtocolPath::from_str("thread").unwrap()), //$of
                                vec![ //$can
                                    ProtocolAction::Create,
                                    ProtocolAction::Update,
                                    ProtocolAction::Delete
                                ]
                            )?],
                            false,
                            ProtocolSize::default(),
                            None,
                            ProtocolStructure::default()
                        )),
                        ("reply".to_string(),
                        ProtocolRuleSet::new(
                            None,
                            vec![ProtocolActionRule::new(
                                Some(ProtocolActor::Anyone), //&who
                                None, //$role
                                None, //$of
                                vec![ //$can
                                    ProtocolAction::Create,
                                    ProtocolAction::Update,
                                    ProtocolAction::Delete
                                ]
                            )?],
                            false,
                            ProtocolSize::default(),
                            None,
                            ProtocolStructure::from([
                                ("media".to_string(),
                                ProtocolRuleSet::new(
                                    None,
                                    vec![ProtocolActionRule::new(
                                        Some(ProtocolActor::Author), //&who
                                        None, //$role
                                        Some(ProtocolPath::from_str("thread/reply").unwrap()), //$of
                                        vec![ //$can
                                            ProtocolAction::Create,
                                            ProtocolAction::Update,
                                            ProtocolAction::Delete
                                        ]
                                    )?],
                                    false,
                                    ProtocolSize::default(),
                                    None,
                                    ProtocolStructure::default()
                                )),
                            ])
                        )),
                    ])
                )),
            ])
        ))
    }
}

#[frb(ignore)]
pub struct ProfileProtocol {}
impl ProfileProtocol {
    pub fn get() -> Result<ProtocolDefinition, Error> {

        let profile_protocol_uri = ProtocolUri::from_str("https://areweweb5yet.com/protocols/profile")?;
        Ok(ProtocolDefinition::new(
            profile_protocol_uri.clone(),
            true,
            ProtocolTypes::from([
                ("name".to_string(),
                ProtocolType::new(
                    Some(profile_protocol_uri.add_path("/schemas/name")?),
                    vec![DataFormat::AppJson]
                )),
                ("social".to_string(),
                ProtocolType::new(
                    Some(profile_protocol_uri.add_path("/schemas/social")?),
                    vec![DataFormat::AppJson]
                )),
                ("messaging".to_string(),
                ProtocolType::new(
                    Some(profile_protocol_uri.add_path("/schemas/messaging")?),
                    vec![DataFormat::AppJson]
                )),
                ("phone".to_string(),
                ProtocolType::new(
                    Some(profile_protocol_uri.add_path("/schemas/phone")?),
                    vec![DataFormat::AppJson]
                )),
                ("address".to_string(),
                ProtocolType::new(
                    Some(profile_protocol_uri.add_path("/schemas/address")?),
                    vec![DataFormat::AppJson]
                )),
                ("career".to_string(),
                ProtocolType::new(
                    Some(profile_protocol_uri.add_path("/schemas/career")?),
                    vec![DataFormat::AppJson]
                )),
                ("avatar".to_string(),
                ProtocolType::new(
                    Some(profile_protocol_uri.add_path("/schemas/avatar")?),
                    vec![DataFormat::ImgGif, DataFormat::ImgPng, DataFormat::ImgJpeg]
                )),
                ("hero".to_string(),
                ProtocolType::new(
                    Some(profile_protocol_uri.add_path("/schemas/hero")?),
                    vec![DataFormat::ImgGif, DataFormat::ImgPng, DataFormat::ImgJpeg]
                ))

            ]),
            ProtocolStructure::from([
                ("name".to_string(), ProtocolRuleSet::default()),
                ("social".to_string(), ProtocolRuleSet::default()),
                ("career".to_string(), ProtocolRuleSet::default()),
                ("avatar".to_string(), ProtocolRuleSet::default()),
                ("hero".to_string(), ProtocolRuleSet::default()),
                ("messaging".to_string(), ProtocolRuleSet::default()),
                ("address".to_string(), ProtocolRuleSet::default()),
                ("phone".to_string(), ProtocolRuleSet::default()),
            ])
        ))
    }
}
