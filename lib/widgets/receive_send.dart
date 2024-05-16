import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class ReceiveSend extends StatelessWidget {
  final Widget Function() receiveRoute;
  final Widget Function() sendRoute;

  const ReceiveSend({
    super.key,
    required this.receiveRoute,
    required this.sendRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 393,
      height: 80,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => receiveRoute())),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'Receive',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelLG,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => sendRoute())),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'Send',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelLG,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
