import 'package:flutter/material.dart';
import 'package:orangeme_material/color.dart';

class CustomText extends StatefulWidget {
  final String typography;
  final String text;
  final bool underline;
  final TextAlign alignment;

  const CustomText(
    this.typography,
    this.text, {
    super.key,
    this.underline = false,
    this.alignment = TextAlign.center,
  });

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  List<String> x = [];

  @override
  void initState() {
    super.initState();
    x = widget.typography.split(' ');
  }

  @override
  Widget build(BuildContext context) {
    var color = x.length == 3 ? customize_color[x[2]] : text_color[x[0]];
    return Text(
      widget.text,
      textAlign: widget.alignment,
      maxLines: 5,
      style: TextStyle(
        fontFamily: "Outfit",
        fontSize: text_size[x[1]],
        color: color,
        fontWeight: text_weight[x[0]],
        decoration: widget.underline ? TextDecoration.underline : TextDecoration.none,
        decorationColor: color,
        decorationThickness: 1,
      ),
    );
  }
}

final Map<String, double> text_size = {
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

final Map<String, Color> text_color = {
  'heading': ThemeColor.secondary,
  'text': ThemeColor.text,
  'label': ThemeColor.secondary,
};

final Map<String, FontWeight> text_weight = {
  'heading': FontWeight.w700,
  'text': FontWeight.w400,
  'label': FontWeight.w700,
};
