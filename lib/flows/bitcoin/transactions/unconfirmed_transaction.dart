import 'package:flutter/material.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/flows/bitcoin/transactions/transaction_details.dart';
import 'dart:io' show Platform;

import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';

import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class UnconfirmedTransaction extends StatefulWidget {
  final GlobalState globalState;
  final Transaction transaction;
  const UnconfirmedTransaction(this.globalState, this.transaction, {super.key});

  @override
  UnconfirmedTransactionState createState() => UnconfirmedTransactionState();
}

class UnconfirmedTransactionState extends State<UnconfirmedTransaction> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  Widget buildScreen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: stackHeader(
        context,
        onDesktop ? "Confirm on mobile" : "Confirm on desktop",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Image.asset(onDesktop
                  ? 'assets/images/mockups/confirm-on-mobile.png'
                  : 'assets/images/mockups/confirm-on-desktop.png'),
            ),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              onDesktop
                  ? 'Open the orange.me mobile app on your phone and follow the instructions'
                  : 'Open the orange.me desktop app on your computer and follow the instructions',
              onDesktop ? TextSize.h4 : TextSize.h3,
              FontWeight.w700,
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        'View Details',
        () {
          navigateTo(context,
              UnconfirmedTxDetails(widget.globalState, widget.transaction));
        },
        true,
        ButtonVariant.secondary,
      ),
      navigationIndex: 0,
      desktopOnly: true,
    );
  }
}
