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
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final String icon;
  final double iconSize;
  final Color iconColor;
  final bool enabled;

  final VoidCallback? onTap;

  const AppIconButton({
    super.key,
    this.onTap,
    this.enabled = true,
    required this.icon,
    this.iconSize = IconSize.lg,
    this.iconColor = ThemeColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: null,
      child: CustomIcon(
        icon: icon,
        iconSize: iconSize,
        iconColor: enabled ? iconColor : ThemeColor.textSecondary,
      ),
    );
  }
}
