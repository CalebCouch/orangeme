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

class KeyboardAmountDisplay extends StatefulWidget {
  final String fiatAmount;
  final String quantity;
  final VoidCallback onShake;
  final bool exceedMaxBalance;
  final String maxBalance;

  const KeyboardAmountDisplay({
    super.key,
    required this.fiatAmount,
    required this.quantity,
    required this.onShake,
    required this.exceedMaxBalance,
    required this.maxBalance,
  });

  @override
  KeyboardValueDisplayState createState() => KeyboardValueDisplayState();
}

class KeyboardValueDisplayState extends State<KeyboardAmountDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticIn),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

// Displays a short shaking animation to warn a user against an illegal keyboard input
  void shake() {
    _animationController.forward(from: 0);
    _vibrate();
  }

  void _vibrate() {
    const int vibrationDuration = 1;
    const int totalDuration = 200;
    int numberOfVibrations = totalDuration ~/ vibrationDuration;
    for (int i = 0; i < numberOfVibrations; i++) {
      Future.delayed(Duration(milliseconds: i * vibrationDuration), () {
        SystemChannels.platform.invokeMethod('HapticFeedback.vibrate');
      });
    }
  }

  // Formats a provided amount with commas if necessary
  String formatFiatAmount(String fiatAmount) {
    if (fiatAmount.endsWith(".") ||
        fiatAmount.endsWith(".0") ||
        fiatAmount.endsWith(".00")) {
      // If the amount ends with a decimal or specific zeroes after a decimal, return as is.
      return fiatAmount;
    }
    double? number = double.tryParse(fiatAmount);
    if (number == null) {
      return "0"; // Default to 0 if parsing fails.
    } else {
      // Create a format that shows up to two decimal places only if there are non-zero decimals.
      NumberFormat format = NumberFormat("#,###.##", "en_US");
      String formattedAmount = format.format(number);
      // Check if original input had decimals and adjust accordingly.
      if (fiatAmount.contains('.') && fiatAmount.endsWith('0')) {
        int decimalIndex = fiatAmount.indexOf('.');
        int decimals = fiatAmount.length - decimalIndex - 1;
        if (decimals == 2) {
          formattedAmount += "0";
          print("formatting decimal with placeholder zeroes");
        }
      }
      return formattedAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    String amountToDisplay = widget.fiatAmount;
    String decimalExtension = '';
    bool showCents = false;
    if (amountToDisplay.contains('.')) {
      int decimalCount =
          amountToDisplay.length - amountToDisplay.indexOf('.') - 1;
      switch (decimalCount) {
        case 0:
          decimalExtension = '00';
          showCents = true;
          break;
        case 1:
          decimalExtension = '0';
          showCents = true;
          break;
        case 2:
          decimalExtension = '';
          break;
        default:
          decimalExtension = '';
      }
    }

    double fontSize = TextSize.title;
    if (widget.fiatAmount.length > 6) {
      fontSize = TextSize.h1;
    }
    if (widget.fiatAmount.length > 10) {
      fontSize = TextSize.h2;
    }

    // Adjust width dynamically based on the length of fiatAmount
    double containerWidth = (widget.fiatAmount.length <= 8) ? 310 : 360;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: SizedBox(
        width: containerWidth,
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
              child: Container(
                constraints: BoxConstraints(maxWidth: containerWidth),
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
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!widget.exceedMaxBalance)
                  CustomText(
                    text: "${widget.quantity.toString()} BTC",
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
          ],
        ),
      ),
    );
  }
}

class SendAmount extends StatefulWidget {
  final GlobalState globalState;
  const SendAmount(
    this.globalState, {
    super.key,
  });

  @override
  SendAmountState createState() => SendAmountState();
}

class SendAmountState extends State<SendAmount> {
  String amount = "0";
  int balance = 0;
  double price = 63239.23;
  final GlobalKey<KeyboardValueDisplayState> _displayKey =
      GlobalKey<KeyboardValueDisplayState>();
  bool isButtonEnabled = false;
  bool exceedMaxBalance = false;

