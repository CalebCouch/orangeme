import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:flutter/services.dart';

import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/components/interface.dart';
import 'dart:io' show Platform;

import 'package:share/share.dart';
import 'package:orange/classes.dart';

class Receive extends StatefulWidget {
  final GlobalState globalState;
  final String address;
  const Receive(this.globalState, this.address, {super.key});

  @override
  ReceiveState createState() => ReceiveState();
}

class ReceiveState extends State<Receive> {
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
    bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    return Interface(
      header: stackHeader(context, "Receive bitcoin"),
      content: Content(
        content: Column(
          mainAxisAlignment:
              onDesktop ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            qrCode(widget.address),
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
      bumper: onDesktop
          ? singleButtonBumper(
              context,
              "Copy Address",
              () async {
                await Clipboard.setData(ClipboardData(text: widget.address));
              },
            )
          : singleButtonBumper(
              context,
              "Share",
              () => {Share.share(widget.address)},
            ),
    );
  }
}
