import 'package:flutter/material.dart';
import 'package:orange/components/buttons/tip_buttons.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/profile_photo/profile_photo.dart';

import 'dart:io';

class ProfilePhotoEdit extends StatelessWidget {
  final File? profilePhoto;
  final VoidCallback? onTap;

  const ProfilePhotoEdit({
    super.key,
    required this.profilePhoto,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfilePhoto(profilePhoto: profilePhoto, size: ProfileSize.xxl),
        const Spacing(height: AppPadding.header),
        tipButton(ButtonTip('Photo', ThemeIcon.edit, onTap))
      ],
    );
  }
}
