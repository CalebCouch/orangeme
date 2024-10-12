import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/transaction_details.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/flows/bitcoin/receive/receive.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class BitcoinHome extends GenericWidget {
  BitcoinHome({super.key});
  String usdUnformatted = "";
  String usd = ""; // usdUnformatted == "0" ? "\$0.00" : "\$formatValue(widget.usdUnformatted)"
  String btc = ""; //formatBTC(state.btcBalance, 8)
  List<BitcoinHomeTransaction> transactions = []; // Need date (11/3/24) and time (9:53 PM) // Need to know if the transaction was sent or received
  Contact personal = Contact('', '', '', ''); //Users personal information

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
      widget.transactions = List<BitcoinHomeTransaction>.from(json['transactions'].map((json) => BitcoinHomeTransaction.fromJson(json)));
      //widget.personal
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
    bool noTransactions = widget.transactions.isEmpty;
    return Root_Home(
      Header_Home(ProfileButton(context, widget.personal.pfp, toProfile), "Wallet"),
      [
        BalanceDisplay(),
        //  BackupReminder(false),
        //  NoInternet(false),
        TransactionList(),
      ],
      Bumper(context, [
        CustomButton('Receive', 'primary lg enabled expand none', onReceive),
        CustomButton('Send', 'primary lg enabled expand none', onSend),
      ]),
      TabNav(0, [
        TabInfo(BitcoinHome(), 'wallet'),
        TabInfo(MessagesHome(), 'message'),
      ]),
      noTransactions ? Alignment.center : Alignment.topCenter,
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
        CustomText('heading ${dynamic_size(widget.usdUnformatted.length)}', widget.usd),
        CustomText('text lg text_secondary', '${widget.btc} BTC')
      ], AppPadding.valueDisplaySep),
    );
  }

  Widget BackupReminder(bool display) {
    return display
        ? const CustomBanner(
            'orange.me recommends that you back\n your phone up to the cloud.',
          )
        : Container();
  }

  Widget NoInternet(bool display) {
    return display
        ? const CustomBanner(
            'You are not connected to the internet.\norange.me requires an internet connection.',
            isError: true,
          )
        : Container();
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
    return Container(); /*ListItem(
      onTap: () {
        HapticFeedback.mediumImpact();
        navigateTo(context, TransactionDetails(transaction));
      },
      title: transaction.isReceive ? "Received bitcoin" : "Sent bitcoin",
      sub: formatDate(transaction.date, transaction.time),
      titleR: "\$${transaction.usd}",
      subR: "Details",
    );*/
  }
}
