import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:orange/flows/wallet/send/send.dart';

class ScanQR extends StatefulWidget {
  final GlobalState globalState;
  const ScanQR(this.globalState, {super.key});

  @override
  ScanQRState createState() => ScanQRState();
}

class ScanQRState extends State<ScanQR> {
  late QRViewController controller;
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
      content: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.content),
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) =>
                  {_onQRViewCreated(widget.globalState, controller)},
            ),
          ),
          Content(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemeColor.bg, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                const Spacing(height: 12),
                const CustomText(
                  text: 'Scan a bitcoin QR code',
                  color: ThemeColor.bgSecondary,
                  textSize: TextSize.md,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onQRViewCreated(GlobalState globalState, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print(scanData.code);
      switchPageTo(context, Send(globalState, address: scanData.code));
    });
  }
}
