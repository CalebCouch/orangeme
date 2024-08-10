import 'package:flutter/material.dart';
import 'package:orange/components/placeholder.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/flows/savings/set_up/requirements.dart';
import 'package:orange/flows/savings/set_up/pair.dart';
import 'package:orange/components/qr_code/qr_code.dart';

import 'package:orange/util.dart';

class MobileSetUp extends StatefulWidget {
  final GlobalState globalState;
  const MobileSetUp(this.globalState, {super.key});

  @override
  State<MobileSetUp> createState() => MobileSetUpState();
}

class MobileSetUpState extends State<MobileSetUp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    return Interface(
      resizeToAvoidBottomInset: false,
      header: stackHeader(
        context,
        "Savings",
      ),
      content: Content(
        content: Column(children: [
          const CustomBanner(
            message:
                'The mobile app works with the desktop app\nto keep your friends and money safe',
            isDismissable: false,
          ),
          Center(
            child: Column(
              children: [
                qrCode("mobile.orange.me"),
                const Spacing(height: AppPadding.content),
                withBrandMark(
                  'Scan this QR code to download the orange.me app'
                      .split('orange.me'),
                ),
              ],
            ),
          ),
        ]),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, MSetUpContinue(widget.globalState));
        },
      ),
      navigationIndex: 3,
    );
  }
}

class MSetUpContinue extends StatefulWidget {
  final GlobalState globalState;
  const MSetUpContinue(this.globalState, {super.key});

  @override
  State<MSetUpContinue> createState() => MSetUpContinueState();
}

class MSetUpContinueState extends State<MSetUpContinue> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    return Interface(
      resizeToAvoidBottomInset: false,
      header: stackHeader(
        context,
        "Continue set up",
      ),
      content: Content(
        content: Center(
          child: Column(
            children: [
              placeholder(context,
                  'On your phone, open the orange.me mobile app and go to the savings tab.'),
              placeholder(context,
                  'Confirm the desktop app is installed on this device by pressing continue on the orange.me mobile app.'),
              placeholder(context,
                  'Confirm you have 3 USB sticks by pressing continue on the orange.me mobile app.'),
            ],
          ),
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, Pair(widget.globalState));
        },
      ),
    );
  }
}

Widget withBrandMark(parts) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: parts[0],
          style: const TextStyle(
            fontSize: TextSize.md,
            fontWeight: FontWeight.w400,
            color: ThemeColor.text,
          ),
        ),
        const TextSpan(
          text: 'orange',
          style: TextStyle(
            fontSize: TextSize.md,
            fontWeight: FontWeight.w900,
            color: ThemeColor.bitcoin,
          ),
        ),
        const TextSpan(
          text: '.me',
          style: TextStyle(
            fontSize: TextSize.md,
            fontWeight: FontWeight.w900,
            color: ThemeColor.heading,
          ),
        ),
        TextSpan(
          text: parts[1],
          style: const TextStyle(
            fontSize: TextSize.md,
            fontWeight: FontWeight.w400,
            color: ThemeColor.text,
          ),
        ),
      ],
    ),
  );
}
