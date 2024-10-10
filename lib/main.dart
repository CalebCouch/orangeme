import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orange/global.dart' as global;
import 'package:path_provider/path_provider.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:thread/thread.dart';
import 'dart:convert';
import 'package:orange/storage.dart';
import 'package:uuid/uuid.dart';

Future<void> startRust(String path) async {
    global.navigation.throwError(await ruststart(
        path: path,
        platform: global.platform.toString(),
        thread: global.dartCallback,
    ));
}

Future<void> main() async {
    await RustLib.init();
    WidgetsFlutterBinding.ensureInitialized();
    await global.getAppData();
    startRust(global.dataDir!);
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
