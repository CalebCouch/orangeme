import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class MessageItem extends StatelessWidget {
  final String name;
  final String imagePath;
  final String did;
  final VoidCallback onTap;
  const MessageItem({
    super.key,
    required this.name,
    required this.onTap,
    required this.did,
    this.imagePath = AppImages.defaultProfileLG,
  });

  String truncateDID(did) {
    if (did.length > 30) {
      final firstPart = did.substring(0, 13);
      final secondPart = did.substring(did.length - 9);
      return '$firstPart...$secondPart';
    }
    return did;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 24,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.textMD),
                const SizedBox(height: 5),
                Text(truncateDID(did),
                    style: AppTextStyles.textSM
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
