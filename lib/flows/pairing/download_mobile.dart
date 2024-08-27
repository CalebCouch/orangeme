import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/util.dart';

import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/flows/pairing/connect_phone.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/classes.dart';

class DownloadMobile extends StatefulWidget {
  final GlobalState globalState;
  const DownloadMobile(this.globalState, {super.key});

  @override
  DownloadMobileState createState() => DownloadMobileState();
}

class DownloadMobileState extends State<DownloadMobile> {
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
        "Download mobile",
      ),
      content: Content(
        content: Column(
          children: [
            qrCode("https://orange.me/download"),
            const Spacing(height: AppPadding.content),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/mockups/app-store.png',
                  height: 42,
                ),
                const Spacing(width: AppPadding.content),
                Image.asset(
                  'assets/images/mockups/google-play.png',
                  height: 42,
                ),
              ],
            ),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark('Scan to download the orange.me app',
                TextSize.h3, FontWeight.w700),
          ],
        ),
      ),
      bumper: singleButtonBumper(context, "Continue", () {
        navigateTo(context, ConnectPhone(widget.globalState));
      }),
    );
  }
}
