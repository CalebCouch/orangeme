import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/classes.dart';

// Handles profile photo display with customizable sizes, borders, fallback
// icons, a stacked view for multiple profiles, and an option to edit the profile picture.

/* Returns icon size based on profile size. */
_getIconSize(double profileSize) {
  switch (profileSize) {
    case 96:
      return IconSizeProfile.xxl;
    case 64:
      return IconSizeProfile.xl;
    case 48:
      return IconSizeProfile.lg;
    case 32:
      return IconSizeProfile.md;
    case 24:
      return IconSizeProfile.sm;
  }
}

/* Displays a profile photo with optional border, size, and fallback icon. */
Widget profilePhoto(
  BuildContext context, [
  String? pfp,
  double size = ProfileSize.md,
  bool outline = false,
  bool isGroup = false,
]) {
  return Container(
    alignment: Alignment.center,
    height: size,
    width: size,
    decoration: BoxDecoration(
      border: outline ? Border.all(color: ThemeColor.bg) : null,
      color: ThemeColor.bgSecondary,
      shape: BoxShape.circle,
      image: pfp != null
          ? DecorationImage(
              image: AssetImage(pfp),
              fit: BoxFit.cover,
            )
          : null,
    ),
    child: pfp == null
        ? SvgPicture.asset(
            height: _getIconSize(size),
            width: _getIconSize(size),
            isGroup ? ThemeIcon.group : ThemeIcon.profile,
            colorFilter: const ColorFilter.mode(
                ThemeColor.textSecondary, BlendMode.srcIn),
          )
        : Container(),
  );
}

/* Shows a horizontal list of profile photos for up to five contacts. */
Widget profilePhotoStack(BuildContext context, List<Contact> contacts) {
  return Container(
    width: 128,
    height: 32,
    alignment: Alignment.center,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: contacts.length < 5 ? contacts.length : 5,
      itemBuilder: (BuildContext context, int index) {
        return Align(
          widthFactor: 0.75,
          child: profilePhoto(
              context, contacts[index].pfp, ProfileSize.md, true, false),
        );
      },
    ),
  );
}

/* Provides a profile photo with an edit button for updating the photo. */
Widget editPhoto(BuildContext context, onTap, [pfp]) {
  return Column(
    children: [
      profilePhoto(context, pfp, ProfileSize.xxl),
      const Spacing(height: AppPadding.header),
      ButtonTip('Photo', ThemeIcon.edit, onTap)
    ],
  );
}
