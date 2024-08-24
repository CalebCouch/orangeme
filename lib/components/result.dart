import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';

// Displays a centered result message with an optional icon.

Widget result(String resultMessage, [String icon = ThemeIcon.bitcoin]) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomIcon(
        icon: icon,
        iconColor: ThemeColor.secondary,
        iconSize: 128,
      ),
      const Spacing(height: AppPadding.bumper),
      CustomText(
        text: resultMessage,
        textType: 'heading',
        textSize: TextSize.h3,
      ),
    ],
  );
}
