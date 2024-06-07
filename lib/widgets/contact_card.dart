import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;

  const ContactCard({
    super.key,
    required this.name,
    required this.onTap,
    this.imagePath = AppImages.defaultProfileLG,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(name, style: AppTextStyles.textMD),
            ),
          ],
        ),
      ),
    );
  }
}
