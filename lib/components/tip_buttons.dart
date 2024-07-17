import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/custom/custom_text.dart';

class ButtonTip {
  final String text;
  final String icon;
  final VoidCallback? onTap;

  const ButtonTip(this.text, this.icon, this.onTap);
}

Widget tipButton(ButtonTip buttonTip) {
  return CustomButton(
    buttonSize: ButtonSize.md,
    expand: false,
    variant: ButtonVariant.secondary,
    text: buttonTip.text,
    icon: buttonTip.icon,
    onTap: buttonTip.onTap,
  );
}

Widget threeTips(List<ButtonTip> buttonTips) {
  return Column(
    children: [
      const Spacing(height: AppPadding.tips),
      tipButton(buttonTips[0]),
      const Spacing(height: AppPadding.tips),
      tipButton(buttonTips[1]),
      const Spacing(height: AppPadding.tips),
      const CustomText(
        text: 'or',
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
      ),
      const Spacing(height: AppPadding.tips),
      tipButton(buttonTips[2]),
      const Spacing(height: AppPadding.tips),
    ],
  );
}

Widget twoTips(List<ButtonTip> buttonTips) {
  print('button tips ${buttonTips.length}');
  return Column(
    children: [
      const Spacing(height: AppPadding.tips),
      tipButton(buttonTips[0]),
      const Spacing(height: AppPadding.tips),
      const CustomText(
        text: 'or',
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
      ),
      const Spacing(height: AppPadding.tips),
      tipButton(buttonTips[1]),
      const Spacing(height: AppPadding.tips),
    ],
  );
}

Widget oneTip(ButtonTip buttonTip) {
  return Column(
    children: [
      tipButton(buttonTip),
    ],
  );
}
