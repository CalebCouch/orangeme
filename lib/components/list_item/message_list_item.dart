import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/profile_photo/profile_photo.dart';
import 'package:orange/classes/message_info.dart';
import 'package:orange/components/custom/custom_text.dart';

class MessageListItem extends StatelessWidget {
  final Message message;
  final VoidCallback? onTap;

  const MessageListItem({
    super.key,
    this.onTap,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    bool isGroup = false;
    if (message.contacts.length > 1) isGroup = true;
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
                profilePhoto:
                    isGroup ? ThemeIcon.group : message.contacts[0].photo,
              ),
            ),
            const Spacing(width: AppPadding.bumper),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  text: isGroup ? 'Group message' : message.contacts[0].name,
                  textSize: TextSize.md,
                ),
                Row(
                  children: [
                    message.isReceived
                        ? CustomText(
                            alignment: TextAlign.left,
                            text:
                                '${message.contacts[0].name}: ${String.fromCharCodes([
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
