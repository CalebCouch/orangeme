import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/flows/pairing/pair_code.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

// DESKTOP ONLY

class ConfirmDownload extends StatefulWidget {
  final GlobalState globalState;
  const ConfirmDownload(this.globalState, {super.key});

  @override
  ConfirmDownloadState createState() => ConfirmDownloadState();
}

class ConfirmDownloadState extends State<ConfirmDownload> {
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
        "Connect phone",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/mobile-download-desktop.png'),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
              'On the orange.me app, confirm you have the desktop app by pressing Continue',
              TextSize.h3,
              FontWeight.w700,
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(
        context,
        "Continue",
        () {
          navigateTo(context, PairCode(widget.globalState));
        },
        true,
        ButtonVariant.secondary,
      ),
    );
  }
}
