import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';

class ProfilePhoto extends StatelessWidget {
  final String profilePhoto;
  final double size;

  const ProfilePhoto({
    super.key,
    required this.profilePhoto,
    this.size = ProfileSize.md,
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
      decoration: const BoxDecoration(
        color: ThemeColor.bgSecondary,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        height: _getIconSize(size),
        width: _getIconSize(size),
        profilePhoto,
        colorFilter:
            const ColorFilter.mode(ThemeColor.textSecondary, BlendMode.srcIn),
      ),
    );
  }
}
