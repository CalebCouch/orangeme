import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orangeme_material/icon.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/text.dart';

Widget iconButton(onTap, String icon, String size) {
    return InkWell(
        onTap: () {
            HapticFeedback.heavyImpact();
            onTap();
        },
        child: Container(padding: EdgeInsets.only(left: 16), child: CustomIcon(icon: icon, size: size)),
    );
}

Widget sendButton(bool isEnabled) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: iconButton(null, 'send', 'lg'),
    );
}

Widget backButton(BuildContext context) {
    return iconButton(
        () { navPop(context); }, 
        'left',
        'lg'
    );
}

Widget exitButton(BuildContext context, Widget home) {
    return iconButton(
        () { resetNavTo(context, home); }, 
        'close',
        'lg'
    );
}

Widget infoButton(BuildContext context, Widget page) {
    return iconButton(
        () { navigateTo(context, page); }, 
        'info',
        'lg',
    );
}

Widget numberButton(BuildContext context, String number) {
    return CustomText(variant: 'label', font_size: 'lg', text_color: 'secondary', txt: number);
}

Widget deleteButton(BuildContext context) {
  return const CustomIcon(icon: 'back', size: 'lg');
}
