import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material/material.dart';

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
