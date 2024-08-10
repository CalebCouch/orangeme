import 'package:flutter/material.dart';
import 'package:orange/components/placeholder.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/banner.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/qr_code/qr_code.dart';

class Pair extends StatefulWidget {
  final GlobalState globalState;
  const Pair(this.globalState, {super.key});

  @override
  State<Pair> createState() => PairState();
}

class PairState extends State<Pair> {
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
        "Scan QR code",
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
                placeholder(context,
                    'Scan this QR code with your phone to connect your phone with this laptop or desktop computer'),
              ],
            ),
          ),
        ]),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {},
      ),
      globalState: widget.globalState,
      navigationIndex: 1,
    );
  }
}
