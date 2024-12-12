import 'package:flutter/material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/src/rust/frb_generated.dart';
//import 'package:workmanager/workmanager.dart';
import 'package:flow_bitcoin/flow_bitcoin.dart';
import 'package:orange/test.dart';
import 'package:material/material.dart';
import 'package:orange/global.dart' as global;
import 'package:flutter/services.dart';
import 'dart:ui';


Future<void> main() async {
    await RustLib.init();
    WidgetsFlutterBinding.ensureInitialized();
    await global.getAppData();
    global.startRust();
//     await initNotifications();
//     if (global.platform_isDesktop) {
//         WindowManager.instance.setMinimumSize(const Size(1280, 832));
//    }
    FlutterError.onError = (details) {
        FlutterError.presentError(details);
        global.throwError(details.toString());
    };
    PlatformDispatcher.instance.onError = (error, stack) {
        print(stack);
        global.throwError(error.toString());
        return true;
    };
    runApp(MyApp());

    // await waitForAppInBackground();
    // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    // await Workmanager().registerPeriodicTask(
    //     "id_unique_task",
    //     "simpleTask",
    //     frequency: Duration(minutes: 15),
    //     inputData: <String, dynamic>{'key': 'value'},
    // );
}



Future<void> startRust(String path) async {
    await rustStart(
        path: path,
        platform: global.platform,
        callback: global.dartCallback,
    );
}

// bool isAppInForeground = true;

// Future<void> waitForAppInBackground() async { 
//     while (isAppInForeground) { await Future.delayed(Duration(seconds: 3)); }
// }

// void notifications() {
//     sendNotification("Message Received");
// }

// // void callbackDispatcher() {
// //     print("CALLBACK");
// //     Workmanager().executeTask((task, inputData) {
// //         notifications();
// //         print("Background Task Triggered");
// //         return Future.value(true);
// //     });
// // }

class MyApp extends StatefulWidget {
    @override
    _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

    // @override
    // void initState() {
    //     super.initState();
    //     WidgetsBinding.instance.addObserver(this);
    // }

    // @override
    // void dispose() {
    //     WidgetsBinding.instance.removeObserver(this);
    //     super.dispose();
    // }

    // @override
    // void didChangeAppLifecycleState(AppLifecycleState state) {
    //     super.didChangeAppLifecycleState(state);
    //     switch(state) {
    //         case AppLifecycleState.resumed:
    //             setState(() => isAppInForeground = true);
    //             break;
    //         case AppLifecycleState.paused:
    //             setState(() => isAppInForeground = false);
    //             break;
    //         default:
    //             break;
    //     }
    // }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: global.navigation.navkey,
            title: 'orange',
            theme: theme(),
            home: BitcoinHome(),
            //home: Test(),
        );
    }
}
