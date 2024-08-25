import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/new_wallet/savings/insert_usb.dart';
import 'package:orange/flows/new_wallet/savings/success.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

// DESKTOP ONLY

class CreationConfirmed extends StatefulWidget {
  final GlobalState globalState;
  const CreationConfirmed(this.globalState, {super.key});

  @override
  CreationConfirmedState createState() => CreationConfirmedState();
}

class CreationConfirmedState extends State<CreationConfirmed> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  String remainingKeys = 'two';

  Widget buildScreen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: stackHeader(
        context,
        "Security key created",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/usb.png'),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text: 'Security key created!',
              textSize: TextSize.h4,
              textType: 'heading',
            ),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'You created a security key. orange.me recommends you make $remainingKeys more.',
              TextSize.lg,
              FontWeight.w400,
            ),
          ],
        ),
      ),
      // THIS IS TEMPORARY, REMOVE THIS AND REPLACE WITH AUTOMATIC TRANSITION//
      bumper: doubleButtonBumper(context, 'Skip', 'Add Key', () {
        navigateTo(context, Success(widget.globalState, 'My Savings'));
      }, () {
        navigateTo(context, InsertUSB(widget.globalState));
      }),
    );
  }
}
