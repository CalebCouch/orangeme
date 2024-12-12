import 'package:flutter/material.dart';
import 'dart:ui';

class Tapa {
    static const Color shade0 = Color(0xFFFFFFFF);
    static const Color shade50 = Color(0xFFF4F3F2);
    static const Color shade100 = Color(0xFFE2E1DF);
    static const Color shade200 = Color(0xFFC7C4C1);
    static const Color shade300 = Color(0xFFA7A29D);
    static const Color shade400 = Color(0xFF8E8781);
    static const Color shade500 = Color(0xFF78716C);
    static const Color shade600 = Color(0xFF6D6561);
    static const Color shade700 = Color(0xFF585250);
    static const Color shade800 = Color(0xFF4D4846);
    static const Color shade900 = Color(0xFF443F3F);
    static const Color shade950 = Color(0xFF262322);
    static const Color shade1000 = Color(0xFF000000);
}

class Torch {
    static const Color shade50 = Color(0xFFFEF2F2);
    static const Color shade100 = Color(0xFFFEE2E3);
    static const Color shade200 = Color(0xFFFDCBCD);
    static const Color shade300 = Color(0xFFFBA6A9);
    static const Color shade400 = Color(0xFFF67377);
    static const Color shade500 = Color(0xFFEB343A);
    static const Color shade600 = Color(0xFFDA282E);
    static const Color shade700 = Color(0xFFB71E23);
    static const Color shade800 = Color(0xFF971D21);
    static const Color shade900 = Color(0xFF7E1E21);
    static const Color shade950 = Color(0xFF440B0D);
}

class GoldDrop {
    static const Color shade50 = Color(0xFFFFF8ED);
    static const Color shade100 = Color(0xFFFEEFD6);
    static const Color shade200 = Color(0xFFFCDCAC);
    static const Color shade300 = Color(0xFFFAC177);
    static const Color shade400 = Color(0xFFF79C40);
    static const Color shade500 = Color(0xFFF58727);
    static const Color shade600 = Color(0xFFE66510);
    static const Color shade700 = Color(0xFFBE4D10);
    static const Color shade800 = Color(0xFF973C15);
    static const Color shade900 = Color(0xFF7A3414);
    static const Color shade950 = Color(0xFF421808);
}

class Malachite {
    static const Color shade50 = Color(0xFFF1FCF2);
    static const Color shade100 = Color(0xFFDFF9E4);
    static const Color shade200 = Color(0xFFC0F2CA);
    static const Color shade300 = Color(0xFF8FE6A1);
    static const Color shade400 = Color(0xFF57D171);
    static const Color shade500 = Color(0xFF3CCB5A);
    static const Color shade600 = Color(0xFF23963B);
    static const Color shade700 = Color(0xFF1F7631);
    static const Color shade800 = Color(0xFF1D5E2C);
    static const Color shade900 = Color(0xFF1A4D26);
    static const Color shade950 = Color(0xFF092A12);
}

class Lightning {
    static const Color shade50 = Color(0xFFFFFDEB);
    static const Color shade100 = Color(0xFFFEFAC7);
    static const Color shade200 = Color(0xFFFDF48A);
    static const Color shade300 = Color(0xFFFCE94D);
    static const Color shade400 = Color(0xFFFBD924);
    static const Color shade500 = Color(0xFFF5BD14);
    static const Color shade600 = Color(0xFFD99106);
    static const Color shade700 = Color(0xFFB46809);
    static const Color shade800 = Color(0xFF92500E);
    static const Color shade900 = Color(0xFF78420F);
    static const Color shade950 = Color(0xFF452203);
}

class Shade {
    static const Color darken_1 = Color(0x14000000);
    static const Color darken_2 = Color(0x40000000);
    static const Color lighten_1 = Color(0x14FFFFFF);
    static const Color lighten_2 = Color(0x40FFFFFF);
}

class ThemeColor {
    /// Display ///
    static const Color bg = Tapa.shade1000;
    static const Color bgSecondary = Tapa.shade950;
    static const Color border = Tapa.shade700;
    static const Color outline = Tapa.shade700;
    static const Color heading = Tapa.shade0;
    static const Color text = Tapa.shade100;
    static const Color textSecondary = Tapa.shade300;
    static const Color success = Malachite.shade500;
    static const Color warning = Lightning.shade500;
    static const Color danger = Torch.shade500;

    /// Interactive ///
    static const Color primary = Torch.shade500;
    static const Color label = Tapa.shade0;
    static const Color secondary = Tapa.shade0;
    static const Color disabled = Tapa.shade900;
    static const Color labelSecondary = Tapa.shade800;
    static const Color labelDisabled = Tapa.shade1000;

}

final Map<String, Color> customize_color = {
    'bg': ThemeColor.bg,
    'bg_secondary': ThemeColor.bgSecondary,
    'border': ThemeColor.border,
    'outline': ThemeColor.outline,
    'heading': ThemeColor.heading,
    'text': ThemeColor.text,
    'text_secondary': ThemeColor.textSecondary,
    'primary': ThemeColor.primary,
    'secondary': ThemeColor.secondary,
    'handle': ThemeColor.labelSecondary,
    'color_handle': ThemeColor.label,
    'brand': ThemeColor.primary,
    'success': ThemeColor.success,
    'warning': ThemeColor.warning,
    'danger': ThemeColor.danger,
    'primary_hover': ThemeColor.primary,
};


class ButtonColor {
    final String fill;
    final String text;

    const ButtonColor(this.fill, this.text);
}

Map buttonColors = {
    'primary': {
        'enabled': const ButtonColor('primary', 'color_handle'),
        'hovering': const ButtonColor('primary_hover', 'color_handle'),
        'disabled': const ButtonColor('text_secondary', 'handle'),
        'selected': const ButtonColor('primary', 'color_handle'),
    },
    'secondary': {
        'enabled': const ButtonColor('bg', 'color_handle'),
        'hovering': const ButtonColor('bg_secondary', 'color_handle'),
        'disabled': const ButtonColor('bg', 'text_secondary'),
        'selected': const ButtonColor('bg_secondary', 'color_handle'),
    },
    'ghost': {
        'enabled': const ButtonColor('bg', 'color_handle'),
        'hovering': const ButtonColor('bg_secondary', 'color_handle'),
        'disabled': const ButtonColor('bg', 'text_secondary'),
        'selected': const ButtonColor('bg_secondary', 'color_handle'),
    },
};