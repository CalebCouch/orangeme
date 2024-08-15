import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:orange/flows/messages/conversation/info.dart';
import 'package:orange/flows/messages/profile/user_profile.dart';
import 'dart:io' show Platform;

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

Widget homeDesktopHeader(BuildContext context, String text) {
  return DefaultHeader(
    center: CustomText(
      textType: "heading",
      text: text,
      textSize: TextSize.h3,
      color: ThemeColor.heading,
    ),
  );
}

Widget homeHeader(BuildContext context, onTap, text, pfp) {
  bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  if (onDesktop) return homeDesktopHeader(context, text);
  return DefaultHeader(
    left: InkWell(
      onTap: onTap ?? () {},
      child: Container(
        width: 50,
        alignment: Alignment.centerLeft,
        child: profilePhoto(context, pfp),
      ),
    ),
    center: CustomText(
      textType: "heading",
      text: text,
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
    center: !isGroup
        ? InkWell(
            onTap: () {
              navigateTo(
                context,
                UserProfile(globalState, userInfo: cnvo.members[0]),
              );
            },
            child: Column(
              children: [
                profilePhoto(context, cnvo.members[0].pfp),
                const Spacing(height: 8),
                CustomText(
                  textType: "heading",
                  text: cnvo.members[0].name,
                  textSize: TextSize.h5,
                  color: ThemeColor.heading,
                ),
              ],
            ),
          )
        : Column(
            children: [
              profilePhotoStack(context, cnvo.members),
              const Spacing(height: 8),
              const CustomText(
                textType: "heading",
                text: 'Group message',
                textSize: TextSize.h5,
                color: ThemeColor.heading,
              ),
            ],
          ),
    right: isGroup
        ? infoButton(
            context,
            MessageInfo(globalState, contacts: cnvo.members),
          )
        : null,
  );
}
