import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
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

class ButtonColor {
  final Color fill;
  final Color text;

  const ButtonColor(this.fill, this.text);
}

Map buttonColors = {
  ButtonVariant.primary: {
    ButtonStatus._default:
        const ButtonColor(ThemeColor.primary, ThemeColor.handle),
    ButtonStatus._hover:
        const ButtonColor(ThemeColor.primary, ThemeColor.handle),
    ButtonStatus._disabled:
        const ButtonColor(ThemeColor.textSecondary, ThemeColor.handle),
  },
  ButtonVariant.secondary: {
    ButtonStatus._default: const ButtonColor(ThemeColor.bg, ThemeColor.primary),
    ButtonStatus._hover:
        const ButtonColor(ThemeColor.bgSecondary, ThemeColor.primary),
    ButtonStatus._disabled:
        const ButtonColor(ThemeColor.bg, ThemeColor.textSecondary),
  },
  ButtonVariant.ghost: {
    ButtonStatus._default: const ButtonColor(ThemeColor.bg, ThemeColor.primary),
    ButtonStatus._hover:
        const ButtonColor(ThemeColor.bgSecondary, ThemeColor.primary),
    ButtonStatus._disabled:
        const ButtonColor(ThemeColor.bg, ThemeColor.textSecondary),
  },
  ButtonVariant.bitcoin: {
    ButtonStatus._default:
        const ButtonColor(ThemeColor.bitcoin, ThemeColor.primary),
    ButtonStatus._hover:
        const ButtonColor(ThemeColor.bitcoin, ThemeColor.primary),
    ButtonStatus._disabled:
        const ButtonColor(ThemeColor.textSecondary, ThemeColor.handle),
  }
};

class CustomButton extends StatefulWidget {
  final String variant;
  final int status;
  final double buttonSize;
  final String text;

  final String? icon;
  final VoidCallback? onTap;
  final bool expand;
  final Alignment buttonAlignment;

  const CustomButton({
    super.key,
    required this.text,
    this.variant = ButtonVariant.bitcoin,
    this.buttonSize = ButtonSize.lg,
    this.expand = true,
    this.status = ButtonStatus._default,
    this.icon,
    this.onTap,
    this.buttonAlignment = Alignment.center,
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
    return InkWell(
      onTap: widget.onTap ?? widget.onTap,
      child: Container(
        alignment: Alignment.center,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _displayIcon(),
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
