import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes/contact_info.dart';
import 'package:orange/components/tip_buttons.dart';
import 'dart:io';

class ProfilePhoto extends StatelessWidget {
  final File? profilePhoto;
  final double size;
  final bool outline;
  final bool isGroup;

  const ProfilePhoto({
    super.key,
    this.profilePhoto,
    this.size = ProfileSize.md,
    this.outline = false,
    this.isGroup = false,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: outline ? Border.all(color: ThemeColor.bg) : null,
        color: ThemeColor.bgSecondary,
        shape: BoxShape.circle,
        image: profilePhoto != null
            ? DecorationImage(
                image: FileImage(profilePhoto!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: profilePhoto == null
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
          child: ProfilePhoto(outline: true, profilePhoto: contacts[0].photo),
        );
      },
    ),
  );
}

Widget editPhoto(BuildContext context, onTap, [profilePhoto]) {
  return Column(
    children: [
      ProfilePhoto(profilePhoto: profilePhoto, size: ProfileSize.xxl),
      const Spacing(height: AppPadding.header),
      tipButton(ButtonTip('Photo', ThemeIcon.edit, onTap))
    ],
  );
}
