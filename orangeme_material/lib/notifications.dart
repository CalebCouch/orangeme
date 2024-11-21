import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
    print("initializing notifications");
    const AndroidInitializationSettings asa = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(android: asa);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


Future<void> sendNotification(String notificationType) async {
    print("SENDING NOTIFICATION FOR *$notificationType*");

    late AndroidNotificationDetails androidDetails;

    String title;
    String message;

    switch (notificationType) {
        case "Message Received":
            androidDetails = MessageReceived();
            title = "New Message";
            message = "You have received a new message.";
            break;
        case "Bitcoin Received":
            androidDetails = BitcoinReceived();
            title = "Bitcoin Received";
            message = "You've received Bitcoin in your wallet.";
            break;
        case "Bitcoin Sent":
            androidDetails = BitcoinSent();
            title = "Bitcoin Sent";
            message = "Your Bitcoin transaction was successful.";
            break;
        case "Bitcoin Send Failed":
            androidDetails = BitcoinSendFailed();
            title = "Transaction Failed";
            message = "Your Bitcoin transaction could not be completed.";
            break;
        case "App Terminated":
            androidDetails = AppTerminated();
            title = "Stay Connected";
            message = "Keep orange running in the background to receive notifications on time.";
            break;
        default:
            androidDetails = MessageReceived();
            title = "Notification";
            message = "You have a new notification.";
            break;
    }

    var notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        message,
        notificationDetails,
        payload: 'message_payload',
    );
}



AndroidNotificationDetails MessageReceived(){
    return AndroidNotificationDetails(
        'message_channel_id', 
        'Message Notifications',
        channelDescription: 'Notifications for messages received in orange',
        importance: Importance.high, 
        priority: Priority.high,
        ticker: 'New message received',
        icon: 'app_icon',
    );
}

AndroidNotificationDetails BitcoinReceived(){
    return AndroidNotificationDetails(
        'btc_channel_id', 
        'Bitcoin Notifications',
        channelDescription: 'Notifications for Bitcoin received in orange',
        importance: Importance.high, 
        priority: Priority.high,
        ticker: 'You have received Bitcoin',
        icon: 'app_icon',
    );
}

AndroidNotificationDetails BitcoinSent(){
    return AndroidNotificationDetails(
        'btc_channel_id', 
        'Bitcoin Notifications',
        channelDescription: 'Notifications for Bitcoin received in orange',
        importance: Importance.high, 
        priority: Priority.high,
        ticker: 'Bitcoin successfully sent',
        icon: 'app_icon',
    );
}

AndroidNotificationDetails BitcoinSendFailed(){
    return AndroidNotificationDetails(
        'btc_channel_id', 
        'Bitcoin Notifications',
        channelDescription: 'Notifications for Bitcoin received in orange',
        importance: Importance.high, 
        priority: Priority.high,
        ticker: 'Bitcoin send has failed',
        icon: 'app_icon',
    );
}

AndroidNotificationDetails AppTerminated(){
    return AndroidNotificationDetails(
        'btc_channel_id', 
        'Bitcoin Notifications',
        channelDescription: 'Notifications for Bitcoin received in orange',
        importance: Importance.high, 
        priority: Priority.high,
        ticker: 'Bitcoin send has failed',
        icon: 'app_icon',
    );
}