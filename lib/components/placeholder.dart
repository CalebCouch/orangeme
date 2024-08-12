import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';

Widget placeholder(BuildContext context, String text, [expand = false]) {
  return expand ? Expanded(child: wText(text)) : wText(text);
}

Widget wText(String text) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(AppPadding.placeholder),
    child: CustomText(
      textSize: TextSize.md,
      text: text,
      color: ThemeColor.textSecondary,
    ),
  );
}
