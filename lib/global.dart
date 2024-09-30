library orangeme.global;

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

int counter = 400;
SharedPreferencesAsync android_storage = SharedPreferencesAsync();
FlutterSecureStorage ios_storage = const FlutterSecureStorage();

Platform platform = Platform.Mac.init();//Use Mac to call INIT and get the actual platform
bool platform_isDesktop = platform.isDesktop();
//var state = GlobalState(GlobalKey<NavigatorState>(), sp, isDesktop);

void init() {
//  if (Platform.isWindows && Platform.isLinux && Platform.isMacOS && Platform.isAndroid && Platform.isIOS && Platform.isFuchsia) {
//      error("Platform is unknown");
//  }
}

void add() {
    counter += 1;
}

ValueNotifier<BitcoinHomeState> bitcoinHomeState = ValueNotifier(
    BitcoinHomeState("\$1.20", "0.003 BTC", <BitcoinHomeTransaction>[
        BitcoinHomeTransaction("\$1.20", "12:20 PM", true)
    ])
);

//  Future<void> storage_write(String key, String value) async {
//      if Platform.isIOS {
//          await ios_storage.write(key: split[0], value: split[1]);
//      }
//      
//  }

//  Future<void> iosWrite(data) async {
//  var split = data.split("\u0000");
//}

//Future<String> iosRead(data) async {
//  return await this.storage.read(key: data) ?? "";
//}

//Future<void> androidWrite(String data) async {
//  // Split the data by the delimiter
//  var split = data.split("\u0000");
//  String key = split[0];
//  String value = split[1];
//  // Obtain SharedPreferences instance
//  final SharedPreferences prefs = await SharedPreferences
//      .getInstance(); // Write the data to SharedPreferences
//  await prefs.setString(key, value);
//}

//Future<String> androidRead(String key) async {
//  // Obtain SharedPreferences instance
//  final SharedPreferences prefs = await SharedPreferences
//      .getInstance(); // Read the value associated with the key, returning an empty string if the key doesn't exist
// 
