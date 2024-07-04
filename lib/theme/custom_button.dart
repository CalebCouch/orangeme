import 'package:flutter/material.dart';
import 'package:orange/theme/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/theme/custom_icon.dart';
import 'package:orange/theme/border.dart';

class ButtonVariant {
  static const String bitcoin = "bitcoin";
  static const String primary = "primary";
  static const String secondary = "secondary";
  static const String ghost = "ghost";
}

class ButtonStatus {
  static const String _default = "default";
  static const String _hover = "hover";
  static const String _disabled = "disabled";
}

//0 = default; 1 = hover; 2 = disabled;
//0 = fill; 1 = text;

class ButtonColors {
  static const _primary = [
    [ThemeColor.primary, ThemeColor.handle],
    [ThemeColor.primary, ThemeColor.handle],
    [ThemeColor.textSecondary, ThemeColor.handle],
  ];
  static const _secondary = [
    [ThemeColor.bg, ThemeColor.primary],
    [ThemeColor.bgSecondary, ThemeColor.primary],
    [ThemeColor.bg, ThemeColor.textSecondary],
  ];
  static const _ghost = [
    [ThemeColor.bg, ThemeColor.primary],
    [ThemeColor.bgSecondary, ThemeColor.primary],
    [ThemeColor.bg, ThemeColor.textSecondary],
  ];
  static const _bitcoin = [
    [ThemeColor.bitcoin, ThemeColor.primary],
    [ThemeColor.bitcoin, ThemeColor.primary],
    [ThemeColor.textSecondary, ThemeColor.handle],
  ];
}

class CustomButton extends StatefulWidget {
  final String variant;
  final String status;
  final double buttonSize;
  final String text;

  final String? leftIcon;
  final VoidCallback? onTap;
  final bool? expand;

  const CustomButton(
      {super.key,
      required this.text,
      this.variant = "bitcoin",
      this.buttonSize = ButtonSize.lg,
      this.leftIcon,
      this.onTap,
      this.expand = true,
      this.status = "default"});

  @override
  State<CustomButton> createState() => _ButtonState();
}

class _ButtonState extends State<CustomButton> {
  int buttonStatus = 0;

  _getReceivedStatus(String status) {
    if (widget.status == ButtonStatus._default) return 0;
    if (widget.status == ButtonStatus._hover) return 1;
    if (widget.status == ButtonStatus._disabled) return 2;
  }

  _getColors(int buttonStatus) {
    if (widget.variant == ButtonVariant.primary) {
      return ButtonColors._primary[buttonStatus];
    }
    if (widget.variant == ButtonVariant.secondary) {
      return ButtonColors._secondary[buttonStatus];
    }
    if (widget.variant == ButtonVariant.ghost) {
      return ButtonColors._ghost[buttonStatus];
    }
    if (widget.variant == ButtonVariant.bitcoin) {
      return ButtonColors._bitcoin[buttonStatus];
    }
  }

  _getTextColor(colorsArr) {
    return colorsArr[1];
  }

  _getFillColor(colorsArr) {
    return colorsArr[0];
  }

  _getButtonPadding(double buttonSize) {
    if (buttonSize == ButtonSize.lg) {
      return AppPadding.button[0];
    } else if (buttonSize == ButtonSize.md) {
      return AppPadding.button[1];
    }
  }

  _getButtonSpacing(double buttonSize) {
    if (buttonSize == ButtonSize.lg) {
      return AppPadding.buttonSpacing[0];
    } else if (buttonSize == ButtonSize.md) {
      return AppPadding.buttonSpacing[1];
    }
  }

  _displayIcon() {
    if (widget.leftIcon != null) {
      return Row(
        children: [
          CustomIcon(
            icon: widget.leftIcon!,
            iconSize: widget.buttonSize,
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

  @override
  Widget build(BuildContext context) {
    buttonStatus = _getReceivedStatus(widget.status);
    //var currentColors = _getColors(buttonStatus);
    return Expanded(
      child: InkWell(
        child: Container(
          decoration: ShapeDecoration(
            color: _getFillColor(_getColors(buttonStatus)),
            shape: 
          ),
          height: widget.buttonSize,
          // padding: EdgeInsets.symmetric(
          //horizontal: _getButtonPadding(widget.buttonSize)),
          child: CustomText(
            textType: "label",
            text: widget.text,
            color: _getTextColor(_getColors(buttonStatus)),
          ),
        ),
      ),
    );
  }
}
