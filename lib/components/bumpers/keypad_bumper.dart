import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/bumpers/bumper.dart';
import 'package:orange/components/numeric_keypad/numeric_keypad.dart';

import 'package:orange/flows/wallet_flow/send_flow/transaction_speed.dart';

import 'package:orange/util.dart';

Widget KeypadBumper(BuildContext context, void Function(String) updateAmount, bool? isEnabled) {
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
