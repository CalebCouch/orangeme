library orangeme.global;

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/error.dart';

int counter = 400;
SharedPreferencesAsync android_storage = SharedPreferencesAsync();
FlutterSecureStorage ios_storage = const FlutterSecureStorage();

Platform platform = Platform.Mac.init();//Use Mac to call INIT and get the actual platform
bool platform_isDesktop = platform.isDesktop();
bool platform_isMobile = !platform_isDesktop;

ValueNotifier<BitcoinHomeState> bitcoinHomeState = ValueNotifier(
    BitcoinHomeState("\$1.20", "0.003 BTC", <BitcoinHomeTransaction>[
        BitcoinHomeTransaction("\$1.20", "12:20 PM", true)
    ])
);

ValueNotifier<ReceiveState> receiveState = ValueNotifier(
    ReceiveState("emptyaddress")
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

//Navigation
GlobalKey<NavigatorState> navkey = GlobalKey<NavigatorState>();

void throwError(String err) {
    Navigator.pushReplacement(
        navkey.currentContext!,
        MaterialPageRoute(builder: (context) => ErrorPage(message: err)),
    );
}

Future<void> navigateTo(Widget widget) async {
  Navigator.push(
    navkey.currentContext!,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => widget,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

Future<void> navPop() async {
  Navigator.pop(navkey.currentContext!);
}

Future<void> switchPageTo(
  Widget widget,
) async {
  var context = navkey.currentContext!;
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => widget,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

Future<void> resetNavTo(Widget widget) async {
  var context = navkey.currentContext!;
  Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => widget,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false);
}
