import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KeyboardValueDisplay extends StatefulWidget {
  final String fiatAmount;
  final String quantity;
  final VoidCallback onShake;
  final bool exceedMaxBalance;
  final String maxBalance;

  const KeyboardValueDisplay(
      {super.key,
      required this.fiatAmount,
      required this.quantity,
      required this.onShake,
      required this.exceedMaxBalance,
      required this.maxBalance});

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

    double fontSize = 70.0;
    if (widget.fiatAmount.length > 6) {
      print("Font size exceeds char length 6");
      fontSize = 55.0;
    }
    if (widget.fiatAmount.length > 10) {
      print("font size exceeds char length 10");
      fontSize = 40.0;
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
      child: Container(
        width: containerWidth,
        padding: const EdgeInsets.symmetric(vertical: 45),
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
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "\$",
                          style: AppTextStyles.heading1
                              .copyWith(fontSize: fontSize),
                        ),
                        TextSpan(
                          text: formatFiatAmount(widget.fiatAmount),
                          style: AppTextStyles.heading1
                              .copyWith(fontSize: fontSize),
                        ),
                        if (showCents)
                          TextSpan(
                            text: decimalExtension,
                            style: AppTextStyles.heading1.copyWith(
                                color: AppColors.grey, fontSize: fontSize),
                          ),
                      ],
                    ),
                    // Apply softWrap: false to prevent text from wrapping
                    softWrap: false,
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
                  Text(
                    widget.quantity.toString(),
                    style: AppTextStyles.textLG
                        .copyWith(color: AppColors.textSecondary),
                  ),
                const SizedBox(width: 6),
                if (!widget.exceedMaxBalance)
                  Text(
                    ' BTC',
                    style: AppTextStyles.textLG
                        .copyWith(color: AppColors.textSecondary),
                  ),
                if (widget.exceedMaxBalance)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppIcons.error,
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                            AppColors.danger, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: "\$${widget.maxBalance} maximum.",
                            style: AppTextStyles.textLG
                                .copyWith(color: AppColors.danger),
                          ),
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
