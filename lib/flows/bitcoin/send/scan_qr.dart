import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
    return Stack_Default(
      Header_Stack(context, "Scan QR code"),
      [
        Stack(children: [
          qrScanner(),
          Guide(),
        ]),
      ],
      Bumper([Container()]),
    );
  }

  //The following widgets can ONLY be used in this file

  Widget Guide() {
    return CustomColumn([
      scanBox(),
      const CustomText('text md bg_secondary', 'Scan a bitcoin QR code'),
    ]);
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
        onQRViewCreated: (QRViewController controller) => {_onQRViewCreated(widget.globalState, controller)},
      ),
    );
  }
}
