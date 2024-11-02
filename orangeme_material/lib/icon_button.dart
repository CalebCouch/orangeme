import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orangeme_material/icon.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/text.dart';

Widget iconButton(onTap, String buttonData) {
  List<String> x = buttonData.split(' ');

  return InkWell(
    onTap: () {
      HapticFeedback.heavyImpact();
      onTap();
    },
    child: CustomIcon('${x[0]} ${x[1]}'),
  );
}

Widget sendButton(bool isEnabled) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: iconButton(null, 'send lg'),
  );
}

Widget backButton(BuildContext context) {
  return iconButton(() {
    navPop(context);
  }, 'left lg');
}

Widget exitButton(BuildContext context, Widget home) {
  return iconButton(() {
    resetNavTo(context, home);
  }, 'close lg');
}

Widget infoButton(BuildContext context, Widget page) {
  return iconButton(() {
    navigateTo(context, page);
  }, 'info lg');
}

Widget numberButton(BuildContext context, String number) {
  return CustomText('label lg secondary', number);
}

Widget deleteButton(BuildContext context) {
  return const CustomIcon('back lg');
}
