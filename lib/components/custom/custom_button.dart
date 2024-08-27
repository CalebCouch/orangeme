import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'package:orange/theme/stylesheet.dart';

import 'package:orange/flows/bitcoin/send/amount.dart';

import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_icon.dart';

import 'package:orange/util.dart';

// This Dart code defines a customizable Flutter button widget that adapts its
// style, size, and appearance based on different states, and includes helper
// functions for creating buttons with specific icons for actions like sending,
// navigating, and exiting.

class ButtonVariant {
  static const String primary = "primary";
  static const String secondary = "secondary";
  static const String ghost = "ghost";
}

class ButtonStatus {
  static const int _default = 0;
  static const int _hover = 1;
  static const int _disabled = 2;
  static const int _selected = 3;
}

class ButtonColor {
  final Color fill;
  final Color text;

  const ButtonColor(this.fill, this.text);
}

Map buttonColors = {
  ButtonVariant.primary: {
    ButtonStatus._default:
        const ButtonColor(ThemeColor.primary, ThemeColor.colorHandle),
    ButtonStatus._hover:
        const ButtonColor(ThemeColor.primary, ThemeColor.colorHandle),
    ButtonStatus._disabled:
        const ButtonColor(ThemeColor.textSecondary, ThemeColor.handle),
    ButtonStatus._selected:
        const ButtonColor(ThemeColor.primary, ThemeColor.colorHandle),
  },
  ButtonVariant.secondary: {
    ButtonStatus._default:
        const ButtonColor(ThemeColor.bg, ThemeColor.colorHandle),
    ButtonStatus._hover:
        const ButtonColor(ThemeColor.bgSecondary, ThemeColor.colorHandle),
    ButtonStatus._disabled:
        const ButtonColor(ThemeColor.bg, ThemeColor.textSecondary),
    ButtonStatus._selected:
        const ButtonColor(ThemeColor.bgSecondary, ThemeColor.colorHandle),
  },
  ButtonVariant.ghost: {
    ButtonStatus._default:
        const ButtonColor(ThemeColor.bg, ThemeColor.colorHandle),
    ButtonStatus._hover:
        const ButtonColor(ThemeColor.bgSecondary, ThemeColor.colorHandle),
    ButtonStatus._disabled:
        const ButtonColor(ThemeColor.bg, ThemeColor.textSecondary),
    ButtonStatus._selected:
        const ButtonColor(ThemeColor.bgSecondary, ThemeColor.colorHandle),
  },
};

// This class creates a custom button //
class CustomButton extends StatefulWidget {
  final String text;
  final String variant;

  final double buttonSize;
  final int status;
  final bool expand;
  final Alignment buttonAlignment;

  final String? icon;
  final String? pfp;
  final VoidCallback? onTap;
  final ShakeController? shakeController;

  const CustomButton({
    super.key,
    required this.text,
    this.variant = ButtonVariant.primary,
    this.buttonSize = ButtonSize.lg,
    this.status = ButtonStatus._default,
    this.expand = true,
    this.buttonAlignment = Alignment.center,
    this.icon,
    this.pfp,
    this.onTap,
    this.shakeController,
  });

  @override
  State<CustomButton> createState() => _ButtonState();
}

class _ButtonState extends State<CustomButton> {
  // Get the button padding for different sizes //
  _getButtonPadding(buttonSize) {
    if (buttonSize == ButtonSize.lg) {
      return AppPadding.button[0].toDouble();
    } else if (buttonSize == ButtonSize.md) {
      return AppPadding.button[1].toDouble();
    }
  }

  // Get the button spacing for different sizes //
  _getButtonSpacing(buttonSize) {
    if (buttonSize == ButtonSize.lg) {
      return AppPadding.buttonSpacing[0].toDouble();
    } else if (buttonSize == ButtonSize.md) {
      return AppPadding.buttonSpacing[1].toDouble();
    }
  }

  // If an icon has been supplied, display it //
  _displayIcon() {
    if (widget.icon != null) {
      return Row(
        children: [
          CustomIcon(
            icon: widget.icon!,
            iconSize: widget.buttonSize == 48 ? 32 : 20,
          ),
          Spacing(
            width: _getButtonSpacing(widget.buttonSize),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  // If a profile picture has been supplied, display it //
  _displayPfp() {
    return Row(
      children: [
        profilePhoto(context, widget.pfp, ProfileSize.sm),
        Spacing(
          width: _getButtonSpacing(widget.buttonSize),
        )
      ],
    );
  }

  // On button tap while disabled
  disabled() {
    if (widget.shakeController != null) {
      widget.shakeController!.shake();
      Vibrate.feedback(FeedbackType.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.status == ButtonStatus._default
          ? () {
              HapticFeedback.heavyImpact();
              if (widget.onTap != null) widget.onTap!();
            }
          : () {
              disabled();
            },
      child: Container(
        alignment: widget.expand ? widget.buttonAlignment : null,
        width: widget.expand ? double.infinity : null,
        decoration: ShapeDecoration(
          color: buttonColors[widget.variant][widget.status].fill,
          shape: widget.variant == ButtonVariant.secondary
              ? BoxDecorations.buttonOutlined
              : BoxDecorations.button,
        ),
        height: widget.buttonSize,
        padding: EdgeInsets.symmetric(
            horizontal: _getButtonPadding(widget.buttonSize)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon != null ? _displayIcon() : Container(),
            widget.pfp != null ? _displayPfp() : Container(),
            CustomText(
              textSize: widget.buttonSize == 48 ? TextSize.lg : TextSize.md,
              textType: "label",
              text: widget.text,
              color: buttonColors[widget.variant][widget.status].text,
            ),
          ],
        ),
      ),
    );
  }
}

// Icon with an onTap functionality //
Widget iconButton(BuildContext context, onTap, Widget icon,
    [bool widenLeft = false, bool widenRight = false]) {
  return InkWell(
    onTap: () {
      HapticFeedback.heavyImpact();
      if (onTap != null) onTap!();
    },
    child: Container(
      width: widenLeft || widenRight ? 50 : null,
      alignment: widenLeft
          ? Alignment.centerRight
          : widenRight
              ? Alignment.centerLeft
              : null,
      child: icon,
    ),
  );
}

Widget sendButton(BuildContext context, bool isEnabled) {
  return iconButton(
    context,
    () {
      print("send");
    },
    Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CustomIcon(
        iconSize: IconSize.md,
        icon: ThemeIcon.send,
        iconColor: isEnabled ? ThemeColor.secondary : ThemeColor.textSecondary,
      ),
    ),
  );
}

Widget backButton(BuildContext context) {
  return iconButton(
    context,
    () {
      navPop(context);
    },
    const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.left),
  );
}

Widget exitButton(BuildContext context, Widget home) {
  return iconButton(
    context,
    () {
      resetNavTo(context, home);
    },
    const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.close),
  );
}

Widget infoButton(BuildContext context, Widget page) {
  return iconButton(
    context,
    () {
      navigateTo(context, page);
    },
    const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.info),
  );
}

Widget numberButton(BuildContext context, String number) {
  return CustomText(
    text: number,
    textType: 'label',
    color: ThemeColor.secondary,
  );
}

Widget deleteButton(BuildContext context) {
  return const CustomIcon(
    icon: ThemeIcon.back,
    iconSize: IconSize.md,
    iconColor: ThemeColor.secondary,
  );
}
