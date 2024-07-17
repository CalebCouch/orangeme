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
  double amount = 0;
  double balance = 0;
  double price = getCurrentBitcoinPrice();
  final GlobalKey<KeyboardValueDisplayState> _displayKey =
      GlobalKey<KeyboardValueDisplayState>();
  bool exceedMaxBalance = false;

   @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  void _updateAmount(String input) {
    String tempAmount = amount;
    if (input == "backspace" && tempAmount.isNotEmpty) {
      tempAmount = tempAmount.substring(0, tempAmount.length - 1);
    } else if (input == '.') {
      if (!amount.contains('.')) {
        tempAmount += input;
      } else {
        return;
      }
    } else if (tempAmount == '0') {
      tempAmount = input;
    } else {
      tempAmount += input;
    }

    if (double.tryParse(tempAmount)! > balance) {
      setState(() {
        exceedMaxBalance = true;
        amount = tempAmount;
      });
    } else {
      setState(() {
        amount = tempAmount;
        exceedMaxBalance = false;
      });
    }
  }

  getBTCAmount() {
    return 0.000000;
  }

 

  Widget buildScreen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: stackHeader(
        context,
        "Send bitcoin",
      ),
      content: Content(
        content: Center(
          child: keyboardAmountDisplay(amount, amount + 5 <= state.usdBalance ? "" : ),
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
              status: (amount != '' && double.tryParse(amount)! > 0.1
                      ? !exceedMaxBalance
                          ? true
                          : false
                      : false)
                  ? 1
                  : 2,
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

class KeyboardAmountDisplay extends StatefulWidget {
  final String fiatAmount;
  final String btcAmount;
  final VoidCallback onShake;
  final bool exceedMaxBalance;
  final String maxBalance;

  const KeyboardAmountDisplay({
    super.key,
    required this.fiatAmount,
    required this.btcAmount,
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

  String formatFiatAmount(int usd) {
    print("usd: ${usd}");
    String fiatAmount = usd.toString();
    if (fiatAmount.endsWith(".") ||
        fiatAmount.endsWith(".0") ||
        fiatAmount.endsWith(".00")) {
      return fiatAmount;
    }
    double? number = double.tryParse(fiatAmount);
    if (number == null) {
      return "0";
    } else {
      NumberFormat format = NumberFormat("#,###.##", "en_US");
      String formattedAmount = format.format(number);
      if (fiatAmount.contains('.') && fiatAmount.endsWith('0')) {
        int decimalIndex = fiatAmount.indexOf('.');
        int decimals = fiatAmount.length - decimalIndex - 1;
        if (decimals == 2) {
          formattedAmount += "0";
        }
      }
      return formattedAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('amount: ${formatFiatAmount(widget.fiatAmount)}');
    String amountToDisplay = widget.fiatAmount;
    String decimalExtension = '';
    bool showCents = false;
    if (widget.fiatAmount.contains('.')) {
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
}
