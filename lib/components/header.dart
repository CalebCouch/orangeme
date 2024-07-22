import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/classes/contact_info.dart';

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

Widget messagesHeader(BuildContext context, onTap, profilePhoto) {
  return DefaultHeader(
    left: GestureDetector(
      onTap: onTap ?? () {},
      child: ProfilePhoto(
        size: ProfileSize.md,
        profilePhoto: profilePhoto,
      ),
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

Widget stackHeader(BuildContext context, String text, [bool delay = false, iconButton]) {
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

Widget stackMessageHeader(BuildContext context, List<Contact> contacts) {
  bool isGroup = false;
  if (contacts.length > 1) isGroup = true;
  return DefaultHeader(
    height: 76,
    left: backButton(context),
    center: Column(
      children: [
        !isGroup
            ? ProfilePhoto(
                profilePhoto: contacts[0].photo,
              )
            : profilePhotoStack(context, contacts),
        const Spacing(height: 8),
        CustomText(
          textType: "heading",
          text: isGroup ? 'Group message' : contacts[0].name,
          textSize: TextSize.h5,
          color: ThemeColor.heading,
        ),
      ],
    ),
    right: isGroup ? infoButton(context, contacts) : null,
  );
}
