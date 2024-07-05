import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_button.dart';

class IconTextButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback? onTap;

  const IconTextButton({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });

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
