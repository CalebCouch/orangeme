

// //
// @_cdecl("send_silent_push_notification")
// public func send_silent_push_notification() {
// //    let manager = NotificationManager()
// //    NotificationManager.shared.requestPermission()
// //    manager.handleSilentPushNotification(userInfo: ["aps": ["content-available": 1]])
// }

// // Expose to Rust
// //@_cdecl("setup_notification_delegate")
// //public func setup_notification_delegate() {
// //    UNUserNotificationCenter.current().delegate = NotificationManager.shared
// //}
// //
// //@_cdecl("request_push_notification_permission")
// //public func request_push_notification_permission() {
// //    NotificationManager.shared.requestPermission()
// //}

// //@objc func requestPushNotificationPermission() {
// //    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in }
// //    #if os(iOS)
// //        UIApplication.shared.registerForRemoteNotifications()
// //    #endif
// //}
// //
// //@objc func handleSilentPushNotification(userInfo: [AnyHashable: Any]) {
// //    requestPushNotificationPermission( )
// //    UNUserNotificationCenter.current().getNotificationSettings { settings in
// //        print("Authorization status: \(settings.authorizationStatus.rawValue)")
// //    }
// //    if let aps = userInfo["aps"] as? [String: Any],
// //       let contentAvailable = aps["content-available"] as? Int, contentAvailable == 1 {
// //        #if os(iOS)
// //            ios_background();
// //        #endif
// //        print("notification sent")
// //        DispatchQueue.global().asyncAfter(deadline: .now() + 30) {
// //            self.handleSilentPushNotification(userInfo: userInfo)
// //        }
// //    }
// //}




// // use objc2::rc::{Id, Shared};
// // use objc2::{class, msg_send, msg_send_id, sel};
// // use objc2::runtime::Bool;
// // use std::ffi::{c_char, CStr};
// // use std::ptr;

// // struct NotificationManager;

// // impl NotificationManager {
// //     fn shared() -> &'static Self {
// //         static INSTANCE: NotificationManager = NotificationManager;
// //         &INSTANCE
// //     }

// //     fn request_permission(&self) {
// //         unsafe {
// //             let center: Id<_, Shared> = msg_send_id![class!(UNUserNotificationCenter), current];
// //             let delegate = class!(NotificationManager).load();
// //             let _: () = msg_send![&*center, setDelegate: delegate];
            
// //             let options: u32 = 1 | 2 | 4; // alert | sound | badge
// //             let _: () = msg_send![&*center, requestAuthorizationWithOptions:options 
// //                 completionHandler:^(Bool granted, *mut Object error) {
// //                     if error != ptr::null_mut() {
// //                         println!("Error requesting permission");
// //                     } else {
// //                         println!("Permission granted: {}", granted);
// //                     }
// //                 }
// //             ];
// //         }     
// //     }

// //     fn trigger(&self, title: &str, body: &str) {
// //         unsafe {
// //             let content: Id<_, Shared> = msg_send_id![class!(UNMutableNotificationContent), new];
// //             let ns_title = NSString::from_str(title);
// //             let ns_body = NSString::from_str(body);
// //             let _: () = msg_send![&*content, setTitle: &*ns_title];
// //             let _: () = msg_send![&*content, setBody: &*ns_body];
// //             let _: () = msg_send![&*content, setSound: msg_send_id![class!(UNNotificationSound), defaultSound]];
            
// //             let trigger: Id<_, Shared> = msg_send_id![
// //                 class!(UNTimeIntervalNotificationTrigger), 
// //                 triggerWithTimeInterval:1.0 repeats:Bool::NO
// //             ];
            
// //             let uuid = uuid::Uuid::new_v4().to_string();
// //             let identifier = NSString::from_str(&uuid);
            
// //             let request: Id<_, Shared> = msg_send_id![
// //                 class!(UNNotificationRequest),
// //                 requestWithIdentifier:&*identifier content:&*content trigger:&*trigger
// //             ];
            
// //             let center: Id<_, Shared> = msg_send_id![class!(UNUserNotificationCenter), current];
// //             let _: () = msg_send![&*center, 
// //                 addNotificationRequest:&*request 
// //                 withCompletionHandler:^(*mut Object error) {
// //                     if error != ptr::null_mut() {
// //                         println!("Notification error");
// //                     } else {
// //                         println!("Notification scheduled");
// //                     }
// //                 }
// //             ];
// //         }
// //     }
// // }

// // #[no_mangle]
// // pub extern "C" fn trigger_push_notification(c_title: *const c_char, c_body: *const c_char) {
// //     let title = unsafe { CStr::from_ptr(c_title).to_string_lossy().into_owned() };
// //     let body = unsafe { CStr::from_ptr(c_body).to_string_lossy().into_owned() };
    
// //     NotificationManager::shared().request_permission();
// //     NotificationManager::shared().trigger(&title, &body);
// // }