import 'package:flutter/material.dart';
import 'package:orange/flows/messages/profile/user_profile.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/classes/test_classes.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

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
    BuildContext context, Conversation convo, VoidCallback onTap,
    [Info? info]) {
  bool isGroup = false, isRoom = false;
  String roomName = '';
  if (convo.members.length > 1) isGroup = true;
  if (info != null) {
    isRoom = true;
    if (info.name == null) {
      roomName = "${info.creator.name}'s Room";
    } else {
      roomName = info.name!;
    }
  }
  return ImageListItem(
    onTap: onTap,
    left: Container(
      alignment: Alignment.centerLeft,
      child: ProfilePhoto(
        size: ProfileSize.lg,
        isGroup: isGroup,
        profilePhoto: isGroup && info == null ? null : convo.members[0].pfp,
      ),
    ),
    topRight: CustomText(
      text: isGroup && !isRoom
          ? 'Group message'
          : isRoom
              ? roomName
              : convo.members[0].name,
      textSize: TextSize.md,
    ),
    bottomRight: convo.messages != null
        ? CustomText(
            trim: true,
            alignment: TextAlign.left,
            text: convo.messages!.last.message,
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

Widget slackMessageItem(
    GlobalState globalState, BuildContext context, Message message) {
  return InkWell(
    onTap: () {
      navigateTo(
        context,
        UserProfile(globalState, userInfo: message.sender),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.listItem),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfilePhoto(size: ProfileSize.md, profilePhoto: message.sender.pfp),
          const Spacing(width: AppPadding.listItem),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: message.sender.name,
                      textSize: TextSize.md,
                    ),
                    const Spacing(width: 8),
                    CustomText(
                      text: message.time,
                      textSize: TextSize.sm,
                      color: ThemeColor.textSecondary,
                    ),
                  ],
                ),
                const Spacing(height: 6),
                CustomText(
                  text: message.message,
                  textSize: TextSize.md,
                  alignment: TextAlign.left,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget slackMessageGroup(
    GlobalState globalState, BuildContext context, List<Message> messages) {
  return SizedBox(
    height: double.infinity,
    child: ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        return slackMessageItem(globalState, context, messages[index]);
      },
    ),
  );
}
