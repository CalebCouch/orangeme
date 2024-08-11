import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/screens/error.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';

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

class Contact {
  String name;
  String did;
  String? pfp;
  String? abtme;
  Contact(this.name, this.did, this.pfp, this.abtme);

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      json['name'] as String,
      json['did'] as String,
      json['pfp'] as String?,
      json['abtme'] as String?,
    );
  }
}

class Message {
  Contact sender;
  String message;
  String date;
  String time;
  bool isIncoming;
  //Can we compare the sender's did to our did to figure this out?

  Message(this.sender, this.message, this.date, this.time, this.isIncoming);
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      Contact.fromJson(json['sender']),
      json['message'] as String,
      json['date'] as String,
      json['time'] as String,
      json['is_incoming'] as bool,
    );
  }
}

class Conversation {
  List<Contact> members;
  List<Message> messages;

  Conversation(this.members, this.messages);
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      List<Contact>.from(json['members'].map((json) => Contact.fromJson(json))),
      List<Message>.from(
          json['messages'].map((json) => Message.fromJson(json))),
    );
  }
}

class DartState {
  double currentPrice;
  double usdBalance;
  double btcBalance;
  List<Transaction> transactions;
  List<double> fees;
  List<Conversation> conversations;
  List<Contact> users;
  Contact personal;

  DartState(
    this.currentPrice,
    this.usdBalance,
    this.btcBalance,
    this.transactions,
    this.fees,
    this.conversations,
    this.users,
    this.personal,
  );

  factory DartState.init() {
    return DartState(0.0, 0.0, 0.0, [], [], [], [], Contact('', '', '', ''));
  }

  factory DartState.fromJson(Map<String, dynamic> json) {
    return DartState(
      json['currentPrice'] as double,
      json['usdBalance'] as double,
      json['btcBalance'] as double,
      List<Transaction>.from(
          json['transactions'].map((tx) => Transaction.fromJson(tx))),
      List<double>.from(json['fees'].map((fee) => fee as double)),
      List<Conversation>.from(
          json["conversations"].map((y) => Conversation.fromJson(y))),
      List<Contact>.from(json["users"].map((i) => Contact.fromJson(i))),
      Contact.fromJson(json["personal"]),
    );
  }
}

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
    Directory mydir =
        await Directory('${appDocDirectory.path}/').create(recursive: true);
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

  Future<String> dartCallback(String dartCommand) async {
    var command = DartCommand.fromJson(jsonDecode(dartCommand));
    switch (command.method) {
      case "set_state":
        print(DartState.fromJson(jsonDecode(command.data)));
        state.value = DartState.fromJson(jsonDecode(command.data));
      case "secure_get":
        return await storage.read(key: command.data) ?? "";
      case "secure_set":
        var split = command.data.split("\u0000");
        await storage.write(key: split[0], value: split[1]);
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
      case "error":
        print(command.data);
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
