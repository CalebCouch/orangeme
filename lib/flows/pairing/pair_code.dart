import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:flutter/services.dart';
import 'package:orange/util.dart';

import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/components/content.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/classes.dart';

class PairCode extends StatefulWidget {
  final GlobalState globalState;
  const PairCode(this.globalState, {super.key});

  @override
  PairCodeState createState() => PairCodeState();
}

class PairCodeState extends State<PairCode> {
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
      content: Content(
        content: Column(
          children: [
            qrCode("RANDOMPAIRINGCODE-1234hexak820xbosuxhdoi02oxc2345"),
            const Spacing(height: AppPadding.content),
            buildTextWithBrandMark(
                'Scan with orange.me app', TextSize.h3, FontWeight.w700),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text:
                  'Scan this QR code with your phone to connect your phone with this laptop or desktop computer',
              textSize: TextSize.md,
            ),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text: 'or',
              textSize: TextSize.md,
              color: ThemeColor.textSecondary,
            ),
            const Spacing(height: AppPadding.content),
            ButtonTip("Download the App", null, () {})
          ],
        ),
      ),
    );
  }
}
