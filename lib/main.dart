import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:orange/flows/wallet/home.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'dart:io';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (!Platform.isIOS && !Platform.isAndroid) {
    WindowManager.instance.setMinimumSize(const Size(1200, 800));
  }
  await RustLib.init();
  GlobalState globalState = GlobalState.init();
  runApp(MyApp(globalState: globalState));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  final GlobalState globalState;

  const MyApp({required this.globalState, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: globalState.navkey,
        title: 'Orange',
        theme: theme(),
        home: WalletHome(globalState));
  }
}
