use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub enum Platform {
    Mac,
    Linux,
    Windows,
    IOS,
    Android,
    Fuchsia
}

impl Platform {
    #[flutter_rust_bridge::frb(sync)]
    pub fn is_desktop(&self) -> bool {
        matches!(self, Platform::Mac | Platform::Linux | Platform::Windows)
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub enum WalletMethod {
    GetNewAddress
}

#[derive(Debug)]
pub enum PageName {
//  BitcoinHome,
//  Receive,
//  Send,
//  ScanQR,
//  Amount,
//  Speed,
//  ConfirmTransaction,
//  Success,
//  ViewTransaction,
//  MessagesHome,
//  Exchange,
//  MyProfile,
//  UserProfile,
//  ConvoInfo,
//  ChooseRecipient,
    Test
}

//  use allo_isolate::ffi::{DartCObject, DartCObjectType, DartCObjectValue};

//  impl flutter_rust_bridge::IntoDart for BTreeMap<Txid, Transaction> {
//      fn into_dart(self) -> DartCObject {
//          DartCObject {
//              ty: DartCObjectType::DartNull,
//              value: DartCObjectValue { as_bool: false },
//          }
//      }
//  }
