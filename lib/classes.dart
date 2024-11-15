// ignore_for_file: constant_identifier_names

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/error.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:async';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orange/global.dart' as global;

import 'package:orange/src/rust/api/pub_structs.dart';

import 'dart:io' as DartIO;
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

/* Manages and triggers shake animations by notifying listeners. */
class ShakeController extends ChangeNotifier {
  void shake() => notifyListeners();
}

abstract class GenericWidget extends StatefulWidget {
  Timer? timer;
  CancelableOperation<String>? async_state;
  bool pause_refresh = false;

  GenericWidget({super.key});
}

abstract class GenericState<T extends GenericWidget> extends State<T> {
  PageName getPageName();
  int refreshInterval();
  Widget build_with_state(BuildContext context);

  void unpack_state(Map<String, dynamic> json);

  void getState() async {
    int time = DateTime.now().millisecondsSinceEpoch;
    widget.async_state = CancelableOperation.fromFuture(
        getPage(path: global.dataDir!, page: getPageName()),
    );
    widget.async_state!.then((String state) {
        //print("gotstate in ${DateTime.now().millisecondsSinceEpoch - time}");
        if (!widget.pause_refresh) {
          unpack_state(jsonDecode(state));
          _createTimer();
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: widget.async_state?.value,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return build_with_state(context);
          } else {
            return Container();
          }
        });
  }

  navigateTo(Widget next) async {
    widget.pause_refresh = true;
    widget.timer?.cancel();
    await global.navigation.navigateTo(next);
    widget.pause_refresh = false;
    await _createTimer();
  }

  _createTimer() {
    widget.timer?.cancel();
    var interval = refreshInterval();
    if (interval > 0) {
      widget.timer = Timer(Duration(milliseconds: interval), () {
        getState();
      });
    }
  }

  @override
  void initState() {
    getState();
    super.initState();
  }

  @override
  void dispose() {
    //widget.gettingState!.cancel();
    widget.async_state?.cancel();
    widget.timer?.cancel();
    super.dispose();
  }
}

//  class ShorthandTransaction {
//    String usd;
//    double btc;
//    String date;
//    String time;
//    bool is_withdraw;
//    String txid;

//    ShorthandTransaction(this.usd, this.btc, this.date, this.time, this.is_withdraw, this.txid);

//    @override
//    factory ShorthandTransaction.fromJson(Map<String, dynamic> json) {
//      return ShorthandTransaction(
//        json['usd'] as String,
//        json['btc'] as double,
//        json['date'] as String,
//        json['time'] as String,
//        json['is_withdraw'] as bool,
//        json['txid'] as String,
//      );
//    }
//  }

//  class ExtTransaction {
//    BasicTransaction tx;
//    String fee;
//    String total;

//    ExtTransaction(this.fee, this.total, this.tx);

//    @override
//    factory ExtTransaction.fromJson(Map<String, dynamic> json) {
//      return ExtTransaction(
//        json['fee'] as String,
//        json['total'] as String,
//        BasicTransaction.fromJson(json['tx']),
//      );
//    }
//  }

//  class BasicTransaction {
//    ShorthandTransaction tx;
//    String address;
//    String price;

//    BasicTransaction(this.address, this.price, this.tx);

//    @override
//    factory BasicTransaction.fromJson(Map<String, dynamic> json) {
//      return BasicTransaction(
//        json['address'] as String,
//        json['price'] as String,
//        ShorthandTransaction.fromJson(json['tx']),
//      );
//    }
//  }

//  class Transaction {
//    bool isReceive;
//    String? sentAddress;
//    String txid;
//    double usd;
//    double btc;
//    double price;
//    double fee;
//    String? date;
//    String? time;
//    String? raw;

//    Transaction(this.isReceive, this.sentAddress, this.txid, this.usd, this.btc, this.price, this.fee, this.date, this.time, this.raw);

//    factory Transaction.fromJson(Map<String, dynamic> json) {
//      return Transaction(
//        json['isReceive'] as bool,
//        json['sentAddress'] as String?,
//        json['txid'] as String,
//        json['usd'] as double,
//        json['btc'] as double,
//        json['price'] as double,
//        json['fee'] as double,
//        json['date'] as String?,
//        json['time'] as String?,
//        json['raw'] as String?,
//      );
//    }
//  }

//  class Profile {
//    String name;
//    String did;
//    String? pfp;
//    String? abtme;
//    Profile(this.name, this.did, this.pfp, this.abtme);

