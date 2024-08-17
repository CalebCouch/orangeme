import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/bitcoin/pairing/pairing_code.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class ConnectPhone extends StatefulWidget {
  final GlobalState globalState;
  const ConnectPhone(this.globalState, {super.key});

  @override
  State<ConnectPhone> createState() => ConnectPhoneState();
}

class ConnectPhoneState extends State<ConnectPhone> {
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
      header: stackHeader(context, "Connect phone"),
      content: Content(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/mobile_home.png', width: 200),
            const Spacing(height: 48),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'outfit',
                  fontSize: TextSize.h3,
                  fontWeight: FontWeight.w700,
                  color: ThemeColor.heading,
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'On the '),
                  textMark(TextSize.h3),
                  const TextSpan(
                    text: ' app, press Connect to a Computer',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(context, 'Continue', () {
        navigateTo(context, DesktopConfirm(widget.globalState));
      }),
      hide: true,
      navigationIndex: 2,
    );
  }
}

class DesktopConfirm extends StatefulWidget {
  final GlobalState globalState;
  const DesktopConfirm(this.globalState, {super.key});

  @override
  State<DesktopConfirm> createState() => DesktopConfirmState();
}

class DesktopConfirmState extends State<DesktopConfirm> {
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
      header: stackHeader(context, "Connect phone"),
      content: Content(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/mobile_get_desktop.png', width: 200),
            const Spacing(height: 48),
            const CustomText(
              textType: 'heading',
              textSize: TextSize.h3,
              text: 'Confirm you have the desktop app by pressing Continue',
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(context, 'Continue', () {
        navigateTo(context, PairingCode(widget.globalState));
      }),
      desktopOnly: true,
      navigationIndex: 2,
      hide: true,
    );
  }
}
