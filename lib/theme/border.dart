import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

class BoxDecorations {
  static RoundedRectangleBorder button = RoundedRectangleBorder(
    borderRadius: ThemeBorders.button,
  );

  static RoundedRectangleBorder buttonOutlined = RoundedRectangleBorder(
    side: const BorderSide(
      width: 1,
      color: ThemeColor.outline,
    ),
    borderRadius: ThemeBorders.button,
  );
}
