library orangeme.global;

import 'package:orange/classes.dart';
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

List<RustR> rustResponses = [];
List<RustC> rustCommands = [];
Uuid uuid = const Uuid();

Future<String> invoke(String method, String data) async {
    var uid = uuid.v1();
    var command = RustC(uid, method, data);
    print(jsonEncode(command));
    rustCommands.add(command);
    while (true) {
        var index = rustResponses.indexWhere((res) => res.uid == uid);
        if (index != -1) {
            return rustResponses.removeAt(index).data;
        }
        await Future.delayed(const Duration(milliseconds: 10));
    }
}

Future<String> callRust(Thread thread) async {
    var result = await rustCall(thread: thread);
    if (result.contains("Error")) {
        navigation.throwError(result);
    }
    return result;
}

Future<String> dartCallback(String dartCommand) async {
    var command = DartCommand.fromJson(jsonDecode(dartCommand));
    switch (command.method) {
        case "storage_set": {
            var split = command.data.split("\u0000");
            String key = split[0];
            String value = split[1];
            await storage.write(key, value);
        }
        case "storage_get": {
            return await storage.read(command.data) ?? "";
        }
        case "print":
            print(command.data);
        case var unknown:
            return "Error:UnknownMethod:$unknown";
    }
    return "Ok";
}
