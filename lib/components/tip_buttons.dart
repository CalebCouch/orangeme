import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';

class ButtonTip extends StatelessWidget {
  final String text;
  final String? icon;
  final VoidCallback? onTap;

  const ButtonTip({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.tips),
      child: CustomButton(
        buttonSize: ButtonSize.md,
        expand: false,
        variant: ButtonVariant.secondary,
        text: text,
        icon: icon,
        onTap: onTap,
      ),
    );
  }
}
