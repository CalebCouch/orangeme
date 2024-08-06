import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/classes/test_classes.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: (left != null) ? left! : Container(),
            ),
            const Spacing(width: AppPadding.listItem),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

Widget messageListItem(BuildContext context, Conversation convo, onTap) {
  bool isGroup = false;
  if (convo.members.length > 1) isGroup = true;
  return ImageListItem(
    left: Container(
      alignment: Alignment.centerLeft,
      child: ProfilePhoto(
        size: ProfileSize.lg,
        isGroup: isGroup,
        profilePhoto: convo.members[0].pfp,
      ),
    ),
    topRight: CustomText(
      text: isGroup ? 'Group message' : convo.members[0].name,
      textSize: TextSize.md,
    ),
    bottomRight: convo.messages != null
        ? Row(
            children: [
              convo.messages!.last.isIncoming
                  ? CustomText(
                      alignment: TextAlign.left,
                      text: '${convo.members[0].name}: ${String.fromCharCodes([
                            0x0020
                          ])}',
                      textSize: TextSize.sm,
                      color: ThemeColor.textSecondary,
                    )
                  : Container(),
              CustomText(
                alignment: TextAlign.left,
                text: convo.messages!.last.message,
                textSize: TextSize.sm,
                color: ThemeColor.textSecondary,
              ),
            ],
          )
        : Container(),
  );
}

Widget contactListItem(BuildContext context, Contact contact, onTap) {
  return ImageListItem(
    onTap: onTap,
    left: Container(
      alignment: Alignment.centerLeft,
      child: ProfilePhoto(
        size: ProfileSize.lg,
        profilePhoto: contact.pfp,
      ),
    ),
    topRight: CustomText(
      text: contact.name,
      textSize: TextSize.md,
    ),
    bottomRight: CustomText(
      text: contact.did,
      textSize: TextSize.sm,
      color: ThemeColor.textSecondary,
    ),
  );
}
