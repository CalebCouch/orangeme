library orangeme.global;

import 'package:flutter/material.dart';
import 'package:orange/classes.dart';
import 'package:orange/error.dart';
import 'package:orange/navigation.dart';
import 'package:orange/storage.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

String? dataDir;

getAppData() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    dataDir = (await Directory('${appDocDirectory.path}/orangeme/').create(recursive: true)).path.toString();
}

//Platform
Platform platform = Platform.Mac.init();//Use Mac to call INIT and get the actual platform
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

Future<String> dartCallback(String dartCommand) async {
    var command = DartCommand.fromJson(jsonDecode(dartCommand));
    switch (command.method) {
        case "internet": {
            if (command.data == "true") {
                internet_connected = true;
            } else {
                internet_connected = false;
            }
        }
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
        case "get_commands":
            var json = jsonEncode(rustCommands);
            rustCommands = [];
            return json;
        case "post_response":
            print(dartCommand);
            rustResponses.add(RustR.fromJson(jsonDecode(command.data)));
        case "error":
            navigation.throwError(command.data);
        case var unknown:
            return "Error:UnknownMethod:$unknown";
    }
    return "Ok";
}
