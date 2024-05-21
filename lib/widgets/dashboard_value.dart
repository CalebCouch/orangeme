import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class DashboardValue extends StatelessWidget {
  final String fiatAmount;
  final String quantity;

  const DashboardValue({
    super.key,
    required this.fiatAmount,
    required this.quantity,
  });

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
                    text: negativeValue ? "- \$" : "\$",
                    style: AppTextStyles.heading1),
                TextSpan(
                    text: negativeValue
                        ? double.parse(fiatAmount).abs().toString()
                        : fiatAmount,
                    style: AppTextStyles.heading1),
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
