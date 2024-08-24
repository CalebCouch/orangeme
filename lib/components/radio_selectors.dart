import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_text.dart';

// Creates a radio button UI component with a title, subtitle, and toggleable enabled state.

Widget radioButton(String title, String subtitle, bool isEnabled, onTap) {
  return InkWell(
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
