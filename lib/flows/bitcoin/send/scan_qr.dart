import 'package:flutter/material.dart';
import 'package:orange/classes.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:orange/global.dart' as global;

class ScanQR extends GenericWidget {
  ScanQR({super.key});

  @override
  ScanQRState createState() => ScanQRState();
}

class ScanQRState extends GenericState<ScanQR> {
  @override
  String stateName() {
    return "ScanQR";
  }

  @override
  int refreshInterval() {
    return 100;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Root_Takeover(
      Header_Stack(
        context,
        "Scan QR code",
        null,
        iconButton(() {
          switchPageTo(context, Send());
        }, 'left lg'),
      ),
      Expanded(
        child: Stack(children: [
          qrScanner(context),
          Guide(),
        ]),
      ),
    );
  }

  late QRViewController controller;
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  //The following widgets can ONLY be used in this file

  Widget Guide() {
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            scanBox(),
            const Spacing(12),
            const CustomText('text md text_secondary', 'Scan a bitcoin QR code'),
          ],
        ),
      ),
    );
  }

  /* Initializes the QR view controller and handles scanned data. */
  _onQRViewCreated(BuildContext context, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setStateAddress(path: global.dataDir!, address: scanData.code!);
      switchPageTo(context, Send());
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

  qrScanner(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) => {_onQRViewCreated(context, controller)},
    );
  }
}
