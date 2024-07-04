import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/theme/custom_button.dart';
import 'package:orange/components/bumpers/default_bumper.dart';

class DoubleButton extends StatelessWidget {
  final String firstText;
  final String secondText;

  final VoidCallback? firstOnTap;
  final VoidCallback? secondOnTap;

  const DoubleButton(
      {super.key,
      required this.firstText,
      required this.secondText,
      this.firstOnTap,
      this.secondOnTap});

  @override
  Widget build(BuildContext context) {
    return DefaultBumper(
      content: Row(
        children: [
          CustomButton(
            text: firstText,
            //onTap: firstOnTap,
          ),
          const Spacing(width: AppPadding.bumper),
          CustomButton(
            text: secondText,
            //onTap: secondOnTap,
          ),
        ],
      ),
    );
  }
}
