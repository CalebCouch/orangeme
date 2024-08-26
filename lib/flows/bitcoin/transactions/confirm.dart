import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/send/insert_usb.dart';
import 'dart:io' show Platform;
import 'package:orange/flows/bitcoin/send/success.dart';
import 'package:orange/flows/bitcoin/transactions/canceled.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/tabular.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/amount_display.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class ConfirmSend extends StatefulWidget {
  final GlobalState globalState;
  final Transaction transaction;
  const ConfirmSend(this.globalState, this.transaction, {super.key});

  @override
  ConfirmSendState createState() => ConfirmSendState();
}

class ConfirmSendState extends State<ConfirmSend> {
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
    /* await widget.globalState
        .invoke("broadcast_transaction", widget.transaction.txid);*/
    navigateTo(
        context, Confirmation(widget.globalState, widget.transaction.usd));
  }

  Widget buildScreen(BuildContext context, DartState state) {
    bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    return Interface(
      widget.globalState,
      header: stackHeader(context, "Sending bitcoin"),
      content: Content(
        content: Column(
          children: [
            amountDisplay(
              (widget.transaction.usd.abs() - widget.transaction.fee.abs()),
              (widget.transaction.btc).abs(),
            ),
            const Spacing(height: AppPadding.content),
            transactionTabular(context, widget.transaction),
          ],
        ),
      ),
      bumper: doubleButtonBumper(
        context,
        "Cancel",
        "Confirm",
        () {
          navigateTo(context, Canceled(widget.globalState));
        },
        onDesktop
            ? () {
                InsertUSB(
                  widget.globalState,
                  isConfirmationTakeover: true,
                );
              }
            : next,
        true,
        true,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
