import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';

class ButtonTip extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback? onTap;

  const ButtonTip(this.text, this.icon, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      buttonSize: ButtonSize.md,
      expand: false,
      variant: ButtonVariant.secondary,
      text: text,
      icon: icon,
      onTap: onTap,
    );
  }
}

Widget oneTip(ButtonTip buttonTip) {
  return Column(
    children: [
      buttonTip,
    ],
  );
}
