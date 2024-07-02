import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:orange/screens/error.dart';
import 'package:flutter/material.dart';
import 'package:orange/classes.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';

Uuid uuid = Uuid();
List<RustC> RUSTCOMMANDS = [];
List<RustR> RUSTRESPONSES = [];
const STORAGE = FlutterSecureStorage();
String ERROR = "";

Future<void> checkError(context) async {
  while (true) {
    await Future.delayed(Duration(milliseconds: 10));
    if (ERROR != "") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ErrorPage(message: ERROR)));
    }
  }
}

Future<RustR> invoke(String method, String data) async {
  var uid = uuid.v1();
  var command = new RustC(uid, method, data);
  print(jsonEncode(command));
  RUSTCOMMANDS.add(command);
  while (true) {
    var index = RUSTRESPONSES.indexWhere((res) => res.uid == uid);
    if (index != -1) {
      return RUSTRESPONSES.removeAt(index);
    }
    await Future.delayed(Duration(seconds: 1));
  }
}

Future<String> dartCallback(String dartCommand) async {
  var command = DartCommand.fromJson(jsonDecode(dartCommand));
  switch (command.method) {
    case "secure_get":
      return await STORAGE.read(key: command.data) ?? "";
    case "secure_set":
      var split = command.data.split("\u0000");
      await STORAGE.write(key: split[0], value: split[1]);
    case "print":
      print(command.data);
    case "get_commands":
      var json = jsonEncode(RUSTCOMMANDS);
      RUSTCOMMANDS = [];
      return json;
    case "post_response":
        print(dartCommand);
      RUSTRESPONSES.add(RustR.fromJson(jsonDecode(command.data)));
    case var unknown:
      return "Error:UnknownMethod:" + unknown;
  }
  return "Ok";
}

String handleNull(nullable, context) {
  if (nullable == null) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const ErrorPage(
                message: "Value from storage was unexpectedly null")));
  }
  return nullable ?? "NEVER";
}

Future<String> getDocPath() async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Directory mydir =
      await Directory('${appDocDirectory.path}/').create(recursive: true);
  return mydir.path;
}
