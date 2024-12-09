import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orangeme_material/navigation.dart';

class CreatingKey extends StatefulWidget {
    CreatingKey({super.key});

    @override
    CreatingKeyState createState() => CreatingKeyState();
}

class CreatingKeyState extends State<CreatingKey> {
    @override
    Widget build(BuildContext context) {
        return InsertUSB();
    }
}


Widget InsertUSB(){
    return Stack_Default(
        header: Header_Stack(context, "Create security keys"),
        content: [
            ConstrainedBox(constraints: BoxConstraints(maxHeight: 300), child:Image.asset('assets/mockups/USBCMockup.png')),
            CustomText(txt: 'Insert USB stick', font_size: 'h3', variant: 'heading'),
        ],
        bumper: SizedBox(),
        alignment: Alignment.center,
        scroll: false,
    );
}

Widget CreatingKey(){
    return Stack_Default(
        header: Header_Stack(context, "Creating security key"),
        content: [
            ConstrainedBox(constraints: BoxConstraints(maxHeight: 300), child:Image.asset('assets/mockups/USBCMockup.png')),
            CustomText(txt: 'Creating security key...', font_size: 'h3', variant: 'heading'),
        ],
        bumper: SizedBox(),
        alignment: Alignment.center,
        scroll: false,
    );
}

Widget RemoveKey() {
    return Stack_Default(
        header: Header_Stack(context, "Remove USB stick"),
        content: [
            ConstrainedBox(constraints: BoxConstraints(maxHeight: 300), child:Image.asset('assets/mockups/USBCMockup.png')),
            CustomText(txt: 'Remove USB Stick', font_size: 'h3', variant: 'heading'),
        ],
        bumper: SizedBox(),
        alignment: Alignment.center,
        scroll: false,
    );
}