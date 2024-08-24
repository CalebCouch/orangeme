import 'package:flutter/material.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/numeric_keypad.dart';

// This code provides a DefaultBumper widget for consistent button layouts and
// defines three functions to create single-button, double-button, and keypad
// configurations with customizable styles and padding.

class DefaultBumper extends StatelessWidget {
  final Widget content;
  const DefaultBumper({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 396),
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      alignment: Alignment.center,
      child: content,
    );
  }
}

Widget singleButtonBumper(BuildContext context, String text, onTap,
    [bool isEnabled = true,
    variant,
    bool padding = true,
    ShakeController? shakeController]) {
  return DefaultBumper(
    content: Container(
      padding: padding
          ? const EdgeInsets.symmetric(vertical: AppPadding.bumper)
          : null,
      child: CustomButton(
        shakeController: shakeController,
        variant: variant ?? ButtonVariant.primary,
        text: text,
        onTap: onTap,
        status: isEnabled ? 0 : 2,
      ),
    ),
  );
}

Widget keypadBumper(BuildContext context, String text, onTap,
    [bool isEnabled = true, updateAmount, ShakeController? shakeController]) {
  return DefaultBumper(
    content: Column(
      children: [
        NumericKeypad(
          onNumberPressed: updateAmount,
        ),
        const Spacing(height: AppPadding.content),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppPadding.bumper),
          child: CustomButton(
            shakeController: shakeController,
            text: text,
            onTap: onTap,
            status: isEnabled ? 0 : 2,
          ),
        ),
      ],
    ),
  );
}

Widget doubleButtonBumper(BuildContext context, String text, String secondText,
    onTapFirst, onTapSecond,
    [bool padding = true]) {
  return DefaultBumper(
    content: Container(
      padding: padding
          ? const EdgeInsets.symmetric(vertical: AppPadding.bumper)
          : null,
      child: Row(
        children: [
          Flexible(
            child: CustomButton(
              text: text,
              onTap: onTapFirst,
            ),
          ),
          const Spacing(width: AppPadding.bumper),
          Flexible(
            child: CustomButton(
              text: secondText,
              onTap: onTapSecond,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget keypadBumper(
  BuildContext context,
  onTap,
  updateAmount,
  status,
  shakeController,
) {
  return DefaultBumper(
    content: Column(
      children: [
        NumericKeypad(
          onNumberPressed: updateAmount,
        ),
        const Spacing(height: AppPadding.content),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppPadding.bumper),
          child: CustomButton(
            variant: ButtonVariant.primary,
            text: 'Send',
            onTap: onTap,
            status: status,
            shakeController: shakeController,
          ),
        ),
      ],
    ),
  );
}
