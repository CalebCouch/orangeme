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

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String error;

  @override
  void initState() {
    super.initState();
    setupApp();
  }

  Future<void> setupApp() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    var path = await getDocPath();
    print(path);
    setState(() {
      error = rustStart(path: path, dartCallback: dartCallback) as String;
    });
    print(error);
  }

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
