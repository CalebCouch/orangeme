import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orangeme_material/icon.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/text.dart';

Widget CustomIconButton(onTap, String icon, String size) {
    return InkWell(
        onTap: () {
            HapticFeedback.heavyImpact();
            onTap();
        },
        child: Container(padding: EdgeInsets.only(left: 16), child: CustomIcon(icon: icon, size: size)),
    );
}

Widget SendButton(bool isEnabled) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: CustomIconButton(null, 'send', 'lg'),
    );
}

Widget CustomBackButton(BuildContext context) {
    return CustomIconButton(
        () { navPop(context); }, 
        'left',
        'lg'
    );
}

Widget ExitButton(BuildContext context, Widget home) {
    return CustomIconButton(
        () { resetNavTo(context, home); }, 
        'close',
        'lg'
    );
}

Widget InfoButton(BuildContext context, Widget page) {
    return CustomIconButton(
        () { navigateTo(context, page); }, 
        'info',
        'lg',
    );
}

Widget NumberButton(BuildContext context, String number) {
    return CustomText(variant: 'label', font_size: 'lg', text_color: 'secondary', txt: number);
}

Widget DeleteButton(BuildContext context) {
  return const CustomIcon(icon: 'back', size: 'lg');
}
