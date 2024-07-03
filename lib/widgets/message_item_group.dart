import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageItemGroup extends StatelessWidget {
  final String name;
  final String? imagePath;
  final VoidCallback onTap;
  final String lastMessage;
  final bool group;

  const MessageItemGroup({
    super.key,
    required this.name,
    required this.onTap,
    required this.lastMessage,
    required this.group,
    this.imagePath,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            group
                ? CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.backgroundSecondary,
                    child: SvgPicture.asset(
                      AppIcons.group,
                      width: 36,
                      colorFilter: const ColorFilter.mode(
                          AppColors.textSecondary, BlendMode.srcIn),
                    ),
                  )
                : CircleAvatar(
                    radius: 24,
                    backgroundImage: imagePath == null
                        ? const AssetImage(AppImages.defaultProfileLG)
                        : AssetImage(imagePath!),
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.textMD,
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
