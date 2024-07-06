import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/bumpers/bumper.dart';
import 'package:orange/components/numeric_keypad/numeric_keypad.dart';

class KeypadBumper extends StatelessWidget {
  final void Function(String) updateAmount;

  const KeypadBumper({
    super.key,
    required this.updateAmount,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultBumper(
      content: Column(
        children: [
          NumericKeypad(
            onNumberPressed: updateAmount,
          ),
          const Spacing(height: AppPadding.bumper),
          CustomButton(
            variant: ButtonVariant.bitcoin,
            text: "Send",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
