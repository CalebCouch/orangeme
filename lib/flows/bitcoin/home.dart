import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/flows/bitcoin/transaction_details.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
// import 'package:flutter/services.dart';
// import 'package:orange/components/list_item.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/flows/bitcoin/receive/receive.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/global.dart' as global;

class BitcoinHome extends GenericWidget {
  BitcoinHome({super.key});
  String usdUnformatted = "";
  String usd = "";
  String btc = "";
  List<ShorthandTransaction> transactions = [];
  String profile_picture = "";
  bool internet = true;

  @override
  BitcoinHomeState createState() => BitcoinHomeState();
}

class BitcoinHomeState extends GenericState<BitcoinHome> {
  @override
  String stateName() {
    return "BitcoinHome";
  }

  @override
  int refreshInterval() {
    return 1;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.usd = json["usd"];
      widget.btc = json["btc"];
      widget.transactions = List<ShorthandTransaction>.from(json['transactions'].map((json) => ShorthandTransaction.fromJson(json)));
      widget.internet = json["internet"] as bool;
      widget.profile_picture = json["profile_picture"];
    });
  }

  onReceive() {
    navigateTo(Receive());
  }

  onSend() {
    navigateTo(Send());
  }

  toProfile() {
    navigateTo(MyProfile());
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.transactions);
    bool noTransactions = widget.transactions.isEmpty;
    return Root_Home(
      Header_Home(ProfileButton(context, widget.profile_picture, toProfile), "Wallet"),
      [
        BalanceDisplay(),
        //  BackupReminder(false),
        NoInternet(widget.internet),
        TransactionList(),
      ],
      Bumper(context, [
        CustomButton('Receive', 'primary lg expand none', onReceive, !widget.internet ? "disabled" : "enabled"),
        CustomButton('Send', 'primary lg expand none', onSend, !widget.internet ? "disabled" : "enabled"),
      ]),
      TabNav(0, [
        TabInfo(BitcoinHome(), 'wallet'),
        TabInfo(MessagesHome(), 'message'),
      ]),
      noTransactions && widget.internet ? Alignment.center : Alignment.topCenter,
      !noTransactions,
    );
  }

//The following widgets can ONLY be used in this file

  Widget BalanceDisplay() {
    dynamic_size(x) {
      if (x <= 4) return 'title';
      if (x <= 7) return 'h1';
      return 'h2';
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: CustomColumn([
        CustomText('heading ${dynamic_size(widget.usdUnformatted.length)}', "\$${widget.usd}"),
        CustomText('text lg text_secondary', '${widget.btc} BTC')
      ], AppPadding.valueDisplaySep),
    );
  }

  Widget BackupReminder(bool display) {
    return display
        ? CustomBanner(
            'orange recommends that you back\n your phone up to the cloud.',
          )
        : Container();
  }

  Widget NoInternet(bool internet) {
    return internet
        ? Container()
        : CustomBanner(
            'You are not connected to the internet.\norange requires an internet connection.',
          );
  }

  Widget TransactionList() {
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      physics: const ScrollPhysics(),
      itemCount: widget.transactions.length,
      itemBuilder: (BuildContext context, int index) {
        return TransactionItem(widget.transactions[index]);
      },
    );
  }

  Widget TransactionItem(ShorthandTransaction transaction) {
    return ListItem(
      onTap: () {
        HapticFeedback.mediumImpact();
        navigateTo(ViewTransaction(txid: transaction.txid.toString()));
      },
      title: transaction.is_withdraw ? "Sent bitcoin" : "Received bitcoin",
      sub: formatTransactionDate(date: transaction.date, time: transaction.time),
      titleR: transaction.usd,
      subR: "Details",
      caret: false,
    );
  }
}
