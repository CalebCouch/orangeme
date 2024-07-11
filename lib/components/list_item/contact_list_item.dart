import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/profile_photo/profile_photo.dart';
import 'package:orange/components/custom/custom_text.dart';

class ContactListItem extends StatelessWidget {
  final String contactName;
  final String digitalID;
  final String profilePhoto;
  final VoidCallback? onTap;

  const ContactListItem({
    super.key,
    this.onTap,
    required this.contactName,
    required this.digitalID,
    this.profilePhoto = ThemeIcon.profile,
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
                size: ProfileSize.lg,
                profilePhoto: profilePhoto,
              ),
            ),
            const Spacing(width: AppPadding.bumper),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  text: contactName,
                  textSize: TextSize.md,
                ),
                CustomText(
                  text: digitalID,
                  textSize: TextSize.sm,
                  color: ThemeColor.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
