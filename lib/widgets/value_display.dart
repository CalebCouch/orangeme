import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:intl/intl.dart';

class ValueDisplay extends StatelessWidget {
  final String fiatAmount;
  final String quantity;

  const ValueDisplay({
    super.key,
    required this.fiatAmount,
    required this.quantity,
  });

  String formatFiatAmount(String fiatAmount) {
    double? number = double.tryParse(fiatAmount);
    if (number == null) {
      return "0.00";
    } else {
      String absFiatAmount = number.abs().toStringAsFixed(2);
      if (absFiatAmount.length > 4) {
        NumberFormat format = NumberFormat("#,##0.00", "en_US");
        String formatted = format.format(number);
        return formatted;
      } else {
        return absFiatAmount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Dashboard Value Builder...");
    print("fiat Amount: $fiatAmount");
    print("quantity: $quantity");
    bool negativeValue = false;
    double? fiatAmountNull = double.tryParse(fiatAmount);
    if (fiatAmountNull != null && double.parse(fiatAmount) < 0) {
      negativeValue = true;
    }
    bool bigNumber = false;
    if (fiatAmountNull != null &&
        (double.parse(fiatAmount).abs().toString().length >= 7 ||
            (double.parse(fiatAmount).abs().toString().length >= 7 &&
                negativeValue == true))) {
      print("BIG NUMBER FOUND");
      bigNumber = true;
    }
    return Container(
      width: 288,
      height: 221,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: negativeValue ? "-\$" : "\$",
                    style: !bigNumber
                        ? AppTextStyles.heading1
                        : AppTextStyles.heading2),
                TextSpan(
                    text: formatFiatAmount(fiatAmount),
                    style: !bigNumber
                        ? AppTextStyles.heading1
                        : AppTextStyles.heading2),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(quantity.toString(), style: AppTextStyles.textLG),
              const SizedBox(width: 6),
              const Text(
                ' BTC',
                style: AppTextStyles.textLG,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
