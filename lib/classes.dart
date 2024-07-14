import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:orange/screens/error.dart';

import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/src/rust/frb_generated.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class DartState {
    double currentPrice;
    double usdBalance;
    double btcBalance;

    DartState(this.currentPrice, this.usdBalance, this.btcBalance);

    factory DartState.init() {
        return DartState(0.0, 0.0, 0.0);
    }

    factory DartState.fromJson(Map<String, dynamic> json) {
        return DartState(
            json['currentPrice'] as double,
            json['usdBalance'] as double,
            json['btcBalance'] as double,
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
        Directory mydir = await Directory('${appDocDirectory.path}/').create(recursive: true);
        this.error(await rustStart(path: mydir.path, callback: this.dartCallback));
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

    Future<String> dartCallback(String dartCommand) async {
        var command = DartCommand.fromJson(jsonDecode(dartCommand));
        switch (command.method) {
            case "set_state":
                print("set_state");
                this.state.value = DartState.fromJson(jsonDecode(command.data));
            case "secure_get":
                return await this.storage.read(key: command.data) ?? "";
            case "secure_set":
                var split = command.data.split("\u0000");
                await this.storage.write(key: split[0], value: split[1]);
            case "print":
                print(command.data);
            case "get_commands":
                var json = jsonEncode(this.rustCommands);
                this.rustCommands = [];
                return json;
            case "post_response":
                print(dartCommand);
                this.rustResponses.add(RustR.fromJson(jsonDecode(command.data)));
            case "synced":
                this.synced = true;
            case var unknown:
                return "Error:UnknownMethod:$unknown";
        }
        return "Ok";
    }
}

//Internal
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
//Internal

class Transaction {
  final String? receiver;
  final String? sender;
  final String txid;
  final int net;
  final int? fee;
  final DateTime? timestamp;
  final String? raw;

  Transaction(this.receiver, this.sender, this.txid, this.net, this.fee,
      this.timestamp, this.raw);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    var time = json['timestamp'] as int?;
    print("Timestamp: $time");
    return Transaction(
        json['receiver'] as String?,
        json['sender'] as String?,
        json['txid'] as String,
        json['net'] as int,
        json['fee'] as int?,
        time != null ? DateTime.fromMillisecondsSinceEpoch(time * 1000) : null,
        json['raw'] as String?);
  }

  Map<String, dynamic> toJson() => {
        'receiver': receiver,
        'sender': sender,
        'txid': txid,
        'net': net,
        'fee': fee,
        'timestamp': timestamp,
        'raw': raw
      };
}

class CreateTransactionInput {
  final String address;
  final int sats;
  final int block_target;

  CreateTransactionInput(this.address, this.sats, this.block_target);

  Map<String, dynamic> toJson() => {
        'address': address,
        'sats': sats,
        'block_target': block_target,
      };
}
//Transfer
