import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/profile_photo/profile_photo.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/classes/contact_info.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const ContactListItem({
    super.key,
    this.onTap,
    required this.contact,
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
                profilePhoto: contact.photo,
              ),
            ),
            const Spacing(width: AppPadding.bumper),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  text: contact.name,
                  textSize: TextSize.md,
                ),
                CustomText(
                  text: contact.did,
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
