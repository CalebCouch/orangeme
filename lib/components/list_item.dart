import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/classes/message_info.dart';
import 'package:orange/classes/contact_info.dart';

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
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: (left != null) ? left! : Container(),
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

Widget messageListItem(BuildContext context, Message message, onTap) {
  bool isGroup = false;
  if (message.contacts.length > 1) isGroup = true;
  return ImageListItem(
    left: Container(
      alignment: Alignment.centerLeft,
      child: ProfilePhoto(
        size: ProfileSize.lg,
        isGroup: isGroup,
        profilePhoto: message.contacts[0].photo,
      ),
    ),
    topRight: CustomText(
      text: isGroup ? 'Group message' : message.contacts[0].name,
      textSize: TextSize.md,
    ),
    bottomRight: Row(
      children: [
        message.isReceived
            ? CustomText(
                alignment: TextAlign.left,
                text: '${message.contacts[0].name}: ${String.fromCharCodes([
                      0x0020
                    ])}',
                textSize: TextSize.sm,
                color: ThemeColor.textSecondary,
              )
            : Container(),
        CustomText(
          alignment: TextAlign.left,
          text: message.text,
          textSize: TextSize.sm,
          color: ThemeColor.textSecondary,
        ),
      ],
    ),
  );
}

Widget contactListItem(BuildContext context, Contact contact, onTap) {
  return ImageListItem(
    onTap: onTap,
    left: Container(
      alignment: Alignment.centerLeft,
      child: ProfilePhoto(
        size: ProfileSize.lg,
        profilePhoto: contact.photo,
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
