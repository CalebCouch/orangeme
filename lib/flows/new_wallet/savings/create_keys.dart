import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/new_wallet/savings/insert_usb.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

// DESKTOP ONLY

class CreateKeys extends StatefulWidget {
  final GlobalState globalState;
  const CreateKeys(this.globalState, {super.key});

  @override
  CreateKeysState createState() => CreateKeysState();
}

class CreateKeysState extends State<CreateKeys> {
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
      header: homeDesktopHeader(
        context,
        "Create security keys",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/usb.png'),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text:
                  'Setting up a savings wallet requires you to create security keys using 1-3 USB sticks',
              textSize: TextSize.h4,
              textType: 'heading',
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(context, "Continue", () {
        navigateTo(context, InsertUSB(widget.globalState));
      }),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}

