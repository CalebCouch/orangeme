import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/profile_photo/profile_photo.dart';

import 'package:orange/components/headers/header.dart';

class MessagesHeader extends StatelessWidget {
  final String profilePhoto;
  final VoidCallback? onTap;

  const MessagesHeader({
    super.key,
    this.profilePhoto = ThemeIcon.profile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}
