import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/flows/multi_device/pair_computer/scan_qr.dart';

class DownloadDesktop extends StatefulWidget {
    DownloadDesktop({super.key});

    @override
    DownloadDesktopState createState() => DownloadDesktopState();
}

class DownloadDesktopState extends State<DownloadDesktop> {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Download desktop app"),
            content: [
                CustomTextSpan('Install the orange desktop app on your laptop or desktop computer'),
                CustomText(
                    txt: 'desktop.orange.me', 
                    font_size: 'h4', 
                    variant: 'heading', 
                    text_decoration: TextDecoration.underline
                )
            ],
            bumper: SizedBox(),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
