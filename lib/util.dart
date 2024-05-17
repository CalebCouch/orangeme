import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orange/screens/error.dart';

final STORAGE = new FlutterSecureStorage();

Future<String> GetDBPath() async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Directory mydir =
      await new Directory(appDocDirectory.path + '/' + 'sqlitedata6.db')
          .create(recursive: true);
  return mydir.path;
}

String HandleNull(nullable, context) {
  if (nullable == null) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ErrorPage(
                status: 404,
                message: "Value from storage was unexpectedly null")));
  }
  return nullable ?? "NEVER";
}

String HandleError(response, context) {
  if (response.status != 200) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ErrorPage(status: response.status, message: response.message)));
  }
  return response.message;
}
