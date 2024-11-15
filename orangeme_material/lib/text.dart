import 'package:flutter/material.dart';
import 'package:orangeme_material/color.dart';

class CustomText extends StatefulWidget {
  final String variant;
  final String? text_color;
  final String? font_size;
  final String txt;
  final TextDecoration text_decoration;
  final TextAlign alignment;

  const CustomText({
    super.key,
    required this.txt, 
    this.variant = 'text',
    this.font_size = 'lg',
    this.text_color,
    this.font_size,
    this.underline = false,
    this.alignment = TextAlign.center,
  });

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    var dec_color = widget.text_color != null ? customize_color[widget.text_color] : std_color[widget.variant];
    return Text(
      widget.txt,
      textAlign: widget.alignment,
      maxLines: 5,
      style: TextStyle(
        fontFamily: "Outfit",
        fontSize: size[font_size],
        color: dec_color,
        fontWeight: weight[widget.variant],
        decoration: widget.text_decoration,
        decorationColor: dec_color,
        decorationThickness: 1,
      ),
    );
  }
}

final Map<String, double> size = {
  'title': 72,
  'h1': 48,
  'h2': 32,
  'h3': 24,
  'h4': 20,
  'h5': 16,
  'h6': 14,
  'xl': 24,
  'lg': 20,
  'md': 16,
  'sm': 14,
  'xs': 12,
};

final Map<String, Color> std_color = {
  'heading': ThemeColor.secondary,
  'text': ThemeColor.text,
  'label': ThemeColor.secondary,
};

final Map<String, FontWeight> weight = {
  'heading': FontWeight.w700,
  'text': FontWeight.w400,
  'label': FontWeight.w700,
};
