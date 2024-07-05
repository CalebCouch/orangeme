import 'package:flutter/material.dart';
import 'package:orange/components/custom/icon_button.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/components/headers/header.dart';

class StackHeader extends StatelessWidget {
  final String text;
  final CustomIconButton? buttonIcon;

  const StackHeader({
    super.key,
    required this.text,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      left: const CustomBackButton(onTap: null),
      center: CustomText(
        textType: "heading",
        text: text,
        textSize: TextSize.h4,
        color: ThemeColor.heading,
      ),
    );
  }
}
