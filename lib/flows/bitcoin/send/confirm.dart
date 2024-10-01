import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/flows/bitcoin/send/success.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/flows/bitcoin/send/speed.dart';
import 'package:orange/flows/bitcoin/send/send.dart';

import 'package:orange/components/interface.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/data_item.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

/* BITCOIN SEND STEP FOUR */

// The ConfirmSend class provides a confirmation screen for a Bitcoin transaction.
// It allows users to review the transaction details, such as the recipient address
// and amount, and provides options to confirm and send the transaction or adjust
// the amount or speed settings.

class ConfirmSend extends StatefulWidget {
  final GlobalState globalState;
  final Transaction tx;
  const ConfirmSend(this.globalState, this.tx, {super.key});

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<ConfirmSend> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Future<void> next() async {
    await widget.globalState.invoke("broadcast_transaction", widget.tx.txid);
    navigateTo(context, Confirmation(widget.globalState, widget.tx.usd));
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: stackHeader(context, 'Confirm send'),
      content: Content(
        children: [
          confirmAddress(context, widget.globalState, widget.tx),
          confirmAmount(context, widget.globalState, widget.tx),
        ],
      ),
      bumper: singleButtonBumper(context, "Confirm & Send", next),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}

confirmAddress(BuildContext context, GlobalState globalState, tx) {
  return DataItem(
    title: "Confirm Address",
    listNum: 1,
    content: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacing(height: AppPadding.bumper),
        CustomText(
          textSize: TextSize.md,
          alignment: TextAlign.left,
          text: tx.sentAddress!,
        ),
        const Spacing(height: AppPadding.bumper),
        const CustomText(
          textSize: TextSize.sm,
          color: ThemeColor.textSecondary,
          alignment: TextAlign.left,
          text: "Bitcoin sent to the wrong address can never be recovered.",
        ),
        const Spacing(height: AppPadding.bumper),
      ],
    ),
    buttonNames: const ["Address"],
    buttonActions: [
      () {
        Send(
          globalState,
          address: tx.sentAddress!,
        );
      }
    ],
  );
}

confirmAmount(BuildContext context, GlobalState globalState, tx) {
  return DataItem(
    title: "Confirm Amount",
    listNum: 2,
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.bumper),
      child: confirmationTabular(context, tx),
    ),
    buttonNames: const ["Amount", "Speed"],
    buttonActions: [
      () {
        resetNavTo(
          context,
          SendAmount(globalState, tx.sentAddress!),
        );
      },
      () {
        resetNavTo(
          context,
          TransactionSpeed(
            globalState,
            tx.sentAddress!,
            tx.btc.abs(),
          ),
        );
      }
    ],
  );
}
