import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';

class CustomIconButton extends StatelessWidget {
  final String icon;
  final double iconSize;
  final Color iconColor;
  final bool isEnabled;

  final VoidCallback? onTap;

  const CustomIconButton({
    super.key,
    this.onTap,
    this.isEnabled = true,
    required this.icon,
    this.iconSize = IconSize.md,
    this.iconColor = ThemeColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: null,
      child: CustomIcon(
        icon: icon,
        iconSize: iconSize,
        iconColor: isEnabled ? iconColor : ThemeColor.textSecondary,
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomBackButton({
    super.key,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return const CustomIconButton(
      icon: ThemeIcon.left,
      onTap: null,
    );
  }
}

class CustomSendButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isEnabled;

  const CustomSendButton({
    super.key,
    this.onTap,
    this.isEnabled = true,
  });
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: ThemeIcon.send,
      onTap: null,
      iconColor: isEnabled ? ThemeColor.primary : ThemeColor.textSecondary,
    );
  }
}
