import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';

class BrandMark extends StatelessWidget {
  final double size;

  const BrandMark({
    super.key,
    this.size = BrandSize.lg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          textType: "header",
          text: "orange",
          color: ThemeColor.bitcoin,
          textSize: size,
        ),
        CustomText(
          textType: "header",
          text: ".me",
          color: ThemeColor.textSecondary,
          textSize: size,
        ),
      ],
    );
  }
}
