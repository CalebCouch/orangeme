import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/bitcoin/pairing/phone_walkthrough.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class DownloadDesktop extends StatefulWidget {
  final GlobalState globalState;
  const DownloadDesktop(this.globalState, {super.key});

  @override
  State<DownloadDesktop> createState() => DownloadDesktopState();
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
      header: stackHeader(context, "Download desktop"),
      content: Content(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/desktop_home.png'),
            const Spacing(height: 32),
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
                  const TextSpan(text: 'Scan to download the '),
                  textMark(TextSize.h3),
                  const TextSpan(
                    text: ' app',
                  ),
                ],
              ),
            ),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text:
                  'The mobile app works with the desktop app to keep your friends and money safe',
              textSize: TextSize.md,
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(context, 'Continue', () {
        navigateTo(context, ConnectPhone(widget.globalState));
      }),
      navigationIndex: 0,
      hide: true,
    );
  }
}
