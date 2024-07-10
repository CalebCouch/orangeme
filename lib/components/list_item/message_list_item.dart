import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/profile_photo/profile_photo.dart';
import 'package:orange/components/custom/custom_text.dart';

class MessageListItem extends StatelessWidget {
  final String profilePhoto;
  final String name;
  final String recentMessage;
  final VoidCallback? onTap;
  final bool isReceived;

  const MessageListItem({
    super.key,
    this.profilePhoto = ThemeIcon.profile,
    this.name = 'Alice B',
    this.recentMessage = 'No.',
    this.onTap,
    this.isReceived = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.listItem),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: ProfilePhoto(
                height: 48,
                width: 48,
                profilePhoto: profilePhoto,
              ),
            ),
            const Spacing(width: AppPadding.bumper),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  textSize: TextSize.md,
                ),
                Row(
                  children: [
                    isReceived
                        ? CustomText(
                            alignment: TextAlign.left,
                            text: '$name: ${String.fromCharCodes([0x0020])}',
                            textSize: TextSize.sm,
                            color: ThemeColor.textSecondary,
                          )
                        : CustomText(
                            alignment: TextAlign.left,
                            text: 'you: ${String.fromCharCodes([0x0020])}',
                            textSize: TextSize.sm,
                            color: ThemeColor.textSecondary,
                          ),
                    CustomText(
                      alignment: TextAlign.left,
                      text: recentMessage,
                      textSize: TextSize.sm,
                      color: ThemeColor.textSecondary,
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
