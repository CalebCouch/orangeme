import 'package:flutter/material.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';

class NumberButton extends StatelessWidget {
  final String number;

  const NumberButton({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: number,
      textType: 'label',
      color: ThemeColor.primary,
    );
  }
}
