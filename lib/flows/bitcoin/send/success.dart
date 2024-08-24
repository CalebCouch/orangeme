import 'package:flutter/material.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/result.dart';

import 'package:orange/flows/bitcoin/home.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

// This page displays a confirmation screen after a Bitcoin transaction has been sent.
// It shows the transaction amount and provides a button to return to the home screen.

class Confirmation extends StatefulWidget {
  final double amount;
  final GlobalState globalState;
  const Confirmation(this.globalState, this.amount, {super.key});

  @override
  ConfirmationState createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
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

  Widget buildScreen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: stackHeader(
        context,
        "Confirm send",
        false,
        exitButton(context, BitcoinHome(widget.globalState)),
      ),
      content: Content(
        content: result('You sent \$${formatValue(widget.amount.abs())}'),
      ),
      bumper: singleButtonBumper(
        context,
        "Done",
        () => {
          resetNavTo(
            context,
            BitcoinHome(widget.globalState),
          ),
        },
        true,
        ButtonVariant.secondary,
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
