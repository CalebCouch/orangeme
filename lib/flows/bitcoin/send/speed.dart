import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/radio_selectors.dart';
import 'package:orange/flows/bitcoin/send/confirm.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'dart:convert';

// BITCOIN SEND STEP THREE //

// This page allows users to select the transaction speed for sending Bitcoin.
// Users can choose between different speeds and associated fees,
// and proceed to confirm the transaction.

class TransactionSpeed extends StatefulWidget {
  final GlobalState globalState;
  final String address;
  final double btc;

  const TransactionSpeed(this.globalState, this.address, this.btc, {super.key});

  @override
  TransactionSpeedState createState() => TransactionSpeedState();
}

class TransactionSpeedState extends State<TransactionSpeed> {
  int index = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  @override
  void initState() {
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  Future<void> next() async {
    setState(() {
      isLoading = true;
    });
    Transaction tx = Transaction.fromJson(jsonDecode((await widget.globalState
            .invoke(
                "create_transaction", "${widget.address}|${widget.btc}|$index"))
        .data));
    navigateTo(context, ConfirmSend(widget.globalState, tx));
    setState(() {
      isLoading = false;
    });
  }

  Widget buildScreen(BuildContext context, DartState state) {
    var fees = widget.globalState.state.value.fees;
    return Interface(
      widget.globalState,
      header:
          isLoading ? Container() : stackHeader(context, "Transaction speed"),
      content: isLoading
          ? loadingCircle()
          : Content(children: [
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
      bumper: isLoading ? null : singleButtonBumper(context, "Continue", next),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}

Widget loadingCircle() {
  return const Center(
      child: CircularProgressIndicator(
    strokeCap: StrokeCap.round,
    backgroundColor: ThemeColor.bgSecondary,
  ));
}
