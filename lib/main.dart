import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:flutter/services.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:orange/screens/init.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orange',
      theme: theme(),
      home: const InitPage(),
    );
  }
}
