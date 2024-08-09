import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/savings/set_up/scan_qr.dart';

import 'package:orange/util.dart';

class Requirements extends StatefulWidget {
  final GlobalState globalState;
  const Requirements(this.globalState, {super.key});

  @override
  State<Requirements> createState() => RequirementsState();
}

class RequirementsState extends State<Requirements> {
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
                'Setting up your savings account\nrequires you to create three hardware\nwallets using three USB sticks',
            isDismissable: false,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomIcon(
                  icon: ThemeIcon.usb,
                  iconSize: 128,
                ),
                Container(
                  padding: const EdgeInsets.all(AppPadding.placeholder),
                  child: const CustomText(
                    text: '3 USB sticks',
                    textType: 'heading',
                    textSize: TextSize.h3,
                  ),
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
          navigateTo(context, ScanQR(widget.globalState));
        },
      ),
    );
  }
}
