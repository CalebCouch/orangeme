import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_button.dart';

class DefaultBumper extends StatelessWidget {
  final String text;
  final String icon;

  const DefaultBumper({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return const CustomButton(
      buttonSize: ButtonSize.md,
      expand: false,
      variant: ButtonVariant.secondary,
      text: text,
      icon: icon,
      onTap: onTap,
    );
  }
}
