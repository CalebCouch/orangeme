import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/profile_photo.dart';

import 'package:orange/flows/messages/conversation/info.dart';
import 'package:orange/flows/messages/profile/user_profile.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

// This code provides several DefaultHeader variations for different app sections,
// including home, stack navigation, and message headers, with configurations for
// left, center, and right widgets, as well as handling desktop vs. mobile layouts
// and group vs. individual message views.

/* A flexible header widget with customizable left, center, and right content. */
class DefaultHeader extends StatelessWidget {
  final Widget? left;
  final Widget center;
  final Widget? right;

  const DefaultHeader({
    super.key,
    this.left,
    required this.center,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        alignment: Alignment.topCenter,
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

/* A desktop-specific header with centered text. */
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

/* A responsive header for home pages with profile photo and optional icon */
Widget homeHeader(BuildContext context, GlobalState globalState, text, pfp,
    [Widget? iconButton]) {
  bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  if (onDesktop) return homeDesktopHeader(context, text);
  return DefaultHeader(
    left: InkWell(
      onTap: () async {
        var address = (await globalState.invoke("get_new_address", "")).data;
        navigateTo(context, MyProfile(globalState, address));
      },
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
    right: iconButton,
  );
}

/* A header with optional icon button, centered text, and optional right button. */
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

/* A basic header with optional back button and centered text. */
Widget stackHeader(BuildContext context, String text, [iconButton]) {
  return DefaultHeader(
    left: iconButton == null ? backButton(context) : iconButton!,
    center: CustomText(
      textType: "heading",
      text: text,
      textSize: TextSize.h4,
      color: ThemeColor.heading,
    ),
  );
}

/* A message header that displays user or group info */
Widget stackMessageHeader(
    GlobalState globalState, BuildContext context, Conversation cnvo) {
  bool isGroup = false;
  if (cnvo.members.length > 1) isGroup = true;
  return DefaultHeader(
    left: backButton(context),
    center: !isGroup
        ? InkWell(
            onTap: () async {
              var address =
                  (await globalState.invoke("get_new_address", "")).data;
              switchPageTo(
                context,
                UserProfile(
                  globalState,
                  address,
                  userInfo: cnvo.members[0],
                ),
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
