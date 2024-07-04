import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/theme/custom_text.dart';

import 'package:orange/components/headers/default_header.dart';

class PrimaryHeader extends StatelessWidget {
  final String text;

  const PrimaryHeader({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      center: CustomText(
        textType: "heading",
        text: text,
        textSize: TextSize.h3,
        color: ThemeColor.heading,
      ),
    );
  }
}
