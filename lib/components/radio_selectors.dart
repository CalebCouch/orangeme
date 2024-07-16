import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';

class TransactionSpeedSelector extends StatefulWidget {
  const TransactionSpeedSelector({
    super.key,
  });
  @override
  State<TransactionSpeedSelector> createState() => TransactionState();
}

class TransactionState extends State<TransactionSpeedSelector> {
  var priorityFee = 3.14;
  var standardFee = 5.45;
  int value = 0;
  List<String> currentIcon = [ThemeIcon.radioFilled, ThemeIcon.radio];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        radioButton(
            "Priority",
            "Arrives in ~30 minutes\n\$$priorityFee bitcoin network fee",
            value == 0 ? true : false,
            () {}),
        radioButton(
          "Standard",
          "Arrives in ~2 hours\n\$$standardFee bitcoin network fee",
          value == 1 ? true : false,
          () {},
        ),
      ],
    );
  }
}

Widget radioButton(String title, String subtitle, bool isEnabled, onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomIcon(
              icon: isEnabled ? ThemeIcon.radioFilled : ThemeIcon.radio,
              iconSize: IconSize.md),
          const Spacing(width: AppPadding.bumper),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  textType: 'heading',
                  alignment: TextAlign.left,
                  text: title,
                  textSize: TextSize.h5,
                ),
                const Spacing(height: 8),
                CustomText(
                  alignment: TextAlign.left,
                  text: subtitle,
                  textSize: TextSize.sm,
                  color: ThemeColor.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
