import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:orange/flows/messages/conversation/info.dart';
import 'package:orange/flows/messages/profile/user_profile.dart';

class DefaultHeader extends StatelessWidget {
  final Widget? left;
  final Widget center;
  final Widget? right;
  final double height;

  const DefaultHeader({
    super.key,
    this.left,
    required this.center,
    this.right,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            child: left,
          ),
          Container(
            alignment: Alignment.center,
            child: center,
          ),
          Container(
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: right,
          ),
        ],
      ),
    );
  }
}

Widget primaryHeader(BuildContext context, String text) {
  return DefaultHeader(
    center: CustomText(
      textType: "heading",
      text: text,
      textSize: TextSize.h3,
      color: ThemeColor.heading,
    ),
  );
}

Widget messagesHeader(BuildContext context, onTap, pfp) {
  return DefaultHeader(
    left: GestureDetector(
      onTap: onTap ?? () {},
      child: profilePhoto(context, pfp),
    ),
    center: const CustomText(
      textType: "heading",
      text: 'Messages',
      textSize: TextSize.h3,
      color: ThemeColor.heading,
    ),
  );
}

Widget stackButtonHeader(
    BuildContext context, String text, bool rightEnabled, rightText, rightOnTap,
    [iconButton]) {
  return DefaultHeader(
    left: iconButton == null ? backButton(context) : iconButton!,
    center: CustomText(
      textType: "heading",
      text: text,
      textSize: TextSize.h4,
      color: ThemeColor.heading,
    ),
    right: rightEnabled
        ? CustomButton(
            onTap: rightOnTap ?? () {},
            expand: false,
            text: rightText,
            variant: ButtonVariant.ghost,
            buttonSize: ButtonSize.md,
          )
        : null,
  );
}

Widget stackHeader(BuildContext context, String text,
    [bool delay = false, iconButton]) {
  return DefaultHeader(
    left: iconButton == null ? backButton(context, delay) : iconButton!,
    center: CustomText(
      textType: "heading",
      text: text,
      textSize: TextSize.h4,
      color: ThemeColor.heading,
    ),
  );
}

Widget stackMessageHeader(
    GlobalState globalState, BuildContext context, Conversation cnvo) {
  bool isGroup = false;
  if (cnvo.members.length > 1) isGroup = true;
  return DefaultHeader(
    height: 76,
    left: backButton(context),
    center: InkWell(
      onTap: () {
        if (!isGroup) {
          navigateTo(
              context, UserProfile(globalState, userInfo: cnvo.members[0]));
        }
      },
      child: Column(
        children: [
          isGroup
              ? profilePhotoStack(context, cnvo.members)
              : profilePhoto(context, cnvo.members[0].pfp),
          const Spacing(height: 8),
          CustomText(
            textType: "heading",
            text: isGroup ? 'Group message' : cnvo.members[0].name,
            textSize: TextSize.h5,
            color: ThemeColor.heading,
          ),
        ],
      ),
    ),
    right: isGroup
        ? infoButton(
            context,
            MessageInfo(globalState, contacts: cnvo.members),
          )
        : null,
  );
}
