#if os(iOS)
import UIKit
#else
import AppKit
#endif

import Foundation
import UserNotifications

//@objc func requestPushNotificationPermission() {
//    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in }
//    #if os(iOS)
//        UIApplication.shared.registerForRemoteNotifications()
//    #endif
//}
//
//@objc func handleSilentPushNotification(userInfo: [AnyHashable: Any]) {
//    requestPushNotificationPermission( )
//    UNUserNotificationCenter.current().getNotificationSettings { settings in
//        print("Authorization status: \(settings.authorizationStatus.rawValue)")
//    }
//    if let aps = userInfo["aps"] as? [String: Any],
//       let contentAvailable = aps["content-available"] as? Int, contentAvailable == 1 {
//        #if os(iOS)
//            ios_background();
//        #endif
//        print("notification sent")
//        DispatchQueue.global().asyncAfter(deadline: .now() + 30) {
//            self.handleSilentPushNotification(userInfo: userInfo)
//        }
//    }
//}


@objc class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    @objc func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.delegate = NotificationManager.shared
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error)")
            } else {
                print("Permission granted: \(granted)")
            }
        }
        #if os(iOS)
        UIApplication.shared.registerForRemoteNotifications()
        #endif
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    @objc func trigger(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            } else {
                print("Notification scheduled")
            }
        }
    }
}

// Expose to Rust
//@_cdecl("setup_notification_delegate")
//public func setup_notification_delegate() {
//    UNUserNotificationCenter.current().delegate = NotificationManager.shared
//}
//
//@_cdecl("request_push_notification_permission")
//public func request_push_notification_permission() {
//    NotificationManager.shared.requestPermission()
//}

@_cdecl("trigger_push_notification")
public func trigger_push_notification(cTitle: UnsafePointer<CChar>, cBody: UnsafePointer<CChar>) {
    let title = String(cString: cTitle)
    let body = String(cString: cBody)
    NotificationManager.shared.requestPermission()
    UNUserNotificationCenter.current().delegate = NotificationManager.shared
    NotificationManager.shared.trigger(title: title, body: body)
}

//
@_cdecl("send_silent_push_notification")
public func send_silent_push_notification() {
//    let manager = NotificationManager()
//    NotificationManager.shared.requestPermission()
//    manager.handleSilentPushNotification(userInfo: ["aps": ["content-available": 1]])
}
