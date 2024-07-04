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
  static const int _default = 0;
  static const int _hover = 1;
  static const int _disabled = 2;
}

//0 = fill; 1 = text;

Map buttonColors = {
  ButtonVariant.primary: {
    ButtonStatus._default: (ThemeColor.primary, ThemeColor.handle),
    ButtonStatus._hover: (ThemeColor.primary, ThemeColor.handle),
    ButtonStatus._disabled: (ThemeColor.textSecondary, ThemeColor.handle),
  },
  ButtonVariant.secondary: {
    ButtonStatus._default: (ThemeColor.bg, ThemeColor.primary),
    ButtonStatus._hover: (ThemeColor.bgSecondary, ThemeColor.primary),
    ButtonStatus._disabled: (ThemeColor.bg, ThemeColor.textSecondary),
  },
  ButtonVariant.ghost: {
    ButtonStatus._default: (ThemeColor.bg, ThemeColor.primary),
    ButtonStatus._hover: (ThemeColor.bgSecondary, ThemeColor.primary),
    ButtonStatus._disabled: (ThemeColor.bg, ThemeColor.textSecondary),
  },
  ButtonVariant.bitcoin: {
    ButtonStatus._default: (ThemeColor.bitcoin, ThemeColor.primary),
    ButtonStatus._hover: (ThemeColor.bitcoin, ThemeColor.primary),
    ButtonStatus._disabled: (ThemeColor.textSecondary, ThemeColor.handle),
  }
};

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
    //buttonStatus = _getReceivedStatus(widget.status);
    //var currentColors = _getColors(buttonStatus);
    return Expanded(
      child: InkWell(
        child: Container(
          decoration: ShapeDecoration(
            color: _getFillColor(buttonColors[widget.variant][widget.status]),
            shape: ShapeDecorations.button,
          ),
          height: widget.buttonSize,
          // padding: EdgeInsets.symmetric(
          //horizontal: _getButtonPadding(widget.buttonSize)),
          child: CustomText(
            textType: "label",
            text: widget.text,
            color: _getTextColor(buttonColors[widget.variant][widget.status]),
          ),
        ),
      ),
    );
  }
}
