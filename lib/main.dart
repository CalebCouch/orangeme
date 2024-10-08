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

Future<void> startRust() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory mydir = await Directory('${appDocDirectory.path}/').create(recursive: true);
  //global.navigation.throwError(await ruststart(
  //    path: mydir.path,
  //    platform: global.platform.toString(),
  //    thread1: global.dartCallback,
  //    thread2: global.dartCallback,
  //    thread3: global.dartCallback,
  //    thread4: global.dartCallback,
  //    thread5: global.dartCallback,
  //));
}

Future<void> main() async {
    await RustLib.init();
    WidgetsFlutterBinding.ensureInitialized();
    //startRust();
    print("1");
    print((await rustfun())("1"));
    print("2");
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
