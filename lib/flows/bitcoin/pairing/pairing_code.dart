import 'package:flutter/material.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/flows/bitcoin/pairing/download_mobile.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class PairingCode extends StatefulWidget {
  final GlobalState globalState;
  const PairingCode(this.globalState, {super.key});

  @override
  PairingCodeState createState() => PairingCodeState();
}

class PairingCodeState extends State<PairingCode> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        print("rebuild");
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: homeDesktopHeader(context, "Receive bitcoin"),
      content: Content(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            qrCode('nothing to see here'),
            const Spacing(height: AppPadding.content),
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
                  const TextSpan(text: 'Scan with '),
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
                  'Scan this QR code with your phone to connect your phone with this laptop or desktop computer',
              textSize: TextSize.md,
            ),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text: 'or',
              color: ThemeColor.textSecondary,
              textSize: TextSize.md,
            ),
            const Spacing(height: AppPadding.content),
            ButtonTip(
                text: 'Download the App',
                onTap: () {
                  navigateTo(context, DownloadMobile(widget.globalState));
                })
          ],
        ),
      ),
      navigationIndex: 0,
      hide: true,
    );
  }
}
