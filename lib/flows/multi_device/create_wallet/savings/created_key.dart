import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/flows/multi_device/create_wallet/savings/creating_key.dart';
import 'package:orange/flows/multi_device/create_wallet/success.dart';

class CreateKeys extends StatefulWidget {
    CreateKeys({super.key});

    @override
    CreateKeysState createState() => CreateKeysState();
}

class CreateKeysState extends State<CreateKeys> {
    int keysRecommended = 2;
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Security key created"),
            content: [
                ConstrainedBox(constraints: BoxConstraints(maxHeight: 300), child:Image.asset('assets/mockups/USBCMockup.png')),
                CustomText(txt: 'Security key created!', font_size: 'h3', variant: 'heading'),
                CustomTextSpan('orange recommends you make $keysRecommended more'),

            ],
            bumper: Bumper(context, content: [
                CustomButton(txt: 'Skip', variant: 'secondary', onTap: () {navigateTo(context, Success());}),
                CustomButton(txt: 'Add Key', onTap: () {navigateTo(context, CreatingKey());}),
            ]),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
