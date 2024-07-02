import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:orange/screens/init.dart';
import 'package:orange/styles/theme.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  var path = await getDocPath();
  print(path);
  ERROR = await rustStart(path: path, dartCallback: dartCallback);
  print(ERROR);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Orange',
        theme: theme(),
        home: const InitPage());
  }
}
