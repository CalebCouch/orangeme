import 'package:flutter/material.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/flows/bitcoin/transactions/confirm.dart';
import 'dart:io' show Platform;

import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class ConfirmationTakeover extends StatefulWidget {
  final GlobalState globalState;
  final Transaction transaction;
  const ConfirmationTakeover(this.globalState, this.transaction, {super.key});

  @override
  ConfirmationTakeoverState createState() => ConfirmationTakeoverState();
}

class ConfirmationTakeoverState extends State<ConfirmationTakeover> {
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
      header: homeHeader(
        context,
        widget.globalState,
        "Confirm send",
        false,
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              onDesktop
                  ? 'assets/images/mockups/tx-start-mobile.png'
                  : 'assets/images/mockups/tx-start-desktop.png',
            ),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              onDesktop
                  ? 'You sent bitcoin on the orange.me mobile app.\n\nConfirm your bitcoin send now'
                  : 'You sent bitcoin on the orange.me desktop app.\n\nConfirm your bitcoin send now',
              onDesktop ? TextSize.h4 : TextSize.h3,
              FontWeight.w700,
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(context, 'View Details', () {
        navigateTo(
            context, ConfirmSend(widget.globalState, widget.transaction));
      }),
      navigationIndex: 0,
      desktopOnly: true,
    );
  }
}
