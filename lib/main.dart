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

Future<void> startRust(String path) async {
  await rustStart(
    path: path,
    platform: global.platform,
    callback: global.dartCallback,
  );
}

Future<void> backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // If task times out, finish it immediately.
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here, for now just print.
  print("[BackgroundFetch] Running background task...");
  BackgroundFetch.finish(taskId);
}

Future<void> main() async {
  await RustLib.init();
  WidgetsFlutterBinding.ensureInitialized();
  await global.getAppData();
  startRust(global.dataDir!);
  if (global.platform_isDesktop) {
    WindowManager.instance.setMinimumSize(const Size(1280, 832));
  }

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

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
