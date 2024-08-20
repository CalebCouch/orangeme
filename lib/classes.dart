import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'package:path_provider/path_provider.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/screens/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction {
  bool isReceive;
  String? sentAddress;
  String txid;
  double usd;
  double btc;
  double price;
  double fee;
  String? date;
  String? time;
  String? raw;

  Transaction(this.isReceive, this.sentAddress, this.txid, this.usd, this.btc,
      this.price, this.fee, this.date, this.time, this.raw);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json['isReceive'] as bool,
      json['sentAddress'] as String?,
      json['txid'] as String,
      json['usd'] as double,
      json['btc'] as double,
      json['price'] as double,
      json['fee'] as double,
      json['date'] as String?,
      json['time'] as String?,
      json['raw'] as String?,
    );
  }
}

class DartState {
  double currentPrice;
  double usdBalance;
  double btcBalance;
  List<Transaction> transactions;
  List<double> fees;

  DartState(this.currentPrice, this.usdBalance, this.btcBalance,
      this.transactions, this.fees);

  factory DartState.init() {
    return DartState(0.0, 0.0, 0.0, [], []);
  }

  factory DartState.fromJson(Map<String, dynamic> json) {
    return DartState(
      json['currentPrice'] as double,
      json['usdBalance'] as double,
      json['btcBalance'] as double,
      List<Transaction>.from(
          json['transactions'].map((tx) => Transaction.fromJson(tx))),
      List<double>.from(json['fees'].map((fee) => fee as double)),
    );
  }
}

class GlobalState {
  FlutterSecureStorage storage = FlutterSecureStorage();
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
    Directory mydir =
        await Directory('${appDocDirectory.path}/').create(recursive: true);
    this.error(await rustStart(
        path: mydir.path,
        callback: this.dartCallback,
        callback1: this.dartCallback,
        callback3: this.dartCallback));
  }

  BuildContext? getContext() {
    return this.navkey.currentContext;
  }

  void error(String err) {
    Navigator.pushReplacement(
      this.navkey.currentContext!,
      MaterialPageRoute(builder: (context) => ErrorPage(message: err)),
    );
  }

  Future<RustR> invoke(String method, String data) async {
    var uid = uuid.v1();
    var command = RustC(uid, method, data);
    print(jsonEncode(command));
    this.rustCommands.add(command);
    while (true) {
      var index = this.rustResponses.indexWhere((res) => res.uid == uid);
      if (index != -1) {
        return this.rustResponses.removeAt(index);
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
    final SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Write the data to SharedPreferences
    await prefs.setString(key, value);
  }

  Future<String> androidRead(String key) async {
    // Obtain SharedPreferences instance
    final SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Read the value associated with the key, returning an empty string if the key doesn't exist
    return prefs.getString(key) ?? "";
  }

  Future<String> dartCallback(String dartCommand) async {
    var command = DartCommand.fromJson(jsonDecode(dartCommand));
    switch (command.method) {
      case "set_state":
        this.state.value = DartState.fromJson(jsonDecode(command.data));
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
        var json = jsonEncode(this.rustCommands);
        this.rustCommands = [];
        return json;
      case "post_response":
        this.rustResponses.add(RustR.fromJson(jsonDecode(command.data)));
      case "synced":
        this.synced = true;
      case "clear_storage":
        await clearStorage();
        return "Storage cleared";

      case "check_os":
        return checkPlatform();
      case var unknown:
        return "Error:UnknownMethod:$unknown";
    }
    return "Ok";
  }
}

class DartCommand {
  final String method;
  final String data;

  DartCommand(this.method, this.data);

  factory DartCommand.fromJson(Map<String, dynamic> json) {
    return DartCommand(json['method'] as String, json['data'] as String);
  }
}

class RustC {
  final String uid;
  final String method;
  final String data;

  RustC(this.uid, this.method, this.data);

  factory RustC.fromJson(Map<String, dynamic> json) {
    return RustC(json['uid'] as String, json['method'] as String,
        json['data'] as String);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'method': method,
        'data': data,
      };
}

class RustR {
  final String uid;
  final String data;

  RustR(this.uid, this.data);

  factory RustR.fromJson(Map<String, dynamic> json) {
    return RustR(json['uid'] as String, json['data'] as String);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'data': data,
      };
}
