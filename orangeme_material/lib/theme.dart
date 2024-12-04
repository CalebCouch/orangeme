import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orangeme_material/color.dart';
import 'package:orangeme_material/icon.dart';

ThemeData theme() {
    return ThemeData(
        scaffoldBackgroundColor: ThemeColor.bg,
        fontFamily: "Outfit",
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: ThemeColor.primary),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: ThemeColor.secondary,
            selectionColor: Color.fromARGB(109, 243, 71, 77),
            selectionHandleColor: ThemeColor.primary,
        ),
    );
}

Widget Logo(String size) {
    return SvgPicture.asset(
        icon['logo']!,
        width: logo_size[size],
        height: logo_size[size],
    );
}

final Map<String, double> logo_size = {
    'xxl': 74,
    'xl': 64,
    'lg': 48,
    'md': 32,
    'sm': 24,
    'xs': 16,
};
