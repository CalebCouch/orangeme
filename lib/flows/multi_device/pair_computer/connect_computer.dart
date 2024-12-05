import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/components/qr_code/qr_code.dart';

class ConnectComputer extends StatefulWidget {
    ConnectComputer({super.key});

    @override
    ConnectComputerState createState() => ConnectComputerState();
}

class ConnectComputerState extends State<ConnectComputer> {
    @override
    Widget build(BuildContext context) {
        return Root_Takeover(
            header: Header_Takeover(context, "Download desktop app"),
            content: Content([
                QRCode('Connection Code'),
                CustomTextSpan('Scan with the orange mobile app'),
                CustomText(variant: 'text', txt: 'Scan this QR code with your phone to connect your phone with this laptop or desktop computer', font_size: 'md'),
                CustomText(variant: 'text', txt: 'or', font_size: 'md', text_color: 'text_secondary'),
                CustomButton(txt: 'Download Mobile App', onTap: () {}, variant: 'secondary', expand: false, size: 'md'),
            ]),
        );
    }
}