//    factory Profile.fromJson(Map<String, dynamic> json) {
//      return Profile(
//        json['name'] as String,
//        json['did'] as String,
//        json['pfp'] as String?,
//        json['abtme'] as String?,
//      );
//    }
//  }

//  class Message {
//    Profile sender;
//    String message;
//    String date;
//    String time;
//    bool isIncoming;

//    Message(this.sender, this.message, this.date, this.time, this.isIncoming);
//    factory Message.fromJson(Map<String, dynamic> json) {
//      return Message(
//        Profile.fromJson(json['sender']),
//        json['message'] as String,
//        json['date'] as String,
//        json['time'] as String,
//        json['is_incoming'] as bool,
//      );
//    }
//  }

//  class Conversation {
//    List<Profile> members;
//    List<Message> messages;

//    Conversation(this.members, this.messages);
//    factory Conversation.fromJson(Map<String, dynamic> json) {
//      return Conversation(
//        List<Profile>.from(json['members'].map((json) => Profile.fromJson(json))),
//        List<Message>.from(json['messages'].map((json) => Message.fromJson(json))),
//      );
//    }
//  }

//  class DartState {
//    double currentPrice;
//    double usdBalance;
//    double btcBalance;
//    List<Transaction> transactions;
//    List<double> fees;
//    List<Conversation> conversations;
//    List<Profile> users;
//    Profile personal;

//    DartState(
//      this.currentPrice,
//      this.usdBalance,
//      this.btcBalance,
//      this.transactions,
//      this.fees,
//      this.conversations,
//      this.users,
//      this.personal,
//    );

//    factory DartState.init() {
//      return DartState(0.0, 0.0, 0.0, [], [], [], [], Profile('', '', '', ''));
//    }

//    factory DartState.fromJson(Map<String, dynamic> json) {
//      return DartState(
//        json['currentPrice'] as double,
//        json['usdBalance'] as double,
//        json['btcBalance'] as double,
//        List<Transaction>.from(json['transactions'].map((tx) => Transaction.fromJson(tx))),
//        List<double>.from(json['fees'].map((fee) => fee as double)),
//        List<Conversation>.from(json["conversations"].map((y) => Conversation.fromJson(y))),
//        List<Profile>.from(json["users"].map((i) => Profile.fromJson(i))),
//        Profile.fromJson(json["personal"]),
//      );
//    }
//  }

//  class GlobalState {
//    FlutterSecureStorage storage = const FlutterSecureStorage();
//    SharedPreferences prefs;
//    GlobalKey<NavigatorState> navkey;
//    List<RustR> rustResponses = [];
//    List<RustC> rustCommands = [];
//    Uuid uuid = const Uuid();
//    int counter = 0;

//    ValueNotifier<DartState> state = ValueNotifier(DartState.init());

//    GlobalState(this.navkey, this.prefs);

//    factory GlobalState.init(sp) {
//      var state = GlobalState(GlobalKey<NavigatorState>(), sp);
//      //if (Platform.isWindows && Platform.isLinux && Platform.isMacOS && Platform.isAndroid && Platform.isIOS && Platform.isFuchsia) {
//      //    state.error("Platform is unknown");
//      //}
//      //state.startRust();
//      return state;
//    }

//  //Future<void> startRust() async {
//  //  Directory appDocDirectory = await getApplicationDocumentsDirectory();
//  //  Directory mydir =
//  //      await Directory('${appDocDirectory.path}/').create(recursive: true);
//  //  error(await rustStart(
//  //      path: mydir.path,
//  //      callback: dartCallback,
//  //      callback1: dartCallback,
//  //      callback2: dartCallback,
//  //      callback3: dartCallback,
//  //      callback4: dartCallback));
//  //}

//  //BuildContext? getContext() {
//  //  return navkey.currentContext;
//  //}

//    void error(String err) {
//      Navigator.pushReplacement(
//        navkey.currentContext!,
//        MaterialPageRoute(builder: (context) => ErrorPage(message: err)),
//      );
//    }

//    Future<RustR> invoke(String method, String data) async {
//      var uid = uuid.v1();
//      var command = RustC(uid, method, data);
//      print(jsonEncode(command));
//      rustCommands.add(command);
//      while (true) {
//        var index = rustResponses.indexWhere((res) => res.uid == uid);
//        if (index != -1) {
//          return rustResponses.removeAt(index);
//        }
//        await Future.delayed(const Duration(milliseconds: 10));
//      }
//    }

