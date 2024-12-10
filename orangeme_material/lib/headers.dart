import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';

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
                        alignment: Alignment.centerLeft,
                        child: left,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: center,
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        child: right,
                    ),
                ],
            ),
        );
    }
}

Widget Header_Home(BuildContext context, String title, String? profile_picture, onTap, [Widget? right]) {
    return Header(
        InkWell( onTap: onTap, child: Container( 
            padding: EdgeInsets.symmetric(horizontal: 16), 
            child: ProfilePhoto(profile_picture: profile_picture, size: 'md'),
        )),
        CustomText(variant: 'heading', font_size: 'h3', txt: title), 
        right ?? Container()
    );
}

Widget Header_Takeover(BuildContext context, String title) {
    return Header(
        SizedBox(),
        CustomText(variant: 'heading', font_size:'h3', txt: title),
        SizedBox(),
    );
}

Widget Header_Stack(BuildContext context, String title, {Widget? right, Widget? left}) {
    return Header(
        left ?? CustomBackButton(context),
        CustomText(variant: 'heading', font_size:'h4', txt: title),
        right ?? Container(),
    );
}

Widget Header_Message(BuildContext context, {required Widget center, Widget? right, Widget? left}) {
    return Header(
        left ?? CustomBackButton(context),
        center,
        right ?? Container(),
    );
}

Widget Header_Button(BuildContext context, String title, CustomButton button) {
    return Header(
        CustomBackButton(context),
        CustomText(variant: 'heading', font_size:'h4', txt: title),
        Container(padding: EdgeInsets.symmetric(horizontal: 16), child: button),
    );
}
