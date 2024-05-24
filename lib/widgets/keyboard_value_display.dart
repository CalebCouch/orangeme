import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orange/styles/constants.dart';

class KeyboardValueDisplay extends StatefulWidget {
  final String fiatAmount;
  final String quantity;
  final VoidCallback onShake;

  const KeyboardValueDisplay({
    super.key,
    required this.fiatAmount,
    required this.quantity,
    required this.onShake,
  });

  @override
  KeyboardValueDisplayState createState() => KeyboardValueDisplayState();
}

class KeyboardValueDisplayState extends State<KeyboardValueDisplay>
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

  //displays a short shaking animation to warn a user against an illegal keyboard input
  void shake() {
    _animationController.forward(from: 0);
    HapticFeedback.mediumImpact();
  }

  //formats a provided amount with commas if necessary
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
        print("refined formatting");
        int decimalIndex = fiatAmount.indexOf('.');
        print("decimal index: $decimalIndex");
        int decimals = fiatAmount.length - decimalIndex - 1;
        print("decimals: $decimals");
        if (decimals == 2) {
          formattedAmount += "0";
        }
      }
      print("formattedAmount: $formattedAmount");
      return formattedAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget fiat amount: ${widget.fiatAmount}");
    print("Formatted fiat amount: ${formatFiatAmount(widget.fiatAmount)}");
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
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: Container(
        width: 300,
        height: 221,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 45),
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
              child: Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        //conditionally decrease the font size if the text field grows beyond a certain length
                        text: "\$",
                        style: widget.fiatAmount.length > 6
                            ? AppTextStyles.heading2
                            : widget.fiatAmount.length > 4
                                ? AppTextStyles.heading1.copyWith(fontSize: 55)
                                : AppTextStyles.heading1
                                    .copyWith(fontSize: 80)),
                    TextSpan(
                        text: formatFiatAmount(widget.fiatAmount),
                        style: widget.fiatAmount.length > 6
                            ? AppTextStyles.heading2
                            : widget.fiatAmount.length > 4
                                ? AppTextStyles.heading1.copyWith(fontSize: 55)
                                : AppTextStyles.heading1
                                    .copyWith(fontSize: 80)),
                    if (showCents)
                      TextSpan(
                          text: decimalExtension,
                          style: widget.fiatAmount.length > 6
                              ? AppTextStyles.heading2
                                  .copyWith(color: AppColors.grey)
                              : widget.fiatAmount.length > 4
                                  ? AppTextStyles.heading1.copyWith(
                                      color: AppColors.grey, fontSize: 55)
                                  : AppTextStyles.heading1.copyWith(
                                      color: AppColors.grey, fontSize: 80)),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.quantity.toString(),
                    style: AppTextStyles.textLG
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(width: 6),
                Text(
                  ' BTC',
                  style: AppTextStyles.textLG
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
