import 'package:material/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomText extends StatefulWidget {
    final String variant;
    final String? text_color;
    final String? font_size;
    final String txt;
    final TextDecoration text_decoration;
    final TextOverflow? overflow;
    final TextAlign alignment;
    final int? max_lines;

    const CustomText({
        super.key,
        required this.txt, 
        this.variant = 'text',
        this.font_size = 'lg',
        this.text_color,
        this.text_decoration = TextDecoration.none,
        this.alignment = TextAlign.center,
        this.overflow,
        this.max_lines,
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
            maxLines: widget.max_lines ?? null, 
            overflow: widget.max_lines == null ? null : TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: "Outfit",
                fontSize: size[widget.font_size],
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

final Map<String, double> textMarkSize = {
    'title': 120,
    'h1': 90,
    'h2': 80,
    'h3': 70,
    'h4': 60,
    'h5': 50,
    'h6': 40,
    'xl': 80,
    'lg': 70,
    'md': 60,
    'sm': 50,
    'xs': 40,
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

String EllipsisText(String input){
    int maxLength = 30;
    if (input.length <= maxLength) { return input; }
    final startLength = (maxLength / 2).floor();
    final endLength = maxLength - startLength - 3; 
    return '${input.substring(0, startLength)}...${input.substring(input.length - endLength)}';
}

Widget CustomTextSpan(String inputText, {font_size = 'h6'}) {
  final parts = inputText.split('orange');
  final spans = <InlineSpan>[];

  for (int i = 0; i < parts.length; i++) {
    if (parts[i].isNotEmpty) {
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          color: ThemeColor.heading,
          fontWeight: FontWeight.w700,
          fontSize: size[font_size],
          fontFamily: 'Outfit',
        ),
      ));
    }

    if (i < parts.length - 1) {
      spans.add(WidgetSpan(
        baseline: TextBaseline.alphabetic,
        alignment: PlaceholderAlignment.baseline,
        child: Transform.translate(
          offset: const Offset(0, 5),
          child: SvgPicture.asset(icon['wordmark']!, width: textMarkSize[font_size]),
        ),
      ));
    }
  }

  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(children: spans),
  );
}
