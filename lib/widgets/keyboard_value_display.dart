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

  void shake() {
    _animationController.forward(from: 0);
    HapticFeedback.mediumImpact();
  }

  String formatFiatAmount(String fiatAmount) {
    if (fiatAmount.endsWith(".") ||
        fiatAmount.endsWith(".0") ||
        fiatAmount.endsWith(".00")) {
      // If the amount ends with a decimal point or zeroes, return as is.
      return fiatAmount;
    }
    double? number = double.tryParse(fiatAmount);
    if (number == null) {
      return "0"; // Default to 0 if parsing fails
    } else {
      NumberFormat format = NumberFormat("#,###.##", "en_US");
      return format.format(number);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget fiat amount: ${widget.fiatAmount}");
    print("Formatted fiat amount: ${formatFiatAmount(widget.fiatAmount)}");
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: Container(
        width: 288,
        height: 221,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
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
                        text: "\$",
                        style: widget.fiatAmount.length >= 7
                            ? AppTextStyles.heading2
                            : AppTextStyles.heading1),
                    TextSpan(
                        text: formatFiatAmount(widget.fiatAmount),
                        style: widget.fiatAmount.length >= 7
                            ? AppTextStyles.heading2
                            : AppTextStyles.heading1),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.quantity.toString(), style: AppTextStyles.textLG),
                const SizedBox(width: 6),
                const Text(
                  ' BTC',
                  style: AppTextStyles.textLG,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
