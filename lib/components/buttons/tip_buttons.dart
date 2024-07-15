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

class TipButtonStack extends StatelessWidget {
  final List<ButtonTip> buttons;

  const TipButtonStack({
    super.key,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return stack(buttons);
  }
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

Widget stack(List<ButtonTip> buttonTips) {
  if (buttonTips.length == 1) return one(buttonTips);
  if (buttonTips.length == 2) return two(buttonTips);
  if (buttonTips.length == 3) return three(buttonTips);
  return Container();
}

Widget three(List<ButtonTip> buttonTips) {
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

Widget two(List<ButtonTip> buttonTips) {
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

Widget one(List<ButtonTip> buttonTips) {
  return Column(
    children: [
      tipButton(buttonTips[0]),
    ],
  );
}
