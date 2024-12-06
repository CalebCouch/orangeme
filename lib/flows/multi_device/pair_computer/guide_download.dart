import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/flows/multi_device/pair_computer/connect_computer.dart';

class GuideDownload extends StatefulWidget {
    GuideDownload({super.key});

    @override
    GuideDownloadState createState() => GuideDownloadState();
}

class GuideDownloadState extends State<GuideDownload> {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Connect phone"),
            content: [
                ConstrainedBox(constraints: BoxConstraints(maxWidth: 200), child:Image.asset('assets/mockups/ConnectGuideDownload.png')),
                CustomTextSpan('On the orange mobile app, confirm you have the mobile app by pressing "Continue"'),
            ],
            bumper: Bumper(context, content: [CustomButton(variant: 'secondary', txt: 'Done', onTap: () {navigateTo(context, ConnectComputer());})]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
