import 'package:flutter/material.dart';
import 'package:orange/components/buttons/icon_button.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/components/headers/header.dart';

class StackButtonHeader extends StatelessWidget {
  final String text;
  final Widget? iconButton;
  final bool rightEnabled;
  final String rightText;
  final VoidCallback? rightOnTap;

  const StackButtonHeader({
    super.key,
    required this.text,
    this.iconButton,
    this.rightEnabled = false,
    this.rightText = 'Next',
    this.rightOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      left: iconButton == null ? const CustomBackButton() : iconButton!,
      center: CustomText(
        textType: "heading",
        text: text,
        textSize: TextSize.h4,
        color: ThemeColor.heading,
      ),
      right: rightEnabled
          ? CustomButton(
              onTap: rightOnTap ?? () {},
              expand: false,
              text: rightText,
              variant: ButtonVariant.ghost,
              buttonSize: ButtonSize.md,
            )
          : null,
    );
  }
}
