import 'package:flutter/material.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/radio_selectors.dart';

import 'package:orange/flows/wallet_flow/send_flow/confirm_send.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class TransactionSpeed extends StatefulWidget {
  final GlobalState globalState;
  final double priorityFee;
  final double standardFee;

  const TransactionSpeed(this.globalState,
      {super.key, this.priorityFee = 3.14, this.standardFee = 5.45});

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

  Widget buildScreen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: stackHeader(
        context,
        "Transaction speed",
      ),
      content: Content(
        content: Column(children: <Widget>[
          radioButton(
            "Priority",
            "Arrives in ~30 minutes\n\$${widget.priorityFee} bitcoin network fee",
            index == 0 ? true : false,
            () {
              setState(() {
                index = 0;
              });
            },
          ),
          radioButton(
            "Standard",
            "Arrives in ~2 hours\n\$${widget.standardFee} bitcoin network fee",
            index == 1 ? true : false,
            () {
              setState(() {
                index = 1;
              });
            },
          )
        ]),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, ConfirmSend(widget.globalState));
        },
      ),
    );
  }
}
