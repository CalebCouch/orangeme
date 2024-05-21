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
    return Container(
      width: 288,
      height: 221,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            fiatAmount.toString(),
            style: AppTextStyles.heading1,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                quantity.toString(),
                style: AppTextStyles.textLG,
              ),
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
