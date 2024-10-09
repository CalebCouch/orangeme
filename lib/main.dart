import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orange/global.dart' as global;
import 'package:path_provider/path_provider.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'dart:isolate';

Future<void> startRust(String path) async {
    global.navigation.throwError(await testasync(
        path: path,
        //platform: global.platform.toString(),
        //thread: global.dartCallback,
    ));
}

Future<void> main() async {
    await RustLib.init();
    WidgetsFlutterBinding.ensureInitialized();
    await global.getAppData();
    print(global.dataDir!);
    startRust(global.dataDir!.toString());
    var sp = await SharedPreferences.getInstance();
    if (global.platform_isDesktop) {
        WindowManager.instance.setMinimumSize(const Size(1280, 832));
    }
    runApp(MyApp());
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
