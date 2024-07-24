import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/util.dart';

Widget AmountDisplay(double value, double converted) {
  String accountBalance = "";

  _getValueDisplaySize(double value) {
    accountBalance = value.toString();
    if (accountBalance.length <= 4) {
      //1-4
      return TextSize.title;
    } else if (accountBalance.length >= 5 && accountBalance.length <= 7) {
      //5-7
      return TextSize.h1;
    } else {
      // 8-10
      return TextSize.h2;
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
          textSize: _getValueDisplaySize(value),
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
