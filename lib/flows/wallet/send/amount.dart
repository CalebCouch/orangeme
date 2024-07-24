import 'package:flutter/material.dart';
import 'dart:convert';
import "package:intl/intl.dart";
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/flows/wallet/send/transaction_speed.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class SendAmount extends StatefulWidget {
  final GlobalState globalState;
  final String address;
  const SendAmount(
    this.globalState,
    this.address, {
    super.key,
  });

  @override
  SendAmountState createState() => SendAmountState();
}

class SendAmountState extends State<SendAmount> {
  String amount = "0";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Future<void> next(double btc) async {
    navigateTo(
        context,
        TransactionSpeed(
            widget.globalState,
            /*transactions*/
            widget.address,
            btc));
  }

  void updateAmount(String input) {
    var updatedAmount = "0";
    if (input == "backspace") {
      if (amount.length == 1) {
        updatedAmount = "0";
      } else if (amount.isNotEmpty) {
        updatedAmount = amount.substring(0, amount.length - 1);
      } else {
        updatedAmount = amount;
      }
    } else if (input == ".") {
      print(".");
      if (!amount.contains(".")) {
        updatedAmount = amount += ".";
      } else {
        updatedAmount = amount;
      }
    } else {
      if (amount == "0") {
        updatedAmount = input;
      } else if (amount.contains(".")) {
        if (amount.length < 11 && amount.split(".")[1].length < 2) {
          updatedAmount = amount + input;
        } else {
          updatedAmount = amount;
        }
      } else {
        if (amount.length < 10) {
          updatedAmount = amount + input;
        } else {
          updatedAmount = amount;
        }
      }
    }

    double min = widget.globalState.state.value.fees[0] + 1;
    var max = widget.globalState.state.value.usdBalance - min;
    max = max > 0 ? max : 0;
    var err = "";
    if (double.parse(updatedAmount) <= min) {
      err = "\$${formatValue(min)} minimum.";
    } else if (double.parse(updatedAmount) >= max) {
      err = "\$${formatValue(max)} maximum.";
    }
    setState(() {
      print("setstate $updatedAmount");
      amount = updatedAmount;
      error = err;
    });
  }

  Widget buildScreen(BuildContext context, DartState state) {
    double parsed = double.parse(amount);
    double btc = parsed > 0
        ? (parsed / widget.globalState.state.value.currentPrice)
        : 0.0;
    return DefaultInterface(
      header: stackHeader(
        context,
        "Send bitcoin",
      ),
      content: Content(
        content: Center(
          child: keyboardAmountDisplay(
              widget.globalState, context, amount, btc, error),
        ),
      ),
      bumper: DefaultBumper(
        content: Column(
          children: [
            NumericKeypad(
              onNumberPressed: updateAmount,
            ),
            const Spacing(height: AppPadding.content),
            CustomButton(
              status: (amount != "0" && error == "") ? 0 : 2,
              variant: ButtonVariant.bitcoin,
              text: "Send",
              onTap: () => next(btc),
            ),
          ],
        ),
      ),
    );
  }
}

Widget keyboardAmountDisplay(GlobalState globalState, BuildContext context,
    String amt, double btc, String error) {
  String usd = amt.toString();

  Widget subText(String error) {
    if (error.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomIcon(
            icon: ThemeIcon.error,
            iconSize: IconSize.md,
            iconColor: ThemeColor.danger,
          ),
          const SizedBox(width: 8),
          CustomText(
            text: error,
            color: ThemeColor.danger,
          ),
        ],
      );
    } else {
      return CustomText(
        text: "${formatValue(btc, 8)} BTC",
        color: ThemeColor.textSecondary,
      );
    }
  }

  var amt_len = amt.contains(".") ? amt.length - 1 : amt.length;
  var textSize = amt_len < 4
      ? TextSize.title
      : amt_len < 7
          ? TextSize.h1
          : TextSize.h2;

  displayDecimals(amt) {
    int decimals = amt.contains(".") ? amt.split(".")[1].length : 0;
    print(decimals);
    String text;
    if (decimals == 0 && amt.contains(".")) {
      text = '00';
    } else if (decimals == 1) {
      text = '0';
    } else {
      text = '';
    }
    return CustomText(
      textType: 'heading',
      color: ThemeColor.textSecondary,
      textSize: textSize,
      text: text,
    );
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            textType: 'heading',
            textSize: TextSize.title,
            text: "\$$usd",
          ),
          displayDecimals(usd)
        ],
      ),
      subText(error)
    ],
  );
}
