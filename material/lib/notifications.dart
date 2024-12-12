import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material/material.dart';
import 'package:flutter/material.dart';

Widget CustomBanner(String message) {
    return Container(
        child: Padding( padding: EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    CustomIcon(icon: 'error', size: 'xl'),
                    Spacing(8),
                    CustomTextSpan(message),
                ],
            ),
        ),
    );
}

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

AndroidNotificationDetails _createNotification(
    String channelId, 
    String channelName, 
    String channelDescription, 
    String ticker
) {
    return AndroidNotificationDetails(
        channelId, 
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high, 
        priority: Priority.high,
        ticker: ticker,
        icon: 'app_icon',
    );
}

AndroidNotificationDetails MessageReceived() {
    return _createNotification(
        'message_channel_id', 
        'Message Notifications', 
        'Notifications for messages received in orange', 
        'New message received'
    );
}

AndroidNotificationDetails BitcoinReceived() {
    return _createNotification(
        'btc_channel_id', 
        'Bitcoin Notifications', 
        'Notifications for Bitcoin received in orange', 
        'You have received Bitcoin'
    );
}

AndroidNotificationDetails BitcoinSent() {
    return _createNotification(
        'btc_channel_id', 
        'Bitcoin Notifications', 
        'Notifications for Bitcoin received in orange', 
        'Bitcoin successfully sent'
    );
}

AndroidNotificationDetails BitcoinSendFailed() {
    return _createNotification(
        'btc_channel_id', 
        'Bitcoin Notifications', 
        'Notifications for Bitcoin received in orange', 
        'Bitcoin send has failed'
    );
}

AndroidNotificationDetails AppTerminated() {
    return _createNotification(
        'btc_channel_id', 
        'Bitcoin Notifications', 
        'Notifications for Bitcoin received in orange', 
        'Bitcoin send has failed'
    );
}
