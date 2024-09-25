import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'package:intl/intl.dart';
import 'dart:io' show Platform;

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/shake.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_icon.dart';

import 'package:orange/flows/bitcoin/send/speed.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/theme/stylesheet.dart';

/* BITCOIN SEND STEP TWO */

// This code defines a page for sending Bitcoin. It includes
// components for entering an amount, validating it, and transitioning to the
// next step in the transaction process. The interface features custom
// animations, keyboard handling, and conditional content based on the platform.

class ShakeController extends ChangeNotifier {
  void shake() => notifyListeners();
}

/* Listens for keyboard events and processes numeric inputs, backspace, 
and period key presses for computer keyboards. */

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

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/* Allows users to input and validate the amount of Bitcoin to send. Handles numeric 
input, error display, and transitions to the next step based on the input and validation. */
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

  /* Updates the input amount based on keyboard input, handles backspace, 
  decimal point, and numeric values. Validates the amount against minimum and maximum limits. */
  void updateAmount(String input) {
    var buzz = FeedbackType.warning;
    HapticFeedback.heavyImpact();
    var updatedAmount = "0";
    if (input == "backspace") {
      if (amount.length == 1) {
        updatedAmount = "0";
      } else if (amount.isNotEmpty) {
        updatedAmount = amount.substring(0, amount.length - 1);
      } else {
        Vibrate.feedback(buzz);
        _shakeController.shake();
        updatedAmount = amount;
      }
    } else if (input == ".") {
      if (!amount.contains(".") && amount.length <= 7) {
        updatedAmount = amount += ".";
      } else {
        Vibrate.feedback(buzz);
        _shakeController.shake();
        updatedAmount = amount;
      }
    } else {
      if (amount == "0") {
        updatedAmount = input;
      } else if (amount.contains(".")) {
        if (amount.length < 11 && amount.split(".")[1].length < 2) {
          updatedAmount = amount + input;
        } else {
          Vibrate.feedback(buzz);
          _shakeController.shake();
          updatedAmount = amount;
        }
      } else {
        if (amount.length < 10) {
          updatedAmount = amount + input;
        } else {
          Vibrate.feedback(buzz);
          _shakeController.shake();
          updatedAmount = amount;
        }
      }
    }

    double min = widget.globalState.state.value.fees[0] + 0.10;
    var max = widget.globalState.state.value.usdBalance - min;
    max = max > 0 ? max : 0;
    var err = "";
    if (double.parse(updatedAmount) != 0) {
      if (double.parse(updatedAmount) <= min) {
        err = "\$${formatValue(min)} minimum.";
      } else if (double.parse(updatedAmount) > max) {
        err = "\$${formatValue(max)} maximum.";
        if (err == "\$0 maximum.") {
          err = "You have no bitcoin.";
        }
      }
    }
    setState(() {
      amount = updatedAmount;
      error = err;
    });
  }

  double getBTC(amount) {
    double parsed = double.parse(amount);
    return parsed > 0
        ? (parsed / widget.globalState.state.value.currentPrice)
        : 0.0;
  }

  final ShakeController _shakeController = ShakeController();
  Widget buildScreen(BuildContext context, DartState state) {
    bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

    return Interface(
      widget.globalState,
      resizeToAvoidBottomInset: false,
      header: stackHeader(context, "Send bitcoin"),
      content: SimpleKeyboardListener(
        onPressed: updateAmount,
        child: Content(
          alignment: MainAxisAlignment.center,
          children: [
            ShakeWidget(
              controller: _shakeController,
              child: Center(
                child: keyboardAmountDisplay(
                  widget.globalState,
                  context,
                  amount,
                  getBTC(amount),
                  error,
                ),
              ),
            ),
          ],
        ),
      ),
      bumper: onDesktop
          ? singleButtonBumper(
              context,
              'Send',
              () => next(getBTC(amount)),
              (amount != "0" && error == "") ? true : false,
            )
          : keypadBumper(
              context,
              'Send',
              () => next(getBTC(amount)),
              (amount != "0" && error == "") ? true : false,
              updateAmount,
              _shakeController,
            ),
      desktopOnly: true,
      navigationIndex: 0,
    );
  }
}

/*  Displays the formatted amount in USD and BTC, along with any validation errors. 
Adjusts text size based on the amount length. */
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
        text: "${formatBTC(btc, 8)} BTC",
        color: ThemeColor.textSecondary,
      );
    }
  }

  displayDecimals(amt) {
    int decimals = amt.contains(".") ? amt.split(".")[1].length : 0;
    if (decimals == 0 && amt.contains(".")) {
      return '00';
    } else if (decimals == 1) {
      return '0';
    } else {
      return '';
    }
  }

  String valueUSD = '0';
  String x = '';
  if (usd.contains('.')) x = usd.split(".")[1];
  if (usd.contains('.') && x.isEmpty) {
    valueUSD = NumberFormat("#,###", "en_US").format(double.parse(usd));
    valueUSD += '.';
  } else if (usd.contains('.') && x.isNotEmpty) {
    valueUSD =
        NumberFormat("#,###", "en_US").format(double.parse(usd.split('.')[0]));
    valueUSD += '.$x';
  } else {
    valueUSD = NumberFormat("#,###", "en_US").format(double.parse(usd));
  }

  var length = usd.length;
  if (usd.contains('.')) length - 1;
  length = usd.length + displayDecimals(usd).length;

  var textSize = length <= 5
      ? TextSize.title
      : length <= 7
          ? TextSize.subtitle
          : TextSize.h1;

  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Column(
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
    ),
  );
}
