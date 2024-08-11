import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/profile_photo.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class DefaultListItem extends StatelessWidget {
  final Widget? topLeft;
  final Widget? bottomLeft;
  final Widget? topRight;
  final Widget? bottomRight;
  final VoidCallback? onTap;

  const DefaultListItem({
    super.key,
    this.topLeft,
    this.bottomLeft,
    this.topRight,
    this.bottomRight,
    this.onTap,
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
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (topLeft != null) topLeft!,
                    if (bottomLeft != null) bottomLeft!,
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (topRight != null) topRight!,
                if (bottomRight != null) bottomRight!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageListItem extends StatelessWidget {
  final Widget? left;
  final Widget? topRight;
  final Widget? bottomRight;
  final VoidCallback? onTap;

  const ImageListItem({
    super.key,
    this.left,
    this.topRight,
    this.bottomRight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.listItem),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: (left != null) ? left! : Container(),
            ),
            const Spacing(width: AppPadding.listItem),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (topRight != null) topRight!,
                  if (bottomRight != null) bottomRight!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget messageListItem(
    BuildContext context, Conversation convo, VoidCallback onTap) {
  bool isGroup = false;
  if (convo.members.length > 1) isGroup = true;
  return ImageListItem(
    onTap: onTap,
    left: Container(
      alignment: Alignment.centerLeft,
      child: profilePhoto(
        context,
        isGroup ? null : convo.members[0].pfp,
        ProfileSize.lg,
        false,
        isGroup,
      ),
    ),
    topRight: CustomText(
      text: isGroup ? 'Group message' : convo.members[0].name,
      textSize: TextSize.md,
    ),
    bottomRight: convo.messages.isNotEmpty
        ? CustomText(
            trim: true,
            alignment: TextAlign.left,
            text: convo.messages.last.message,
            textSize: TextSize.sm,
            color: ThemeColor.textSecondary,
            maxLines: 2)
        : Container(),
  );
}

Widget contactListItem(BuildContext context, Contact contact, onTap) {
  return ImageListItem(
    onTap: onTap,
    left: Container(
      alignment: Alignment.centerLeft,
      child: profilePhoto(context, contact.pfp, ProfileSize.lg),
    ),
    topRight: CustomText(
      text: contact.name,
      textSize: TextSize.md,
    ),
    bottomRight: CustomText(
      text: middleCut(contact.did, 30),
      textSize: TextSize.sm,
      color: ThemeColor.textSecondary,
    ),
  );
}
