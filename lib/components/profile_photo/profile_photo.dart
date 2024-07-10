import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';

class ProfilePhoto extends StatelessWidget {
  final String profilePhoto;
  final double height;
  final double width;
  final bool isGroup;

  const ProfilePhoto({
    super.key,
    required this.profilePhoto,
    this.height = 32,
    this.width = 32,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color:
            (profilePhoto == ThemeIcon.profile) ? ThemeColor.bgSecondary : null,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        isGroup ? ThemeIcon.group : profilePhoto,
        colorFilter:
            const ColorFilter.mode(ThemeColor.textSecondary, BlendMode.srcIn),
      ),
    );
  }
}
