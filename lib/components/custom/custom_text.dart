import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

class CustomText extends StatefulWidget {
  final String textType;
  final String text;
  final double textSize;
  final Color? color;
  final bool underline;
  final TextAlign alignment;

  const CustomText({
    super.key,
    this.textType = "text",
    required this.text,
    this.textSize = TextSize.lg,
    this.color,
    this.underline = false,
    this.alignment = TextAlign.center,
  });

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  _getTextColor(String type) {
    if (widget.color == null) {
      if (type == "text") {
        return ThemeColor.text;
      } else {
        return ThemeColor.heading;
      }
    } else {
      return widget.color;
    }
  }

  _getFontWeight(String type) {
    if (type == "label") {
      return FontWeight.w500;
    } else if (type == "heading") {
      return FontWeight.w700;
    } else {
      return FontWeight.w400;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = _getTextColor(widget.textType);
    return Text(
      widget.text,
      textAlign: widget.alignment,
      style: TextStyle(
        fontFamily: "Outfit",
        fontSize: widget.textSize,
        color: color,
        fontWeight: _getFontWeight(widget.textType),
        decoration:
            widget.underline ? TextDecoration.underline : TextDecoration.none,
        decorationColor: ThemeColor.textSecondary,
        decorationThickness: 1,
      ),
    );
  }
}
