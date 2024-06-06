import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:orange/screens/init.dart';
import 'package:orange/styles/theme.dart';

import 'dart:math';
//import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

import 'package:http/http.dart' as http;

Future<void> fetch() async {
  var response = await http.get(Uri.parse('http://localhost:3000/'));
  print("resp");
  print(response.statusCode);
  print(response.body);
}

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
  fetch();
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
