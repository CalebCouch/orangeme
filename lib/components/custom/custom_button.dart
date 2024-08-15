import 'package:flutter/material.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/flows/bitcoin/send/amount.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_icon.dart';

import 'package:orange/flows/bitcoin/new_wallet/spending/new_wallet.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

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

class CustomButton extends StatefulWidget {
  final String variant;
  final int status;
  final double buttonSize;
  final String text;

  final String? icon;
  final String? pfp;
  final VoidCallback? onTap;
  final bool expand;
  final Alignment buttonAlignment;
  final ShakeController? shakeController;

  const CustomButton({
    super.key,
    required this.text,
    this.variant = ButtonVariant.primary,
    this.buttonSize = ButtonSize.lg,
    this.expand = true,
    this.status = ButtonStatus._default,
    this.icon,
    this.pfp,
    this.onTap,
    this.buttonAlignment = Alignment.center,
    this.shakeController,
  });

  @override
  State<CustomButton> createState() => _ButtonState();
}

class _ButtonState extends State<CustomButton> {
  _getButtonPadding(buttonSize) {
    if (buttonSize == ButtonSize.lg) {
      return AppPadding.button[0].toDouble();
    } else if (buttonSize == ButtonSize.md) {
      return AppPadding.button[1].toDouble();
    }
  }

  _getButtonSpacing(buttonSize) {
    if (buttonSize == ButtonSize.lg) {
      return AppPadding.buttonSpacing[0].toDouble();
    } else if (buttonSize == ButtonSize.md) {
      return AppPadding.buttonSpacing[1].toDouble();
    }
  }

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

  disabled() {
    if (widget.shakeController != null) widget.shakeController!.shake();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.status == ButtonStatus._default
          ? widget.onTap
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

Widget iconButton(BuildContext context, onTap, CustomIcon icon,
    [bool widenLeft = false, bool widenRight = false]) {
  return InkWell(
    onTap: onTap ?? () {},
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
    CustomIcon(
      iconSize: IconSize.md,
      icon: ThemeIcon.send,
      iconColor: isEnabled ? ThemeColor.secondary : ThemeColor.textSecondary,
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
    false,
    true,
  );
}

Widget exitButton(BuildContext context, Widget home) {
  return iconButton(
    context,
    () {
      resetNavTo(context, home);
    },
    const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.close),
    false,
    true,
  );
}

Widget infoButton(BuildContext context, Widget page) {
  return iconButton(
    context,
    () {
      navigateTo(context, page);
    },
    const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.info),
    true,
    false,
  );
}

Widget newWalletButton(BuildContext context, GlobalState globalState) {
  return iconButton(
    context,
    () {
      navigateTo(context, NewWallet(globalState));
    },
    const CustomIcon(iconSize: IconSize.md, icon: ThemeIcon.add),
    true,
    false,
  );
}
