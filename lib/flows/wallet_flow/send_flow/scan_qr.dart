import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/classes.dart';

class ScanQR extends StatefulWidget {
  final GlobalState globalState;
  const ScanQR(this.globalState, {super.key});

  @override
  ScanQRState createState() => ScanQRState();
}

class ScanQRState extends State<ScanQR> {
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
    return DefaultInterface(
      header: stackHeader(
        context,
        "Scan QR code",
      ),
      content: Content(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: ThemeColor.bgSecondary, width: 4),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
            const Spacing(height: AppPadding.content),
            const CustomText(
              text: 'Scan a bitcoin QR code',
              color: ThemeColor.textSecondary,
              textSize: TextSize.md,
            ),
          ],
        ),
      ),
    );
  }
}
