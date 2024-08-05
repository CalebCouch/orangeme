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
  File? pfp;
  String? abtme;
  Contact(this.name, this.did, this.pfp, this.abtme);

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      json['name'] as String,
      json['did'] as String,
      json['pfp'] as File?,
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
      json['sender'] as Contact,
      json['message'] as String,
      json['date'] as String,
      json['time'] as String,
      json['isIncoming'] as bool,
    );
  }
}

class Conversation {
  List<Contact> members;
  List<Message> messages;

  Conversation(this.members, this.messages);
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      json['members'] as List<Contact>,
      json['messages'] as List<Message>,
    );
  }
}

/* TEST INFORMATION */
Contact myAccount = Contact(
  '',
  'VZDrYz39XxuPadsBN8Bkls39ObkrSltDxae1',
  null,
  '',
);
Contact chrisSlaughter = Contact(
  'Chris Slaughter',
  'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA',
  null,
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
);
Contact joshThayer = Contact(
  'Josh Thayer',
  'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA',
  null,
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
);

Message mA =
    Message(joshThayer, 'What\'s the plan?', '8/4/24', '1:38 PM', true);

Message mB = Message(
  myAccount,
  'I\'m going to send you guys invites through email later this week',
  '8/4/24',
  '1:39 PM',
  false,
);

Message mC = Message(joshThayer, 'I guess we can', '8/4/24', '1:39 PM', true);

Message mD = Message(
    joshThayer,
    'Keep me posted and I will update the schedule book',
    '8/4/24',
    '1:40 PM',
    true);

Conversation cnvo = Conversation(
  [joshThayer],
  [mA, mB, mC, mD],
);
/* END TEST INFORMATION */

class DartState {
  double currentPrice;
  double usdBalance;
  double btcBalance;
  List<Transaction> transactions;
  List<double> fees;
  List<Conversation> conversations;
  List<Contact> users;

  DartState(this.currentPrice, this.usdBalance, this.btcBalance,
      this.transactions, this.fees, this.conversations, this.users);

  factory DartState.init() {
    return DartState(0.0, 0.0, 0.0, [], [], [], []);
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
          json["conversations"].map((cnv) => Conversation.fromJson(cnv))),
      List<Contact>.from(json["users"].map((ctcs) => Contact.fromJson(ctcs))),
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
        callback3: dartCallback));
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
