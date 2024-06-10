import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orange/screens/error.dart';

// ignore: constant_identifier_names
const STORAGE = FlutterSecureStorage();

Future<String> getDBPath() async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Directory mydir = await Directory('${appDocDirectory.path}/sqlitedata9.db')
      .create(recursive: true);
  return mydir.path;
}

String handleNull(nullable, context) {
  if (nullable == null) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const ErrorPage(
                status: 404,
                message: "Value from storage was unexpectedly null")));
  }
  return nullable ?? "NEVER";
}

String handleError(response, context) {
  if (response.status != 200) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ErrorPage(status: response.status, message: response.message)));
  }
  return response.message;
}
