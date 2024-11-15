import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/list_item.dart';
//import 'package:orange/flows/bitcoin/transaction_details.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
// import 'package:flutter/services.dart';
// import 'package:orange/components/list_item.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/flows/bitcoin/receive/receive.dart';
//import 'package:orange/flows/bitcoin/send/send.dart';
//import 'package:orange/flows/messages/home.dart';
//import 'package:orange/flows/messages/profile/my_profile.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';

class BitcoinHome extends GenericWidget {
    BitcoinHome({super.key});
    bool internet = true;
    String? profile_picture;
    String balance_usd = "";
    String balance_btc = "";

    List<ShorthandTransaction> transactions = [];

    @override
    BitcoinHomeState createState() => BitcoinHomeState();
}

class BitcoinHomeState extends GenericState<BitcoinHome> {
    @override
    PageName getPageName() {
        return PageName.bitcoinHome();
    }

    @override
    int refreshInterval() {
        return 1;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            widget.internet = json["internet"] as bool;
            widget.profile_picture = json["profile_picture"] as String?;
            widget.balance_usd = json["usd"];
            widget.balance_btc = json["btc"];

            widget.transactions = List<ShorthandTransaction>.from(json['transactions'].map((json) => ShorthandTransaction.fromJson(json)));
        });
    }

    onReceive() {navigateTo(Receive());}
//  onSend() {navigateTo(Send());}
//  toProfile() {navigateTo(MyProfile());}

    @override
    Widget build_with_state(BuildContext context) {
        bool noTransactions = widget.transactions.isEmpty;
        return Root_Home(
            Header_Home(ProfileButton(context, widget.profile_picture, onReceive), "Wallet"),
            [
                BalanceDisplay(),
                //  BackupReminder(false),
                InternetBanner(widget.internet),
                TransactionList(),
            ],
            Bumper(context, [
                CustomButton('Receive', 'primary lg expand none', onReceive, widget.internet),
                CustomButton('Send', 'primary lg expand none', onReceive, widget.internet),
            ]),
            TabNav(0, [
                TabInfo(BitcoinHome(), 'wallet'),
                TabInfo(BitcoinHome(), 'message'),
            ]),
            noTransactions && widget.internet ? Alignment.center : Alignment.topCenter,
            !noTransactions,
        );
    }

    //The following widgets can ONLY be used in this file
    String get_size(int usd) {
        return usd <= 4 ? 'title' : usd <= 7 ? 'h1' : 'h2';
    }

    Widget BalanceDisplay() {
        return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: CustomColumn([
                CustomText(
                    'heading ${get_size(widget.balance_usd.length)}',
                    widget.balance_usd
                ),
                CustomText(
                    'text lg text_secondary',
                    widget.balance_btc
                )],
                AppPadding.valueDisplaySep
            ),
        );
    }

    Widget BackupReminder(bool display) {
        return display ? Container() : CustomBanner(
            'orange recommends that you back\n your phone up to the cloud.',
        );
    }

    Widget InternetBanner(bool internet) {
        return internet ? Container() : CustomBanner(
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
              //navigateTo(ViewTransaction(txid: transaction.txid.toString()));
            },
            title: transaction.is_withdraw ? "Sent bitcoin" : "Received bitcoin",
            sub: formatTransactionDate(transaction.date, transaction.time),
            titleR: transaction.usd,
            subR: "Details",
            caret: false,
        );
    }
}

