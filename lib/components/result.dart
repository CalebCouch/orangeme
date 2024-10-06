import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orangeme_material/orangeme_material.dart';

// Displays a centered result message with an optional icon.

Widget Result(String resultMessage, [String icon = ThemeIcon.bitcoin]) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomIcon('$icon xxl'),
      const Spacing(AppPadding.bumper),
      CustomText('heading h3', resultMessage),
    ],
  );
}
