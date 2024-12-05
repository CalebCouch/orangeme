import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/components/qr_scanner.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/generic.dart';
import 'package:orange/flows/multi_device/pair_computer/success.dart';

class ScanQR extends StatefulWidget {
    ScanQR({super.key});

    @override
    ScanQRState createState() => ScanQRState();
}

class ScanQRState extends State<ScanQR> {
    late QRViewController controller;
    GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    @override
    Widget build(BuildContext context) {
        return Root_Takeover(
            header: Header_Stack(context, "Scan QR code"),
            content: Stack(children: [
                QRScanner(context, qrKey, _onQRViewCreated),
                Guide('Scan the QR code displayed on your laptop or desktop computer'),
            ]),
        );
    }

    @override
    void dispose() {
        controller.dispose();
        super.dispose();
    }

    void _onQRViewCreated(BuildContext context, QRViewController controller) {
        this.controller = controller;
        controller.scannedDataStream.listen((scanData) {navigateTo(context, Success());});
    }
}
