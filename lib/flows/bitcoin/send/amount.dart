import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/numeric_keypad.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'dart:io' show Platform;

import 'package:orange/flows/bitcoin/send/transaction_speed.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class SimpleKeyboardListener extends StatefulWidget {
  final void Function(String) onPressed;
  final Widget child;

  const SimpleKeyboardListener({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<SimpleKeyboardListener> createState() => _SimpleKeyboardListenerState();
}

class _SimpleKeyboardListenerState extends State<SimpleKeyboardListener> {
  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      if (isNumeric(key)) {
        widget.onPressed(key);
      }
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        widget.onPressed('backspace');
      }
      if (event.logicalKey == LogicalKeyboardKey.period) {
        widget.onPressed('.');
      }
    }

    return false;
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return widget.child;
  }
}

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
        widget.address,
        btc,
      ),
    );
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
      if (!amount.contains(".") && amount.length <= 8) {
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
      amount = updatedAmount;
      error = err;
    });
  }

  Widget buildScreen(BuildContext context, DartState state) {
    double parsed = double.parse(amount);
    double btc = parsed > 0
        ? (parsed / widget.globalState.state.value.currentPrice)
        : 0.0;
    bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

    return Interface(
      widget.globalState,
      resizeToAvoidBottomInset: false,
      header: stackHeader(
        context,
        "Send bitcoin",
      ),
      content: SimpleKeyboardListener(
        onPressed: updateAmount,
        child: Content(
          content: Center(
            child: keyboardAmountDisplay(
                widget.globalState, context, amount, btc, error),
          ),
        ),
      ),
      bumper: DefaultBumper(
        content: Column(
          children: [
            !onDesktop
                ? NumericKeypad(
                    onNumberPressed: updateAmount,
                  )
                : Container(),
            const Spacing(height: AppPadding.content),
            CustomButton(
              status: (amount != "0" && error == "") ? 0 : 2,
              text: "Send",
              onTap: () => next(btc), //change to btc
            ),
          ],
        ),
      ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}

Widget keyboardAmountDisplay(GlobalState globalState, BuildContext context,
    String amt, double btc, String error) {
  String usd = amt.toString();
  bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

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
    } else if (onDesktop && amt == "0") {
      return const CustomText(
        text: "Type dollar amount.",
        color: ThemeColor.textSecondary,
      );
    } else {
      return CustomText(
        text: "${formatValue(btc, 8)} BTC",
        color: ThemeColor.textSecondary,
      );
    }
  }

  displayDecimals(amt) {
    int decimals = amt.contains(".") ? amt.split(".")[1].length : 0;
    String text;
    if (decimals == 0 && amt.contains(".")) {
      return text = '00';
    } else if (decimals == 1) {
      return text = '0';
    } else {
      return text = '';
    }
  }

  String valueUSD = '0';
  var x;
  if (usd.contains('.')) x = usd.split(".")[1];
  if (usd.contains('.') && x.isEmpty) {
    valueUSD = formatValue(double.parse(usd));
    valueUSD += '.';
  } else if (usd.contains('.') && x.isNotEmpty) {
    valueUSD = formatValue(double.parse(usd.split('.')[0]));
    valueUSD += '.$x';
  } else {
    valueUSD = formatValue(double.parse(usd));
  }

  var length = usd.length;
  if (usd.contains('.')) length - 1;
  length = usd.length + displayDecimals(usd).length;

  print(usd);

  var textSize = length <= 5
      ? TextSize.title
      : length <= 7
          ? TextSize.subtitle
          : TextSize.h1;

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
            textSize: textSize,
            text: "\$$valueUSD",
          ),
          CustomText(
            textType: 'heading',
            color: ThemeColor.textSecondary,
            textSize: textSize,
            text: displayDecimals(usd),
          ),
        ],
      ),
      subText(error)
    ],
  );
}
