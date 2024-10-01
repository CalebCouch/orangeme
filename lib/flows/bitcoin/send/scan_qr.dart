import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:orange/flows/bitcoin/send/send.dart';

// Provides a QR code scanner for capturing Bitcoin addresses and navigating to the transaction screen.

/* Manages the QR code scanning interface for capturing Bitcoin addresses. */
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
    return Interface(
      widget.globalState,
      header: stackHeader(context, "Scan QR code"),
      content: Stack(
        children: [
          qrScanner(),
          Content(
            alignment: MainAxisAlignment.center,
            children: [
              scanBox(),
              const CustomText(
                text: 'Scan a bitcoin QR code',
                color: ThemeColor.bgSecondary,
                textSize: TextSize.md,
              ),
            ],
          ),
        ],
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }

  /* Initializes the QR view controller and handles scanned data. */
  _onQRViewCreated(GlobalState globalState, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      switchPageTo(context, Send(globalState, address: scanData.code));
    });
  }

  scanBox() {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColor.bg, width: 4),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    );
  }

  qrScanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.content),
      child: QRView(
        key: qrKey,
        onQRViewCreated: (QRViewController controller) =>
            {_onQRViewCreated(widget.globalState, controller)},
      ),
    );
  }
}
