import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/flows/bitcoin/wallet.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';

import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class ConfTxDesktop extends StatefulWidget {
  final GlobalState globalState;
  const ConfTxDesktop(this.globalState, {super.key});

  @override
  ConfTxDesktopState createState() => ConfTxDesktopState();
}

class ConfTxDesktopState extends State<ConfTxDesktop> {
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
        "Confirm on mobile",
        exitButton(
          context,
          WalletHome(widget.globalState),
        ),
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/confirm-on-mobile.png'),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'Open the orange.me mobile app on your phone and follow the instructions',
              TextSize.h4,
              FontWeight.w700,
            ),
          ],
        ),
      ),
      navigationIndex: 0,
      desktopOnly: true,
    );
  }
}

class ConfTxMobile extends StatefulWidget {
  final GlobalState globalState;
  const ConfTxMobile(this.globalState, {super.key});

  @override
  ConfTxMobileState createState() => ConfTxMobileState();
}

class ConfTxMobileState extends State<ConfTxMobile> {
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
        "Confirm on desktop",
        exitButton(
          context,
          WalletHome(widget.globalState),
        ),
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/confirm-on-desktop.png'),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'Open the orange.me desktop app on your computer and follow the instructions',
              TextSize.h4,
              FontWeight.w700,
            ),
          ],
        ),
      ),
      navigationIndex: 0,
      desktopOnly: true,
    );
  }
}
