import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:orange/global.dart' as global;
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/test.dart';
import 'dart:ui';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Function to start Rust, unchanged
Future<void> startRust(String path) async {
    await rustStart(
        path: path,
        platform: global.platform,
        callback: global.dartCallback,
    );
}

void initBackgroundFetch() {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15, 
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true, 
        ), (String taskId) async {

            await _sendNotification();
            BackgroundFetch.finish(taskId);
        },
    );
}

// Example function to send notifications in the background
Future<void> _sendNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var android = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: android);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    var androidDetails = AndroidNotificationDetails(
        'your_channel_id',    // Channel ID
        'your_channel_name',  // Channel name
        channelDescription: 'your_channel_description',  // Channel description
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        0,
        'Background Task Notification',
        'This notification was triggered in the background.',
        notificationDetails,
    );
}

Future<void> main() async {
    await RustLib.init();
    WidgetsFlutterBinding.ensureInitialized();
    await global.getAppData();
    startRust(global.dataDir!);

    // Initialize background fetch
    initBackgroundFetch();

    if (global.platform_isDesktop) {
        WindowManager.instance.setMinimumSize(const Size(1280, 832));
    }

    FlutterError.onError = (details) {
        FlutterError.presentError(details);
        global.navigation.throwError(details.toString());
    };

    PlatformDispatcher.instance.onError = (error, stack) {
        print(stack);
        global.navigation.throwError(error.toString());
        return true;
    };

    runApp(MyApp());

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
    MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: global.navigation.navkey,
            title: 'orange.me',
            theme: theme(),
            home: BitcoinHome(),
        );
    }
}
