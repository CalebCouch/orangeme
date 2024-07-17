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

import 'package:orange/flows/wallet_flow/send_flow/transaction_speed.dart';

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

  Future<void> next() async {
    var json = jsonDecode((await widget.globalState
            .invoke("create_transactions", "$amount|${widget.address}"))
        .data);
    var transactions =
        List<Transaction>.from(json.map((tx) => Transaction.fromJson(tx)));
    var min = transactions[2].fee + 1;
    var max = transactions[2].fee - widget.globalState.state.value.usdBalance;
    if (double.parse(amount) <= min) {
      setState(() => error = "\$$min minimum.");
    } else if (double.parse(amount) >= max) {
      setState(() => error = "\$$max maximum.");
    } else {
      navigateTo(
          context,
          TransactionSpeed(
            widget.globalState, /*transactions*/
          ));
    }
  }

  void updateAmount(String input) {
    var updatedAmount;
    if (input == "backspace") {
      if (amount.isNotEmpty) {
        updatedAmount = amount.substring(0, amount.length - 1);
      } else {
        updatedAmount = amount;
      }
    } else if (input == ".") {
      if (!amount.contains(".")) {
        updatedAmount = amount += ".";
      } else {
        updatedAmount = amount;
      }
    } else {
      if (amount.contains(".")) {
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
    setState(() => amount = updatedAmount);
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: stackHeader(
        context,
        "Send bitcoin",
      ),
      content: Content(
        content: Center(
          child:
              keyboardAmountDisplay(widget.globalState, context, amount, error),
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
              status: true ? 0 : 2,
              variant: ButtonVariant.bitcoin,
              text: "Send",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

Widget keyboardAmountDisplay(
    GlobalState globalState, BuildContext context, String amt, String error) {
  var btc = globalState.state.value.currentPrice / double.parse(amt);
  var decimals = amt.contains(".") ? amt.split(".")[1].length : 0;
  var amount;
  if (amt.contains(".")) {
    amount = NumberFormat("#,###", "en_US").format(double.parse(amount));
  } else {
    amount = NumberFormat("#,###.##", "en_US").format(double.parse(amount));
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CustomText(
        textType: 'text',
        textSize: amt.length > 4
            ? TextSize.title
            : amt.length > 7
                ? TextSize.h1
                : TextSize.h2,
        text: amt,
      ),
      Row(
        children: [
          error != ''
              ? Row(
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
                )
              : CustomText(
                  text: "$btc BTC",
                  color: ThemeColor.textSecondary,
                ),
        ],
      )
    ],
  );
}
