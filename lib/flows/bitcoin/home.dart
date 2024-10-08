import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:flutter/services.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/global.dart' as global;

import 'package:orange/flows/bitcoin/receive/receive.dart';

// This page serves as the main screen for Bitcoin transactions.
// It displays the user's balance in both USD and BTC, a list of recent transactions,
// and provides buttons for sending and receiving Bitcoin. The screen also shows
// optional reminders for backing up and internet connectivity.

class BitcoinHome extends GenericWidget {
    BitcoinHome({super.key});

    String usd = "";
    String btc = "";
    List<BitcoinHomeTransaction> transactions = [];

    @override
    BitcoinHomeState createState() => BitcoinHomeState();
}

class BitcoinHomeState extends GenericState<BitcoinHome> {
    @override
    String stateName() {return "BitcoinHome";}
    @override
    int refreshInterval() {return 3000;}

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState((){
            widget.usd = json["usd"];
            widget.btc = json["btc"];
            widget.transactions = List<BitcoinHomeTransaction>.from(json['transactions'].map((json) => BitcoinHomeTransaction.fromJson(json)));
        });
    }

    @override
    Widget build(BuildContext context) {
        var textSize = widget.usd.length <= 4 ? TextSize.title : widget.usd.length <= 7 ? TextSize.h1 : TextSize.h2;
        return Interface(
          resizeToAvoidBottomInset: false,
          header: homeHeader(
            context,
            "Wallet",
            null, //state.personal.pfp,
          ),
          content: Content(
            content: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppPadding.valueDisplay),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        textType: "heading",
                        text: widget.usd,// state.usdBalance == 0 ? "\$0.00" : "\$${formatValue(state.usdBalance)}",
                        textSize: textSize,
                        color: ThemeColor.heading,
                      ),
                      const Spacing(height: AppPadding.valueDisplaySep),
                      CustomText(
                        textType: "text",
                        text: widget.btc,// "${formatBTC(state.btcBalance, 8)} BTC",
                        textSize: TextSize.lg,
                        color: ThemeColor.textSecondary,
                      ),
                    ],
                  ),
                ),
                const Spacing(height: AppPadding.content),
              //_backupReminder(false),
              //_noInternet(!global.internet_connected),
                widget.transactions.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: const ScrollPhysics(),
                            itemCount: widget.transactions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return transactionListItem(context, widget.transactions[index]);
                            },
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          bumper: doubleButtonBumper(
            context,
            "Receive",
            "Send",
            () async {
                global.navigation.switchPageTo(Receive());
            },
            () {
              //navigateTo(context, Send());
            },
            global.platform_isDesktop
          ),
          navigationIndex: 0,
        );
    }

    Widget transactionListItem(BuildContext context, BitcoinHomeTransaction transaction) {
        return DefaultListItem(
          onTap: () {
            HapticFeedback.mediumImpact();
          //navigateTo(
          //    context, TransactionDetailsWidget(transaction));
          },
          topLeft: CustomText(
            alignment: TextAlign.left,
            textType: "text",
            textSize: TextSize.md,
            text: transaction.is_withdraw ? "Received bitcoin" : "Sent bitcoin",
          ),
          bottomLeft: CustomText(
            alignment: TextAlign.left,
            textSize: TextSize.sm,
            color: ThemeColor.textSecondary,
            text: transaction.datetime, //formatDate(transaction.date, transaction.time),
          ),
          topRight: CustomText(
            alignment: TextAlign.right,
            textSize: TextSize.md,
            text: transaction.usd,//"\$${formatValue((transaction.usd).abs())}",
          ),
          bottomRight: const CustomText(
            alignment: TextAlign.right,
            textSize: TextSize.sm,
            color: ThemeColor.textSecondary,
            text: "Details",
            underline: true,
          ),
        );
    }

    _backupReminder(bool display) {
      if (display) {
        return const CustomBanner(
          message:
              'orange.me recommends that you back\n your phone up to the cloud.',
        );
      }
      return Container();
    }

    _noInternet(bool display) {
      if (display) {
        return const CustomBanner(
          message:
              'You are not connected to the internet.\norange.me requires an internet connection.',
          isError: true,
        );
      }
      return Container();
    }
}
