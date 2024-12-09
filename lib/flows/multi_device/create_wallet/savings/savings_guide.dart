import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orange/flows/multi_device/create_wallet/savings/requirements.dart';

class NewSavingsGuide extends StatefulWidget {
    NewSavingsGuide({super.key});

    @override
    NewSavingsGuideState createState() => NewSavingsGuideState();
}

class NewSavingsGuideState extends State<NewSavingsGuide> {
    @override
    Widget build(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "New savings wallet"),
            content: [
                ConstrainedBox(constraints: BoxConstraints(maxHeight: 300), child:Image.asset('assets/mockups/MultiDevice.png')),
                CustomTextSpan('Open the orange mobile app on your phone to create a new savings wallet'),
            ],
            bumper: SizedBox(),
            alignment: Alignment.center,
            scroll: false,
        );
    }
}
