import 'package:flutter/material.dart';
import 'package:orange/components/buttons/icon_button.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/buttons/icon_button.dart';
import 'package:orange/components/profile_photo/profile_photo.dart';

import 'package:orange/components/headers/header.dart';

class StackMessageHeader extends StatelessWidget {
  final String name;
  final Widget? iconButton;
  final VoidCallback? rightOnTap;
  final String profilePhoto;
  final bool isGroup;

  const StackMessageHeader({
    super.key,
    required this.name,
    this.profilePhoto = ThemeIcon.profile,
    this.iconButton,
    this.rightOnTap,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      left: iconButton == null ? const CustomBackButton() : iconButton!,
      center: Column(
        children: [
          ProfilePhoto(
            profilePhoto: profilePhoto,
          ),
          const Spacing(height: 8),
          CustomText(
            textType: "heading",
            text: isGroup ? 'Group message' : name,
            textSize: TextSize.h5,
            color: ThemeColor.heading,
          ),
        ],
      ),
      right: isGroup
          ? CustomInfoButton(
              onTap: rightOnTap ?? () {},
            )
          : null,
    );
  }
}
