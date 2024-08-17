import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/classes/test_classes.dart';
import 'package:orange/flows/bitcoin/pairing/pairing_code.dart';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  await RustLib.init();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowManager.instance.setMaximumSize(const Size(1280, 832));
  }
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
    bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    bool isPaired = false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalState.navkey,
      title: 'Orange',
      theme: theme(),
      home: onDesktop && !isPaired
          ? PairingCode(globalState)
          : BitcoinHome(
              globalState,
            ),
    );
  }
}