//  //Future<void> clearStorage() async {
//  //  final os = checkPlatform();
//  //  if (os == "IOS") {
//  //    final keys = await this.storage.readAll();

//  //    for (var key in keys.keys) {
//  //      await this.storage.delete(key: key);
//  //    }
//  //    print("IOS storage cleared");
//  //  } else if (os == "Android") {
//  //    final SharedPreferences pref = await SharedPreferences.getInstance();

//  //    await pref.clear();
//  //    print("Android storage cleared");
//  //  } else {
//  //    print("cannot clear storage, desktop found");
//  //    return;
//  //  }
//  //}

//  //String checkPlatform() {
//  //  if (Platform.isAndroid) {
//  //    return "Android";
//  //  } else if (Platform.isIOS) {
//  //    return 'IOS';
//  //  } else if (Platform.isLinux) {
//  //    return 'Linux';
//  //  } else if (Platform.isMacOS) {
//  //    return 'MacOS';
//  //  } else if (Platform.isWindows) {
//  //    return 'Windows';
//  //  } else {
//  //    return 'Unknown';
//  //  }
//  //}

//    Future<void> iosWrite(data) async {
//      var split = data.split("\u0000");
//      await this.storage.write(key: split[0], value: split[1]);
//    }

//    Future<String> iosRead(data) async {
//      return await this.storage.read(key: data) ?? "";
//    }

//    Future<void> androidWrite(String data) async {
//      // Split the data by the delimiter
//      var split = data.split("\u0000");
//      String key = split[0];
//      String value = split[1];
//      // Obtain SharedPreferences instance
//      final SharedPreferences prefs = await SharedPreferences.getInstance(); // Write the data to SharedPreferences
//      await prefs.setString(key, value);
//    }

//    Future<String> androidRead(String key) async {
//      // Obtain SharedPreferences instance
//      final SharedPreferences prefs = await SharedPreferences.getInstance(); // Read the value associated with the key, returning an empty string if the key doesn't exist
//      return prefs.getString(key) ?? "";
//    }

//    Future<String> dartCallback(String dartCommand) async {
//      var command = DartCommand.fromJson(jsonDecode(dartCommand));
//      switch (command.method) {
//        case "add":
//          counter += 1;
//        case "set_state":
//          print(DartState.fromJson(jsonDecode(command.data)));
//          state.value = DartState.fromJson(jsonDecode(command.data));
//        case "ios_get":
//          return await iosRead(command.data);
//        case "ios_set":
//          await iosWrite(command.data);
//        case "android_get":
//          return await androidRead(command.data);
//        case "android_set":
//          await androidWrite(command.data);
//        case "print":
//          print(command.data);
//        case "get_commands":
//          var json = jsonEncode(rustCommands);
//          rustCommands = [];
//          return json;
//        case "post_response":
//          print(dartCommand);
//          rustResponses.add(RustR.fromJson(jsonDecode(command.data)));
//  //    case "clear_storage":
//  //      await clearStorage();
//  //      return "Storage cleared";
//  //    case "check_os":
//  //      return checkPlatform();
//        case "error":
//          print(command.data);
//        case var unknown:
//          return "Error:UnknownMethod:$unknown";
//      }
//      return "Ok";
//    }
//  }

//  class DartCommand {
//    final String method;
//    final String data;

//    DartCommand(this.method, this.data);

//    factory DartCommand.fromJson(Map<String, dynamic> json) {
//      return DartCommand(json['method'] as String, json['data'] as String);
//    }
//  }

//  class RustC {
//    final String uid;
//    final String method;
//    final String data;

//    RustC(this.uid, this.method, this.data);

//    factory RustC.fromJson(Map<String, dynamic> json) {
//      return RustC(json['uid'] as String, json['method'] as String, json['data'] as String);
//    }

//    Map<String, dynamic> toJson() => {
//          'uid': uid,
//          'method': method,
//          'data': data,
//        };
//  }

//  class RustR {
//    final String uid;
//    final String data;

//    RustR(this.uid, this.data);

//    factory RustR.fromJson(Map<String, dynamic> json) {
//      return RustR(json['uid'] as String, json['data'] as String);
//    }

//    Map<String, dynamic> toJson() => {
//          'uid': uid,
//          'data': data,
//        };
//  }
