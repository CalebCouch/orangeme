import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/flows/multi_device/pair_computer/get_mobile.dart';

class DownloadMobile extends StatefulWidget {
    DownloadMobile({super.key});

    @override
    DownloadMobileState createState() => DownloadMobileState();
}

class DownloadMobileState extends State<DownloadMobile> {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Get the mobile app"),
            content: [
                ConstrainedBox(constraints: BoxConstraints(maxWidth: 350), child:Image.asset('assets/mockups/MultiDevice.png')),
                CustomTextSpan('The orange mobile app works with the desktop app to keep your friends and money safe'),
                CustomText(txt: 'mobile.orange.me', font_size: 'h4', variant: 'heading', text_decoration: TextDecoration.underline)
            ],
            bumper: Bumper(context, content: [CustomButton(txt: 'Get the mobile app', onTap: () {navigateTo(context, GetMobile());})]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
