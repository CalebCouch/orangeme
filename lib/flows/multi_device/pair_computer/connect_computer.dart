import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/flows/multi_device/pair_computer/download_mobile.dart';

class ConnectComputer extends StatefulWidget {
    ConnectComputer({super.key});

    @override
    ConnectComputerState createState() => ConnectComputerState();
}

class ConnectComputerState extends State<ConnectComputer> {
    @override
    Widget build(BuildContext context) {
        return Root_Takeover(
            content: Content(alignment: Alignment.center, [
                QRCode('Connection Code: 2IU3IGSHPAw3S5G3SvgsgrjKPKtwaMG1bZ2h8C2e'),
                CustomTextSpan('Scan with the orange mobile app'),
                CustomText(variant: 'text', txt: 'Scan this QR code to connect your phone with this laptop or desktop computer', font_size: 'md'),
                CustomText(variant: 'text', txt: 'or', font_size: 'md', text_color: 'text_secondary'),
                CustomButton(txt: 'Download Mobile App', onTap: () {navigateTo(context, DownloadMobile());}, variant: 'secondary', expand: false, size: 'md'),
            ]),
        );
    }
}
