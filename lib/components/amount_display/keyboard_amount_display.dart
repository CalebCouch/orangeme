// THIS WHOLE PAGE NEEDS TO BE SIMPLIFIED AND MOST FUNCTIONS MOVED OUT

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/components/custom/custom_rich_text.dart';

import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_icon.dart';

class KeyboardAmountDisplay extends StatefulWidget {
  final String fiatAmount;
  final String quantity;
  final VoidCallback onShake;
  final bool exceedMaxBalance;
  final String maxBalance;

  const KeyboardAmountDisplay(
      {super.key,
      required this.fiatAmount,
      required this.quantity,
      required this.onShake,
      required this.exceedMaxBalance,
      required this.maxBalance});

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
    print("formatting fiat amount");
    if (fiatAmount.endsWith(".") ||
        fiatAmount.endsWith(".0") ||
        fiatAmount.endsWith(".00")) {
      print("amount already contains decimals");
      // If the amount ends with a decimal or specific zeroes after a decimal, return as is.
      return fiatAmount;
    }
    double? number = double.tryParse(fiatAmount);
    if (number == null) {
      print('failed parse when formatting, return 0');
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
    print(
        "keyboard value display widget: exceed max balance: ${widget.exceedMaxBalance}");
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
      print("Font size exceeds char length 6");
      fontSize = TextSize.h1;
    }
    if (widget.fiatAmount.length > 10) {
      print("font size exceeds char length 10");
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
                        text: "\$ ${formatFiatAmount(widget.fiatAmount)}",
                        textType: 'heading',
                        textSize: fontSize,
                      ),
                      if (showCents)
                        CustomText(
                          text: "\$",
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
                      Flexible(
                        child: CustomRichText(
                          text: "\$${widget.maxBalance} maximum",
                          color: ThemeColor.danger,
                        ),
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
