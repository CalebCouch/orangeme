#if os(iOS)
import UIKit
#else
import AppKit
#endif

import Foundation
import UserNotifications

@objc class NotificationManager: NSObject {
    @objc func requestPushNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in }
        #if os(iOS)
            UIApplication.shared.registerForRemoteNotifications()
        #endif
    }

    @objc func handleSilentPushNotification(userInfo: [AnyHashable: Any]) {
        requestPushNotificationPermission( )
        if let aps = userInfo["aps"] as? [String: Any],
           let contentAvailable = aps["content-available"] as? Int, contentAvailable == 1 {
            #if os(iOS)
                ios_background();
            #endif
            print("notification sent")
            DispatchQueue.global().asyncAfter(deadline: .now() + 30) {
                self.handleSilentPushNotification(userInfo: userInfo)
            }
        }
    }
}

@_cdecl("send_silent_push_notification")
public func send_silent_push_notification() {
    let manager = NotificationManager()
    manager.handleSilentPushNotification(userInfo: ["aps": ["content-available": 1]])
}



// @objc func triggerRegularPushNotification() {
//     let content = UNMutableNotificationContent()
//     content.title = "Regular Push Notification"
//     content.body = "This push notification was triggered after waiting 5 minutes."
//     content.sound = .default 
    
//     let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//     let request = UNNotificationRequest(identifier: "regular_push", content: content, trigger: trigger)
    
//     UNUserNotificationCenter.current().add(request) { error in
//         if let error = error {
//             print("Failed to send regular push notification: \(error)")
//         } else {
//             print("Regular push notification triggered after 5 minutes.")
//             self.handleSilentPushNotification(userInfo: userInfo)
//         }
//     }
// }
