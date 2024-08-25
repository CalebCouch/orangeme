import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/flows/new_wallet/savings/requirements.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class SetupDesktop extends StatefulWidget {
  final GlobalState globalState;

  const SetupDesktop(this.globalState, {super.key});

  @override
  SetupDesktopState createState() => SetupDesktopState();
}

class SetupDesktopState extends State<SetupDesktop> {
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
        "Set up desktop",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/desktop-wallet-home.png'),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'To create a savings wallet, you will need the orange.me desktop app on your laptop or desktop computer',
              TextSize.h4,
              FontWeight.w700,
            ),
            const Spacing(height: AppPadding.content),
            ButtonTip('Download the App', null, () {})
          ],
        ),
      ),
      bumper: singleButtonBumper(context, "Continue", () {
        navigateTo(context, Requirements(widget.globalState));
      }),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
