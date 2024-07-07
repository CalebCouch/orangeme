import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/components/headers/header.dart';

class MessagesHeader extends StatelessWidget {
  final String profilePhoto;

  const MessagesHeader({
    super.key,
    required this.profilePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      left: Container(
        alignment: Alignment.center,
        height: 32,
        width: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(profilePhoto),
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
