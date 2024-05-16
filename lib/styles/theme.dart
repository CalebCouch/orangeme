import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData theme() {
  Color secondaryColor = Colors.orange.withOpacity(.8);
  Color primaryColor = Colors.orange.withOpacity(.8);
  Color globalBackgroundColor = AppColors.background;
  return ThemeData(
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryColor,
      scaffoldBackgroundColor: globalBackgroundColor,
      appBarTheme: const AppBarTheme(
        titleTextStyle: AppTextStyles.heading4,
        iconTheme: IconThemeData(color: AppColors.primary),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
      ),
      textTheme: TextTheme(
          displayLarge: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
          displayMedium: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.5),
          bodyLarge: TextStyle(
              color: Colors.white.withOpacity(.8),
              fontWeight: FontWeight.w500,
              fontSize: 12),
          labelLarge: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        hintStyle: TextStyle(
            color: Colors.white.withOpacity(.4),
            fontWeight: FontWeight.w500,
            fontSize: 10),
      ));
}
