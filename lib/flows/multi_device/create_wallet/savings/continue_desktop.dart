import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/flows/multi_device/create_wallet/savings/requirements.dart';

class ContinueDesktop extends StatefulWidget {
    ContinueDesktop({super.key});

    @override
    ContinueDesktopState createState() => ContinueDesktopState();
}

class ContinueDesktopState extends State<ContinueDesktop> {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Continue on desktop"),
            content: [
                ConstrainedBox(constraints: BoxConstraints(maxHeight: 300), child:Image.asset('assets/mockups/USBDesktop.png')),
                CustomTextSpan('Continue on the orange desktop app on your laptop or desktop computer'),
            ],
            bumper: SizedBox(),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
