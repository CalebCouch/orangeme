import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  ScanQRState createState() => ScanQRState();
}

class ScanQRState extends State<ScanQR> {
  late QRViewController controller;
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Root_Takeover(
      Header_Stack(context, "Scan QR code"),
      Expanded(
        child: Stack(children: [
          qrScanner(context),
          Guide(),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _onQRViewCreated(BuildContext context, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      switchPageTo(context, Send(scanData.code!));
    });
  }

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
