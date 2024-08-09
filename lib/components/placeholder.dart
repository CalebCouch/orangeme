import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';

Widget placeholder(BuildContext context, String text,
    [ignoreBrandMark = false]) {
  return Expanded(
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppPadding.placeholder),
      child: text.contains('orange.me') && !ignoreBrandMark
          ? withBrandMark(text.split('orange.me'))
          : CustomText(
              textSize: TextSize.md,
              text: text,
            ),
    ),
  );
}

Widget withBrandMark(parts) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: parts[0],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ThemeColor.heading,
          ),
        ),
        const TextSpan(
          text: 'orange',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: ThemeColor.bitcoin,
          ),
        ),
        const TextSpan(
          text: '.me',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: ThemeColor.heading,
          ),
        ),
        TextSpan(
          text: parts[1],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ThemeColor.heading,
          ),
        ),
      ],
    ),
  );
}
