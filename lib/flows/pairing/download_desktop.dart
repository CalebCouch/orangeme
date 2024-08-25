import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/pairing/scan_qr.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class DownloadDesktop extends StatefulWidget {
  final GlobalState globalState;

  const DownloadDesktop(this.globalState, {super.key});

  @override
  DownloadDesktopState createState() => DownloadDesktopState();
}

class DownloadDesktopState extends State<DownloadDesktop> {
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
        "Download desktop",
      ),
      content: Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/mockups/desktop-wallet-home.png'),
            buildTextWithBrandMark(
              'Install orange.me on your laptop or desktop computer by navigating to:',
              TextSize.h4,
              FontWeight.w700,
            ),
            const CustomText(
              text: '\ndesktop.orange.me',
              textSize: TextSize.h4,
              textType: 'heading',
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(context, "Continue", () {
        navigateTo(context, ScanQR(widget.globalState));
      }),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}
