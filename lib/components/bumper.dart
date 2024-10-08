import 'package:flutter/material.dart';
//import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/custom/custom_button.dart';

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

Widget messageInput() {
  return DefaultBumper(
    content: Container(
      padding: const EdgeInsets.only(
        bottom: AppPadding.bumper,
        top: AppPadding.bumper / 2,
      ),
      child: const CustomTextInput(
        hint: 'Message',
        showIcon: true,
      ),
    ),
  );
}
