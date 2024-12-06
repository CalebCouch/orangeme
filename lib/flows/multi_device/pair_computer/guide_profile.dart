import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/flows/multi_device/pair_computer/guide_download.dart';

class GuideProfile extends StatefulWidget {
    GuideProfile({super.key});

    @override
    GuideProfileState createState() => GuideProfileState();
}

class GuideProfileState extends State<GuideProfile> {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Connect phone"),
            content: [
                ConstrainedBox(constraints: BoxConstraints(maxWidth: 200), child:Image.asset('assets/mockups/ConnectGuideProfile.png')),
                CustomTextSpan('On the orange mobile app, open your profile. Press "Connect Computer"'),
            ],
            bumper: Bumper(context, content: [CustomButton(txt: 'Continue', onTap: () {navigateTo(context, GuideDownload());})]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
