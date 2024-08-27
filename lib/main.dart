import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/flows/bitcoin/send/multi-device_confirm.dart';
import 'package:orange/flows/bitcoin/transactions/confirmation_takeover.dart';
import 'package:orange/flows/bitcoin/wallet.dart';
import 'package:orange/flows/pairing/pair_code.dart';
import 'package:orange/src/rust/frb_generated.dart';
//import 'package:orange/flows/bitcoin/wallet.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/pairing/pair.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/temp_classes.dart';

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

bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

Future<void> main() async {
  await RustLib.init();
  WidgetsFlutterBinding.ensureInitialized();
  if (onDesktop) {
    WindowManager.instance.setMinimumSize(const Size(1280, 832));
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
      home: ConfirmationTakeover(
        globalState,
        Transaction(
          false,
          'bc1asuthaxk8293579axk83bdauci183xukabe',
          '123',
          12.53,
          0.00000142,
          63204.12,
          0.34,
          '2024-12-24',
          '12:34 PM',
          'raw',
        ),
      ),
      //MultiWalletHome(globalState,
      // wallets: const [dummyWallet, dummyWallet2]),
    );
  }
}

/* ConfirmationTakeover(
        globalState,
        Transaction(
          false,
          'bc1asuthaxk8293579axk83bdauci183xukabe',
          '123',
          12.53,
          0.00000142,
          63204.12,
          0.34,
          '2024-12-24',
          '12:34 PM',
          'raw',
        ),
      ),*/
