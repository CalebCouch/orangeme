import 'package:flutter/material.dart';
import 'package:orange/components/buttons/icon_button.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/profile_photo/profile_photo.dart';
import 'package:orange/components/profile_photo/profile_photo_stack.dart';
import 'package:orange/components/contact_info/contact_info.dart';

import 'package:orange/components/headers/header.dart';

class StackMessageHeader extends StatelessWidget {
  final List<Contact> contacts;
  final VoidCallback? rightOnTap;

  const StackMessageHeader({
    super.key,
    required this.contacts,
    this.rightOnTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isGroup = false;
    if (contacts.length > 1) isGroup = true;
    return DefaultHeader(
      left: const CustomBackButton(),
      center: Column(
        children: [
          isGroup
              ? ProfilePhoto(
                  profilePhoto: contacts[0].photo,
                )
              : ProfilePhotoStack(contacts: contacts),
          const Spacing(height: 8),
          CustomText(
            textType: "heading",
            text: isGroup ? 'Group message' : contacts[0].name,
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
