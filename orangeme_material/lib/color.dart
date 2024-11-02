// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class ConstantsColor {
  static const Color _black = Color(0xFF000000);
  static const Color _offBlack = Color(0xFF262626);
  static const Color _darkGrey = Color(0xFF525458);
  static const Color _grey = Color(0xFF8A8C93);
  static const Color _lightGrey = Color(0xFFD7D8E5);
  static const Color _offWhite = Color(0xFFF4F5F5);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _red = Color(0xFFFF3B00);
  static const Color _green = Color(0xFF00CC00);
  static const Color _orange = Color(0xFFF3474D);
  static const Color _pink = Color(0xFFD13F45);
}

class ThemeColor {
  static const Color bg = ConstantsColor._black;
  static const Color bgSecondary = ConstantsColor._offBlack;
  static const Color border = ConstantsColor._darkGrey;
  static const Color heading = ConstantsColor._white;
  static const Color text = ConstantsColor._lightGrey;
  static const Color textSecondary = ConstantsColor._grey;
  static const Color primary = ConstantsColor._orange;
  static const Color secondary = ConstantsColor._white;
  static const Color handle = ConstantsColor._black;
  static const Color colorHandle = ConstantsColor._white;
  static const Color outline = ConstantsColor._darkGrey;
  static const Color brand = ConstantsColor._white;
  static const Color success = ConstantsColor._green;
  static const Color danger = ConstantsColor._red;
  static const Color hover = ConstantsColor._pink;
}

final Map<String, Color> customize_color = {
  'bg': ThemeColor.bg,
  'bg_secondary': ThemeColor.bgSecondary,
  'border': ThemeColor.border,
  'heading': ThemeColor.heading,
  'text': ThemeColor.text,
  'text_secondary': ThemeColor.textSecondary,
  'primary': ThemeColor.primary,
  'secondary': ThemeColor.secondary,
  'handle': ThemeColor.handle,
  'color_handle': ThemeColor.colorHandle,
  'outline': ThemeColor.outline,
  'brand': ThemeColor.brand,
  'success': ThemeColor.success,
  'danger': ThemeColor.danger,
  'primary_hover': ThemeColor.hover,
};
