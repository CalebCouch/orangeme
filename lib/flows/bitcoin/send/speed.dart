import 'package:flutter/material.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/radio_selectors.dart';
import 'package:orange/flows/bitcoin/send/confirm.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'dart:convert';

class TransactionSpeed extends StatefulWidget {
  final GlobalState globalState;
  final String address;
  final double btc;

  const TransactionSpeed(this.globalState, this.address, this.btc, {super.key});

  @override
  TransactionSpeedState createState() => TransactionSpeedState();
}

class TransactionSpeedState extends State<TransactionSpeed> {
  final TextEditingController recipientAddressController =
      TextEditingController();
  int index = 0;

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
    Transaction tx = Transaction.fromJson(jsonDecode((await widget.globalState
            .invoke(
                "create_transaction", "${widget.address}|${widget.btc}|$index"))
        .data));
    navigateTo(context, ConfirmSend(widget.globalState, tx));
  }

  Widget buildScreen(BuildContext context, DartState state) {
    var fees = widget.globalState.state.value.fees;
    return Interface(
      widget.globalState,
      header: stackHeader(
        context,
        "Transaction speed",
      ),
      content: Content(
        content: Column(children: <Widget>[
          radioButton(
            "Standard",
            "Arrives in ~2 hours\n\$${formatValue(fees[0])} bitcoin network fee",
            index == 0,
            () {
              setState(() {
                index = 0;
              });
            },
          ),
          radioButton(
            "Priority",
            "Arrives in ~30 minutes\n\$${formatValue(fees[1])} bitcoin network fee",
            index == 1,
            () {
              setState(() {
                index = 1;
              });
            },
          ),
        ]),
      ),
      bumper: singleButtonBumper(context, "Continue", next),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
