import 'package:flutter/material.dart';

import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/util.dart';

// Displays a formatted monetary value and its equivalent in BTC. Adjusts text
// size based on the length of the value and uses different text styles for the
// currency amount and its conversion.

Widget amountDisplay(double value, double converted) {
  String accountBalance = "";

  getValueDisplaySize(double value) {
    accountBalance = value.toString();
    if (accountBalance.length <= 4) {
      //1-4
      return TextSize.title;
    } else if (accountBalance.length >= 5 && accountBalance.length <= 7) {
      //5-7
      return TextSize.subtitle;
    } else {
      // 8-10
      return TextSize.h1;
    }
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: AppPadding.valueDisplay),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          textType: "heading",
          text: "\$${formatValue(value)}",
          textSize: getValueDisplaySize(value),
          color: ThemeColor.heading,
        ),
        const Spacing(height: AppPadding.valueDisplaySep),
        CustomText(
          textType: "text",
          text: "${formatValue(converted, 8)} BTC",
          textSize: TextSize.lg,
          color: ThemeColor.textSecondary,
        ),
      ],
    ),
  );
}
