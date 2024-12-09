import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/flows/multi_device/create_wallet/savings/requirements.dart';

class CreateKeys extends StatefulWidget {
    CreateKeys({super.key});

    @override
    CreateKeysState createState() => CreateKeysState();
}

class CreateKeysState extends State<CreateKeys> {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Create security keys"),
            content: [
                ConstrainedBox(constraints: BoxConstraints(maxHeight: 300), child:Image.asset('assets/mockups/USBCMockup.png')),
                CustomText(txt: 'Setting up a savings wallet requires you to create USB security keys using 1-3 USB sticks', font_size: 'h3', variant: 'heading'),
            ],
            bumper: Bumper(context, content: [CustomButton(txt: 'Continue', onTap: () {navigateTo(context, Requirements());})]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
