import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:orange/generic.dart';

Widget Guide(String message) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                ScanBox(),
                const Spacing(12),
                CustomText(
                    variant: 'text',
                    font_size: 'md',
                    text_color: 'text_secondary', 
                    txt: message,
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

Widget QRScanner(BuildContext context, qrKey, _onQRViewCreated) {
    return QRView(
        key: qrKey,
        onQRViewCreated: (QRViewController controller) => {_onQRViewCreated(context, controller)},
    );
}