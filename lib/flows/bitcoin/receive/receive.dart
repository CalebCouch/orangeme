import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:flutter/services.dart';

import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/components/interface.dart';

import 'package:share/share.dart';
import 'package:orange/classes.dart';
import 'package:orange/global.dart' as global;

// The Receive widget provides an interface for users to receive Bitcoin by
// displaying a QR code and address. It supports both desktop and mobile 
// platforms, allowing users to either copy the address or share it via different
// methods depending on the platform.

class Receive extends StatelessWidget {
  final GlobalState globalState;
  const Receive(this.globalState, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: global.receiveState,
      builder: (BuildContext context, ReceiveState state, Widget? child) {
        return buildScreen(globalState, context, state);
      },
    );
  }
}

Widget buildScreen(GlobalState globalState, BuildContext context, ReceiveState state) {
    return Interface(
      globalState,
      header: stackHeader(context, "Receive bitcoin"),
      content: Content(
        content: Column(
          mainAxisAlignment:
              global.platform_isDesktop ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            qrCode(state.address),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text: 'Scan to receive bitcoin.',
              textType: "text",
              color: ThemeColor.textSecondary,
              textSize: TextSize.md,
            )
          ],
        ),
      ),
      bumper: global.platform_isDesktop
          ? singleButtonBumper(
              context,
              "Copy Address",
              () async {
                await Clipboard.setData(ClipboardData(text: state.address));
              },
            )
          : singleButtonBumper(
              context,
              "Share",
              () => {Share.share(state.address)},
            ),
      desktopOnly: true,
      navigationIndex: 0,
    );
}
