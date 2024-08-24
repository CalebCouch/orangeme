import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:orange/theme/stylesheet.dart';

// The CustomIcon class creates a widget to display SVG icons with customizable
// size and color using the flutter_svg package.

class CustomIcon extends StatelessWidget {
  final String icon;
  final double iconSize;
  final Color iconColor;

  const CustomIcon({
    super.key,
    required this.icon,
    this.iconSize = IconSize.lg,
    this.iconColor = ThemeColor.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: iconSize,
      height: iconSize,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );
  }
}
