import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/error.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalState {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  GlobalKey<NavigatorState> navkey;
  List<RustR> rustResponses = [];
  List<RustC> rustCommands = [];
  Uuid uuid = const Uuid();
  bool synced;

  ValueNotifier<DartState> state = ValueNotifier(DartState.init());

  GlobalState(this.navkey, this.synced);

  factory GlobalState.init() {
    var state = GlobalState(GlobalKey<NavigatorState>(), false);
    state.startRust();
    return state;
  }

  Future<void> startRust() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory mydir = await Directory('${appDocDirectory.path}/').create(recursive: true);
    error(await rustStart(
        path: mydir.path,
        callback: dartCallback,
        callback1: dartCallback,
        callback2: dartCallback,
        callback3: dartCallback,
        callback4: dartCallback));
  }

  BuildContext? getContext() {
    return navkey.currentContext;
  }

  void error(String err) {
    Navigator.pushReplacement(
      navkey.currentContext!,
      MaterialPageRoute(builder: (context) => ErrorPage(message: err)),
    );
  }

  Future<RustR> invoke(String method, String data) async {
    var uid = uuid.v1();
    var command = RustC(uid, method, data);
    print(jsonEncode(command));
    rustCommands.add(command);
    while (true) {
      var index = rustResponses.indexWhere((res) => res.uid == uid);
      if (index != -1) {
        return rustResponses.removeAt(index);
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> clearStorage() async {
    final os = checkPlatform();
    if (os == "IOS") {
      final keys = await this.storage.readAll();

      for (var key in keys.keys) {
        await this.storage.delete(key: key);
      }
      print("IOS storage cleared");
    } else if (os == "Android") {
      final SharedPreferences pref = await SharedPreferences.getInstance();

      await pref.clear();
      print("Android storage cleared");
    } else {
      print("cannot clear storage, desktop found");
      return;
    }
  }

  String checkPlatform() {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return 'IOS';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else if (Platform.isMacOS) {
      return 'MacOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    } else {
      return 'Unknown';
    }
  }

  Future<void> iosWrite(data) async {
    var split = data.split("\u0000");
    await this.storage.write(key: split[0], value: split[1]);
  }

  Future<String> iosRead(data) async {
    return await this.storage.read(key: data) ?? "";
  }

  Future<void> androidWrite(String data) async {
    // Split the data by the delimiter
    var split = data.split("\u0000");
    String key = split[0];
    String value = split[1];
    // Obtain SharedPreferences instance
    final SharedPreferences prefs = await SharedPreferences.getInstance(); // Write the data to SharedPreferences
    await prefs.setString(key, value);
  }

  Future<String> androidRead(String key) async {
    // Obtain SharedPreferences instance
    final SharedPreferences prefs =
        await SharedPreferences.getInstance(); // Read the value associated with the key, returning an empty string if the key doesn't exist
    return prefs.getString(key) ?? "";
  }

  Future<String> dartCallback(String dartCommand) async {
    var command = DartCommand.fromJson(jsonDecode(dartCommand));
    switch (command.method) {
      case "set_state":
        print(DartState.fromJson(jsonDecode(command.data)));
        state.value = DartState.fromJson(jsonDecode(command.data));
      case "ios_get":
        return await iosRead(command.data);
      case "ios_set":
        await iosWrite(command.data);
      case "android_get":
        return await androidRead(command.data);
      case "android_set":
        await androidWrite(command.data);
      case "print":
        print(command.data);
      case "get_commands":
        var json = jsonEncode(rustCommands);
        rustCommands = [];
        return json;
      case "post_response":
        print(dartCommand);
        rustResponses.add(RustR.fromJson(jsonDecode(command.data)));
      case "synced":
        synced = true;
      case "clear_storage":
        await clearStorage();
        return "Storage cleared";
      case "check_os":
        return checkPlatform();
      case "error":
        print(command.data);
      case var unknown:
        return "Error:UnknownMethod:$unknown";
    }
    return "Ok";
  }
}