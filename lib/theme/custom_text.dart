import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

class CustomText extends StatefulWidget {
  final String textType;
  final String text;
  final double textSize;
  final Color color;

  const CustomText({
    super.key,
    required this.textType,
    required this.text,
    this.textSize = TextSize.lg,
    this.color = ThemeColor.danger,
  });

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  _getTextColor(Color color, String type) {
    if (color == ThemeColor.danger) {
      return _getColor(type);
    } else {
      return color;
    }
  }

  _getColor(String type) {
    if (type == "text") {
      return ThemeColor.text;
    } else {
      return ThemeColor.heading;
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
    return Text(
      widget.text,
      style: TextStyle(
        fontFamily: "Outfit",
        fontSize: widget.textSize,
        color: _getTextColor(widget.color, widget.textType),
        fontWeight: _getFontWeight(widget.textType),
        decoration: TextDecoration.none,
      ),
    );
  }
}
