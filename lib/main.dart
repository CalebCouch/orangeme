import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/src/rust/frb_generated.dart';
//import 'package:orange/flows/bitcoin/wallet.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/temp_classes.dart';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:window_manager/window_manager.dart';

const Wallet dummyWallet = Wallet(
  "My Wallet",
  [],
  125.23, // balance in USD
  0.00000142, // balance in BTC
  true, // isSpending
);

const Wallet dummyWallet2 = Wallet(
  "My Wallet 2",
  [],
  194.12, // balance in USD
  0.00001826, // balance in BTC
  true, // isSpending
);

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalState.navkey,
      title: 'Orange',
      theme: theme(),
      home: MultiWalletHome(globalState,
          wallets: const [dummyWallet, dummyWallet2]),
    );
  }
}
