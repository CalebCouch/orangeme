library orangeme.global;

import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/navigation.dart';
import 'package:orange/storage.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io' as DartIO;

import 'package:path_provider/path_provider.dart';

import 'package:orange/src/rust/api/simple.dart';

String? dataDir;

getAppData() async {
    DartIO.Directory appDocDirectory = await getApplicationDocumentsDirectory();
    dataDir = (await DartIO.Directory('${appDocDirectory.path}/orangeme/').create(recursive: true)).path.toString();
}

//Platform
Platform getPlatform() {
    if (DartIO.Platform.isWindows) {
      return Platform.windows;
    }
    if (DartIO.Platform.isLinux) {
      return Platform.linux;
    }
    if (DartIO.Platform.isMacOS) {
      return Platform.mac;
    }
    if (DartIO.Platform.isIOS) {
      return Platform.ios;
    }
    if (DartIO.Platform.isAndroid) {
      return Platform.android;
    }
    if (DartIO.Platform.isFuchsia) {
      return Platform.fuchsia;
    }
    throw 'Unsupported Platform';
}

Platform platform = getPlatform();
bool platform_isDesktop = platform.isDesktop();
bool platform_isMobile = !platform_isDesktop;
bool internet_connected = true;

Storage storage = Storage.init(platform);
Navigation navigation = Navigation.init();

//  List<RustR> rustResponses = [];
//  List<RustC> rustCommands = [];
//  Uuid uuid = const Uuid();

//  Future<String> invoke(String method, String data) async {
//      var uid = uuid.v1();
//      var command = RustC(uid, method, data);
//      print(jsonEncode(command));
//      rustCommands.add(command);
//      while (true) {
//          var index = rustResponses.indexWhere((res) => res.uid == uid);
//          if (index != -1) {
//              return rustResponses.removeAt(index).data;
//          }
//          await Future.delayed(const Duration(milliseconds: 10));
//      }
//  }

Future<String> callRust(Thread thread) async {
    var result = await rustCall(thread: thread);
    if (result.contains("Error")) {
        navigation.throwError(result);
    }
    return result;
}

Future<String?> dartCallback(DartMethod command) async {
    try {
        switch (command) {
            case DartMethod_StorageSet(field0: var key, field1: var val): {
                await storage.write(key, val);
            };
            case DartMethod_StorageGet(field0: var key): {
                return await storage.read(key);
            }
        }
    } catch(e) {
        navigation.throwError(e.toString());
    }
    return "Error";
}
