import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/components/profile_photo.dart';

class Header extends StatelessWidget {
    final Widget center;
    final Widget left;
    final Widget right;

    const Header(
        this.left,
        this.center,
        this.right, {
        super.key,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Stack(
                alignment: Alignment.topCenter,
                children: [
                    Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: left,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: center,
                    ),
                    Container(
                        padding: const EdgeInsets.only(right: 16),
                        alignment: Alignment.centerRight,
                        child: right,
                    ),
                ],
            ),
        );
    }
}

Widget Header_Home(BuildContext context, String title, String? profile_picture, Widget profile, [Widget? right]) {
    return Header(
        ProfileButton(context, profile_picture, profile), 
        CustomText(variant: 'heading', size: 'h3', txt: title), 
        right ?? Container()
    );
}

Widget Header_Stack(BuildContext context, String title, [Widget? right, Widget? left]) {
    return Header(
        left ?? backButton(context),
        CustomText(variant: 'heading', font_size:'h4', txt: title),
        right ?? Container(),
    );
}

Widget Header_Message(BuildContext context, Widget ChatRecipients, [Widget? right, Widget? left]) {
    return Header(
        left ?? backButton(context),
        ChatRecipients,
        right ?? Container(),
    );
}

Widget Header_Button(BuildContext context, String title, CustomButton button) {
    return Header(
        backButton(context),
        CustomText(variant: 'heading', font_size:'h4', txt: title),
        button,
    );
}
