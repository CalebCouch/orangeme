import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_button.dart';
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

profilePhotoPresets(String choice, double size) {
  switch (choice) {
    case 'group':
      return SvgPicture.asset(
        height: _getIconSize(size),
        width: _getIconSize(size),
        ThemeIcon.group,
        colorFilter:
            const ColorFilter.mode(ThemeColor.textSecondary, BlendMode.srcIn),
      );

    case 'profile':
      return SvgPicture.asset(
        height: _getIconSize(size),
        width: _getIconSize(size),
        ThemeIcon.profile,
        colorFilter:
            const ColorFilter.mode(ThemeColor.textSecondary, BlendMode.srcIn),
      );

    case 'wallet':
      return SvgPicture.asset(
        height: _getIconSize(size),
        width: _getIconSize(size),
        ThemeIcon.wallet,
        colorFilter:
            const ColorFilter.mode(ThemeColor.textSecondary, BlendMode.srcIn),
      );
  }
}

Widget profilePhoto(
  BuildContext context, [
  String? pfp,
  String? preset,
  double size = ProfileSize.md,
  bool outline = false,
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
        ? preset == null
            ? profilePhotoPresets('profile', size)
            : profilePhotoPresets(preset, size)
        : Container(),
  );
}

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
              context, contacts[index].pfp, null, ProfileSize.md, false),
        );
      },
    ),
  );
}

Widget editPhoto(BuildContext context, onTap, [pfp]) {
  return Column(
    children: [
      profilePhoto(context, pfp, null, ProfileSize.xxl),
      const Spacing(height: AppPadding.header),
      ButtonTip('Photo', ThemeIcon.edit, onTap)
    ],
  );
}
