import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/send/send.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:orange/src/rust/api/pub_structs.dart';


class ScanQR extends GenericWidget {
    ScanQR({super.key});

    @override
    ScanQRState createState() => ScanQRState();
}

class ScanQRState extends GenericState<ScanQR> {

    @override
    PageName getPageName() {return PageName.none();}

    @override
    void unpack_state(Map<String, dynamic> json) {setState(() {});}

    late QRViewController controller;
    GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    @override
    Widget build_with_state(BuildContext context) {
        return Root_Takeover(
            header: Header_Stack(context, "Scan QR code"),
            content: Stack(children: [
                QRScanner(context),
                Guide(),
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
        controller.scannedDataStream.listen((scanData) {
            String scannedCode = scanData.code ?? '';

            if (scannedCode.startsWith('bitcoin:')) scannedCode = scannedCode.substring(8); 
            
            Navigator.pop(context, scannedCode);
        });
    }


    Widget Guide() {
        return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    ScanBox(),
                    const Spacing(12),
                    const CustomText(
                        variant: 'text',
                        font_size: 'md',
                        text_color: 'text_secondary', 
                        txt: 'Scan a bitcoin QR code',
                    ),
                ],
            ),
        );
    }

    Widget ScanBox() {
        return Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(color: ThemeColor.bg, width: 4),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
        );
    }

    Widget QRScanner(BuildContext context) {
        return QRView(
            key: qrKey,
            onQRViewCreated: (QRViewController controller) => {_onQRViewCreated(context, controller)},
        );
    }
}
