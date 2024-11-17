import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/src/rust/frb_generated.dart';
//import 'package:orange/flows/messages/home.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:orange/global.dart' as global;
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/test.dart';
import 'dart:ui';

Future<void> startRust(String path) async {
  global.navigation.throwError(await rustStart(
    path: path,
    platform: global.platform,
    callback: global.dartCallback,
  ));
}

Future<void> main() async {
    await RustLib.init();
    WidgetsFlutterBinding.ensureInitialized();
    await global.getAppData();
    startRust(global.dataDir!);
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
