import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/components/qr_code/qr_code.dart';
import 'package:orange/flows/multi_device/pair_computer/guide_profile.dart';

class GetMobile extends StatefulWidget {
    GetMobile({super.key});

    @override
    GetMobileState createState() => GetMobileState();
}

class GetMobileState extends State<GetMobile> {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Get the mobile app"),
            content: [
                QRCode('https://mobile.orange.me'),
                CustomRow([StoreButton('google'), StoreButton('apple')], 16),
                CustomTextSpan('Scan to download the orange mobile app'),
            ],
            bumper: Bumper(context, content: [CustomButton(txt: 'Continue', onTap: () {navigateTo(context, GuideProfile());})]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}

Widget StoreButton(String store){

    return GestureDetector(
        onTap: () {},
        child: SvgPicture.asset(
            icon['download-$store']!,
            width: 145,
        ),
    );
}
