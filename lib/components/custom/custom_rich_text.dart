import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

class CustomRichText extends StatefulWidget {
  final String textType;
  final String text;
  final double textSize;
  final Color? color;
  final bool underline;

  const CustomRichText({
    super.key,
    this.textType = "text",
    required this.text,
    this.textSize = TextSize.lg,
    this.color,
    this.underline = false,
  });

  @override
  State<CustomRichText> createState() => _CustomRichTextState();
}

class _CustomRichTextState extends State<CustomRichText> {
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
    var color = _getTextColor(widget.textType);
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: widget.text,
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
      ),
    );
  }
}
