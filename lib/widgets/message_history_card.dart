import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class MessageHistoryCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;
  final String lastMessage;
  final bool group;

  const MessageHistoryCard({
    super.key,
    required this.name,
    required this.onTap,
    required this.lastMessage,
    required this.group,
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
              radius: 24,
              backgroundImage: group ? null : AssetImage(imagePath),
              backgroundColor:
                  group ? AppColors.backgroundSecondary : Colors.transparent,
              child: group
                  ? const Icon(Icons.group, color: AppColors.textSecondary)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.textMD
                        .copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: AppTextStyles.textSM
                        .copyWith(color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
