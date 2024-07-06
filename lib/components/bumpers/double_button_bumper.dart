import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/bumpers/bumper.dart';

class DoubleButton extends StatelessWidget {
  final String firstText;
  final String secondText;

  final VoidCallback firstOnTap;
  final VoidCallback secondOnTap;

  const DoubleButton(
      {super.key,
      required this.firstText,
      required this.secondText,
      required this.firstOnTap,
      required this.secondOnTap});

  @override
  Widget build(BuildContext context) {
    return DefaultBumper(
      content: Row(
        children: [
          Flexible(
            child: CustomButton(
              text: firstText,
              onTap: firstOnTap,
            ),
          ),
          const Spacing(width: AppPadding.bumper),
          Flexible(
            child: CustomButton(
              text: secondText,
              onTap: secondOnTap,
            ),
          ),
        ],
      ),
    );
  }
}
