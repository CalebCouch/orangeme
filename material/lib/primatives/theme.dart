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

final Map<String, double> logo_size = {
    'xxl': 74,
    'xl': 64,
    'lg': 48,
    'md': 32,
    'sm': 24,
    'xs': 16,
};

class AppPadding {
    static const double desktop = 16;
    static const double header = 16;
    static const double content = 24;
    static const double bumper = 16;
    static const double valueDisplaySep = 8;
    static const double valueDisplay = 32;
    static const double navBar = 32;
    static const double listItem = 16;
    static const double textInput = 8;
    static const double tips = 8;
    static const double tab = 4;
    static const double message = 8;
    static const double profile = 32;
    static const double dataItem = 16;
    static const double banner = 8;
    static const double placeholder = 16;
    static const double buttonList = 8;
    static const double sidebar = 32;

    static const buttonSpacing = [12, 8];
    static const button = [16, 12];
}