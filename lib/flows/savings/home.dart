import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/savings/set_up/get_desktop.dart';

import 'package:orange/util.dart';

class SavingsHome extends StatefulWidget {
  final GlobalState globalState;
  const SavingsHome(this.globalState, {super.key});

  @override
  State<SavingsHome> createState() => _SavingsHomeState();
}

class _SavingsHomeState extends State<SavingsHome> {
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
      header: primaryHeader(
        context,
        "Savings",
      ),
      content: Content(
        content: Column(children: [
          const CustomBanner(
            message:
                'You will need to wait an hour\nafter set up to spend your bitcoin',
            isDismissable: false,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _bulletedPoint(
                    'Bullet points explaining the benefits of a savings account'),
                _bulletedPoint(
                    'You need to have the orange.me desktop app installed on your laptop or desktop computer'),
              ],
            ),
          )
        ]),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, DesktopSetUp(widget.globalState));
        },
      ),
      globalState: widget.globalState,
      navigationIndex: 1,
    );
  }
}

_bulletedPoint(String text) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 300),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CustomText(text: "• "),
        Expanded(
          child: CustomText(text: '$text\n', textSize: TextSize.md),
        ),
      ],
    ),
  );
}
