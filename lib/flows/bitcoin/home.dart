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
import 'package:orange/flows/bitcoin/transaction_details.dart';

//import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/flows/bitcoin/receive/receive.dart';
import 'package:orange/util.dart';
import 'package:orange/global.dart' as global;

import 'dart:io' show Platform;

// This page serves as the main screen for Bitcoin transactions.
// It displays the user's balance in both USD and BTC, a list of recent transactions,
// and provides buttons for sending and receiving Bitcoin. The screen also shows
// optional reminders for backing up and internet connectivity.

class BitcoinHome extends StatelessWidget {
  final GlobalState globalState;
  const BitcoinHome(this.globalState, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: global.bitcoinHomeState,
      builder: (BuildContext context, BitcoinHomeState state, Widget? child) {
        return build_screen(globalState, context, state);
      },
    );
  }
}

Widget transactionListItem(GlobalState globalState, BuildContext context, BitcoinHomeTransaction transaction) {
    return DefaultListItem(
      onTap: () {
        HapticFeedback.mediumImpact();
      //navigateTo(
      //    context, TransactionDetailsWidget(globalState, transaction));
      },
      topLeft: CustomText(
        alignment: TextAlign.left,
        textType: "text",
        textSize: TextSize.md,
        text: transaction.isReceive ? "Received bitcoin" : "Sent bitcoin",
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

Widget build_screen(GlobalState globalState, BuildContext context, BitcoinHomeState state) {
  //var textSize = formatValue(state.usdBalance).length <= 4
  //    ? TextSize.title
  //    : formatValue(state.usdBalance).length <= 7
  //        ? TextSize.h1
  //        : TextSize.h2;
    return Interface(
      globalState,
      resizeToAvoidBottomInset: false,
      header: homeHeader(
        context,
        globalState,
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
                    text: state.usd,// state.usdBalance == 0 ? "\$0.00" : "\$${formatValue(state.usdBalance)}",
                    textSize: TextSize.h1,
                    color: ThemeColor.heading,
                  ),
                  const Spacing(height: AppPadding.valueDisplaySep),
                  CustomText(
                    textType: "text",
                    text: state.btc,// "${formatBTC(state.btcBalance, 8)} BTC",
                    textSize: TextSize.lg,
                    color: ThemeColor.textSecondary,
                  ),
                ],
              ),
            ),
            const Spacing(height: AppPadding.content),
            _backupReminder(false),
            _noInternet(false),
            state.transactions.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const ScrollPhysics(),
                        itemCount: state.transactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return transactionListItem(
                              globalState, context, state.transactions[index]);
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
        //var address =
        //    (await globalState.invoke("get_new_address", "")).data;
          navigateTo(context, Receive(globalState));
        },
        () {
          //navigateTo(context, Send(globalState));
        },
        false //globalState.isDesktop ? true : false,
      ),
      navigationIndex: 0,
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
