import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/util.dart';

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
    return GestureDetector(
      onTap: onTap ?? () {},
      child: CustomIcon(
        icon: icon,
        iconSize: iconSize,
        iconColor: isEnabled ? iconColor : ThemeColor.textSecondary,
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: ThemeIcon.left,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

class CustomExitButton extends StatelessWidget {
  final Widget home;
  const CustomExitButton({
    super.key,
    required this.home,
  });
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: ThemeIcon.close,
      onTap: () {
        navigateTo(context, home);
      },
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
      onTap: () {
        print("send");
      },
      iconColor: isEnabled ? ThemeColor.primary : ThemeColor.textSecondary,
    );
  }
}

class CustomInfoButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomInfoButton({
    super.key,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: ThemeIcon.info,
      onTap: onTap,
      iconColor: ThemeColor.primary,
    );
  }
}
