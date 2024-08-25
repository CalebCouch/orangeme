import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/radio_selectors.dart';

import 'package:orange/flows/new_wallet/spending/new_spending.dart';
import 'package:orange/flows/new_wallet/savings/new_savings.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class WalletType extends StatefulWidget {
  final GlobalState globalState;

  const WalletType(this.globalState, {super.key});

  @override
  WalletTypeState createState() => WalletTypeState();
}

class WalletTypeState extends State<WalletType> {
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

  Widget buildScreen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: stackHeader(
        context,
        "Add wallet",
      ),
      content: Content(
        content: Column(children: <Widget>[
          radioButton(
            "Spending",
            "Create a bitcoin wallet stored on your phone for easy use",
            index == 0,
            () {
              setState(() {
                index = 0;
              });
            },
          ),
          const Spacing(height: 16),
          radioButton(
            "Savings",
            "Create a bitcoin wallet that is safe even if your phone gets hacked",
            index == 1,
            () {
              setState(() {
                index = 1;
              });
            },
          ),
        ]),
      ),
      bumper: singleButtonBumper(context, "Continue", () {
        if (index == 0) {
          navigateTo(context, NewSpending(widget.globalState, 1));
        } else {
          navigateTo(context, NewSavings(widget.globalState));
        }
      }),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
