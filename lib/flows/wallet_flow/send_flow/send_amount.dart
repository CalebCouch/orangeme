import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final GlobalKey<KeyboardValueDisplayState> _displayKey =
      GlobalKey<KeyboardValueDisplayState>();

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
    var json = jsonDecode((await invoke("create_transactions", "${amount}|${widget.address}")).data);
    var transactions = List<Transaction>.from(json.map((tx) => Transaction.fromJson(tx)))
    var min = transactions[2].fee + 1;
    var max = transactions[2].fee - widget.globalState.state.value.usdBalance;
    if (amount <= min) {
        setState(() => error = "\$${min} minimum.")
    } else if (amount >= max) {
        setState(() => error = "\$${max} maximum.")
    } else {
        navigateTo(context, TransactionSpeed(transactions, widget.globalState));
    }
  }

  void updateAmount(String input) {
    var updatedAmount = if (input == "backspace") {
        if (amount.isNotEmpty()) {
            amount.substring(0, amount.length-1)
        } else {amount}
    } else if (input == "." && ) {
        if (!amount.contains(".")) {
            amount + "."
        } else {amount}
    } else {
        if (amount.contains(".") {
            if (amount.length < 11 && amount.split(".")[1].length < 2) {
                amount + input
            } else {amount}
        } else {
            if (amount.length < 10) {
                amount + input
            } else {amount}
        }
    };
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
          child: keyboardAmountDisplay(amount, error),
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
              status: validAmount ? 0 : 2,
              variant: ButtonVariant.bitcoin,
              text: "Send",
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget keyboardAmountDisplay(BuildContext context, String amount, String error) {
  var btc = widget.globalState.state.value.price / double.parse(amount);
  var decimals = amount.contains(".") ? amount.split(".")[1].length : 0;
  var amount = if amount.contains(".") {
      NumberFormat("#,###", "en_US").format(double.parse(amount))
  } else {
      NumberFormat("#,###.##", "en_US").format(double.parse(amount))
  };


  double fontSize = TextSize.title;
  if (widget.fiatAmount.length > 6) {
    fontSize = TextSize.h1;
  }
  if (widget.fiatAmount.length > 10) {
    fontSize = TextSize.h2;
  }

  return AnimatedBuilder(
    animation: _shakeAnimation,
    builder: (context, child) {
      return Transform.translate(
        offset: Offset(_shakeAnimation.value, 0),
        child: child,
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: child,
            );
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                CustomText(
                  text: "\$${formatFiatAmount(widget.fiatAmount)}",
                  textType: 'heading',
                  textSize: fontSize,
                ),
                if (showCents)
                  CustomText(
                    text: decimalExtension,
                    textType: 'heading',
                    textSize: fontSize,
                    color: ThemeColor.textSecondary,
                  )
              ],
            ),
          ),
        ),
        if (!widget.exceedMaxBalance)
          CustomText(
            text: "${widget.btcAmount.toString()} BTC",
            color: ThemeColor.textSecondary,
          ),
        if (widget.exceedMaxBalance)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomIcon(
                icon: ThemeIcon.error,
                iconSize: IconSize.md,
                iconColor: ThemeColor.danger,
              ),
              const SizedBox(width: 8),
              CustomText(
                text: "\$${widget.maxBalance} maximum",
                color: ThemeColor.danger,
              ),
            ],
          ),
      ],
    ),
  );
}
