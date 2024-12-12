import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material/material.dart';
import 'package:material/navigation.dart';

Widget CustomIconButton(onTap, {required String icon, String size = 'lg', String color = 'secondary'}) {
    return InkWell(
        onTap: () {
            HapticFeedback.heavyImpact();
            onTap();
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16), 
            child: CustomIcon(icon: icon, size: size, color: color)
        ),
    );
}

Widget SendButton({bool isEnabled = true, required onTap}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: CustomIconButton(onTap, icon: 'send'),
    );
}

Widget CustomBackButton(BuildContext context) {
    return CustomIconButton(
        () { navPop(context); }, 
        icon: 'left',
    );
}

Widget UniBackButton(BuildContext context, Widget destination) {
    return CustomIconButton(
        () { navigateTo(context, destination); }, 
        icon: 'left'
    );
}

Widget ExitButton(BuildContext context, Widget home) {
    return CustomIconButton(
        () { resetNavTo(context, home); }, 
        icon: 'close',
    );
}

Widget InfoButton(BuildContext context, Widget page) {
    return CustomIconButton(() { navigateTo(context, page); }, icon: 'info');
}

Widget NumberButton(BuildContext context, String number) {
    return CustomText(variant: 'label', font_size: 'lg', text_color: 'secondary', txt: number);
}

Widget DeleteButton(BuildContext context) {
  return const CustomIcon(icon: 'back', size: 'lg');
}
