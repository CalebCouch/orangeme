import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:orange/screens/init.dart';
import 'package:orange/styles/theme.dart';
import 'package:flutter_js/flutter_js.dart';

import 'dart:math';
//import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<void> callJS() async {
    MyService _myService = MyService();
    JavascriptRuntime flutterJs = _myService.flutterJs;
    String javascript = await rootBundle.loadString('js/index.js');
    String web5js = await rootBundle.loadString('js/one.js');
    JsEvalResult jsResult = await flutterJs.evaluateAsync(web5js);
    flutterJs.executePendingJob();
    final promiseResolved = await flutterJs.handlePromise(jsResult);
    String result = promiseResolved.stringResult;
    print("ERROR: "+result);
}

class MyService {

  static final MyService _instance = MyService._internal();

  factory MyService() => _instance;

  MyService._internal() {
    print("INIT");
    _flutterJs.onMessage('increment', (_) async {
        await Future.delayed(const Duration(seconds: 1));
        print("increment");
        this.incrementMyVariable();
        return "data";
    });
  }

  JavascriptRuntime _flutterJs = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false);
  int _myVariable = 0;

  JavascriptRuntime get flutterJs => _flutterJs;
  int get myVariable => _myVariable;
  set myVariable(int value) => myVariable = value;
  void incrementMyVariable() => _myVariable++;
}

Future<void> runner() async {
    MyService _myService = MyService();
    print("test${_myService.myVariable}");
    await Future.delayed(Duration(seconds: 1));
    runner();
}

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
  MyService _myService = MyService();

  runner();
  callJS();

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
