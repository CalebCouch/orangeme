import 'package:flutter/material.dart';

import 'package:orangeme_material/orangeme_material.dart';

// Displays a centered result message with an optional icon.

Widget Result(String resultMessage, [String icon = 'bitcoin']) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomIcon('$icon xxl'),
      const Spacing(16),
      CustomText('heading h3', resultMessage),
    ],
  );
}
