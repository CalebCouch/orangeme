import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/new_wallet/savings/remove_usb.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

// DESKTOP ONLY

class CreatingKey extends StatefulWidget {
  final GlobalState globalState;
  const CreatingKey(this.globalState, {super.key});

  @override
  CreatingKeyState createState() => CreatingKeyState();
}

class CreatingKeyState extends State<CreatingKey> {
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
        "Creating security key",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/usb.png'),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text: 'Creating security key...',
              textSize: TextSize.h4,
              textType: 'heading',
            ),
          ],
        ),
      ),
      // THIS IS TEMPORARY, REMOVE THIS AND REPLACE WITH AUTOMATIC TRANSITION//
      bumper: singleButtonBumper(context, "Continue", () {
        navigateTo(context, RemoveUSB(widget.globalState));
      }),
    );
  }
}
