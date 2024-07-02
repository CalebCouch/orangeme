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
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String error = "";

  @override
  void initState() {
    super.initState();
    setupApp();
  }

  Future<void> setupApp() async {
    var path = await getDocPath();
    print(path);
    var _error = await rustStart(path: path, dartCallback: dartCallback)
    setState(() {
      error = _error;
    });
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