  //algorithim used to control the logic of the virtual keyboard
  void _updateAmount(String input) {
    print("character is $input");
    double maxDollarAmount = (balance / 100000000) * price;
    String tempAmount = amount;
    if (input == "backspace") {
      print("found backspace");
      if (tempAmount.length > 1) {
        tempAmount = tempAmount.substring(0, tempAmount.length - 1);
        double? tempAmountDouble = double.tryParse(tempAmount);
        print('accept backspace: new temp amount: $tempAmount');
        if (tempAmountDouble! <= maxDollarAmount && exceedMaxBalance == true) {
          setState(() {
            //reset exceedMaxBalance warning after backspace
            print('amount below max: reset warning');
            exceedMaxBalance = false;
          });
        }
        //if tempAmount becomes empty after backspacing, reset to 0
        if (tempAmount == "" || tempAmount == "0") {
          print("backspace on empty field, reset field to zero");
          tempAmount = "0";
        }
        //default to 0 catchall
      } else {
        tempAmount = "0";
      }
    } else {
      //enforce a 9 digit number or 12 digits with decimal
      if ((amount.contains('.') && amount.length >= 12) ||
          (!amount.contains('.') && amount.length == 9 && input != '.')) {
        print("invalid input: max digits");
        _displayKey.currentState?.shake();
        return;
      }
      if (tempAmount == "0.00" || tempAmount == "0") {
        // Avoid leading zero unless entering a decimal
        tempAmount = (input == ".") ? "0." : input;
      } else {
        // prevent leading zeroes in whole numbers
        if (tempAmount == "0" && input != "." && tempAmount != "0.") {
          tempAmount = input; // Replace leading zero
        } else {
          tempAmount += input;
        }
      }
    }
    //check if tempamount exceeds max amount
    double? tempAmountDouble = double.tryParse(tempAmount);
    if (tempAmountDouble != null && tempAmountDouble > maxDollarAmount) {
      print(
          "Attempting to exceed max balance current amount: $amount temp amount: $tempAmount");
      setState(() {
        //show error feedback to the user, disable the continue button
        exceedMaxBalance = true;
        amount = tempAmount;
        evaluateButton(tempAmount, maxDollarAmount);
      });
      //standard key input
    } else {
      setState(() {
        print("standard input amount: $amount temp amount: $tempAmount");
        amount = tempAmount;
        evaluateButton(tempAmount, maxDollarAmount);
      });
    }
  }

  //evalute if the send button should be activated
  void evaluateButton(String tempAmount, maxDollarAmount) {
    double? amountDouble = double.tryParse(amount);
    double? tempAmountDouble = double.tryParse(tempAmount);
    //button only activates if you are not exceed max dollar amount of your wallet, and you enter an amount greater than $0.01
    if (amountDouble != null &&
        amountDouble >= 0.01 &&
        tempAmountDouble! <= maxDollarAmount) {
      isButtonEnabled = true;
      //otherwise it deactivates
    } else {
      isButtonEnabled = false;
    }
  }

  //format a number of satoshis into dollars at the last known exchange rate
  String formatDollarsToBTC(String amount, double? price, bool satsFormat) {
    if (!satsFormat) {
      print("sats format false, giving decimal format");
      //with sats format false, here we format into BTC
      if (amount == "" || amount == "0.00" || amount == "0." || amount == "0") {
        return "0.00000000";
      } else {
        print("formatting...USD qty: $amount price: $price");
        double? qtyNull = double.tryParse(amount);
        if (qtyNull != null) {
          double qty = (double.parse(amount) / price!);
          print("formatted quantity: $qty");
          return qty.abs().toStringAsFixed(8);
        } else {
          return "0.00000000";
        }
      }
    } else {
      //with satsFormat true, here we format into Satoshis
      print("sats format true, giving sats format");
      if (amount == "" || amount == "0.00" || amount == "0." || amount == "0") {
        return "0";
      } else {
        print("formatting...USD qty: $amount price: $price");
        double qty = (double.parse(amount) / price!);
        print("sats quantity: $qty");
        double sats = (qty * 100000000);
        print("formatted quantity: $sats");
        return sats.round().toString();
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: stackHeader(
        context,
        "Send bitcoin",
      ),
      content: Content(
        content: Center(
          child: KeyboardAmountDisplay(
            key: _displayKey,
            fiatAmount: amount == '' ? '0' : amount,
            quantity: amount == ''
                ? formatDollarsToBTC('0', price, false)
                : formatDollarsToBTC(amount, price, false),
            onShake: () {},
            exceedMaxBalance: exceedMaxBalance == true ? true : false,
            maxBalance: ((balance / 100000000) * price).toStringAsFixed(2),
          ),
        ),
      ),
      bumper: DefaultBumper(
        content: Column(
          children: [
            NumericKeypad(
              onNumberPressed: _updateAmount,
            ),
            const Spacing(height: AppPadding.content),
            CustomButton(
              /*status: (amount != '' && amount != '0'
                      ? exceedMaxBalance == true
                          ? false
                          : true
                      : false)
                  ? 1
                  : 2,*/
              variant: ButtonVariant.bitcoin,
              text: "Send",
              onTap: () {
                navigateTo(context, TransactionSpeed(widget.globalState));
              },
            ),
          ],
        ),
      ),
    );
  }
}
