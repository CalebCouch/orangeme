import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/flows/multi_device/create_wallet/savings/name_wallet.dart';

class Requirements extends StatefulWidget {
    Requirements({super.key});

    @override
    RequirementsState createState() => RequirementsState();
}

class RequirementsState extends State<Requirements> {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Requirements"),
            content: [
                ConstrainedBox(constraints: BoxConstraints(maxWidth: 300), child:Image.asset('assets/mockups/USBCMockup.png')),
                CustomText(txt: 'Setting up a savings wallet requires you to create USB security keys using 1-3 USB sticks', font_size: 'h3', variant: 'heading'),
            ],
            bumper: Bumper(context, content: [CustomButton(txt: 'Continue', onTap: () {navigateTo(context, NameWallet());})]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
