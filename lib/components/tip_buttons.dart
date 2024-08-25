import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';

/* A widget that creates a medium-sized button with text and an icon, using a secondary style. Includes an optional tap callback. */

class ButtonTip extends StatelessWidget {
  final String text;
  final String? icon;
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
