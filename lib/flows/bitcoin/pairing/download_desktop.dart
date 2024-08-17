import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/bitcoin/pairing/scan_qr.dart';

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
                  fontSize: TextSize.md,
                  fontWeight: FontWeight.w400,
                  color: ThemeColor.text,
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'Install '),
                  textMark(TextSize.md),
                  const TextSpan(
                    text:
                        ' on your laptop or desktop computer by navigating to:\n\n',
                  ),
                  const TextSpan(
                      style: const TextStyle(
                        fontFamily: 'outfit',
                        fontSize: TextSize.h5,
                        fontWeight: FontWeight.w700,
                        color: ThemeColor.heading,
                      ),
                      text: 'desktop.orange.me'),
                ],
              ),
            ),
          ],
        ),
      ),
      bumper: singleButtonBumper(context, 'Continue', () {
        navigateTo(context, ScanQR(widget.globalState));
      }),
      desktopOnly: true,
      navigationIndex: 2,
    );
  }
}
