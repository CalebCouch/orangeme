import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/numeric_keypad.dart';

import 'package:orange/flows/wallet_flow/send_flow/transaction_speed.dart';

import 'package:orange/util.dart';

class DefaultBumper extends StatelessWidget {
  final Widget content;

  const DefaultBumper({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      alignment: Alignment.center,
      child: content,
    );
  }
}

Widget keypadBumper(
    BuildContext context, void Function(String) updateAmount, bool? isEnabled) {
  return DefaultBumper(
    content: Column(
      children: [
        NumericKeypad(
          onNumberPressed: updateAmount,
        ),
        const Spacing(height: AppPadding.content),
        CustomButton(
          //status: (isEnabled ?? true) ? 1 : 2,
          variant: ButtonVariant.bitcoin,
          text: "Send",
          onTap: () {
            navigateTo(context, const TransactionSpeed());
          },
        ),
      ],
    ),
  );
}

Widget singleButtonBumper(BuildContext context, String text, onTap,
    [bool isEnabled = true, variant]) {
  return DefaultBumper(
    content: CustomButton(
      variant: variant ?? ButtonVariant.bitcoin,
      text: text,
      onTap: onTap,
      status: isEnabled ? 0 : 2,
    ),
  );
}

Widget doubleButtonBumper(BuildContext context, String text, String secondText,
    onTapFirst, onTapSecond) {
  return DefaultBumper(
    content: Row(
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
  );
}
