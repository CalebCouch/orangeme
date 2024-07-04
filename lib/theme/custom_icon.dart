import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcon extends StatelessWidget {
  final String icon;
  final double iconSize;
  final Color iconColor;

  const CustomIcon({
    super.key,
    required this.icon,
    this.iconSize = IconSize.lg,
    this.iconColor = ThemeColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: iconSize,
      height: iconSize,
    );
  }
}
