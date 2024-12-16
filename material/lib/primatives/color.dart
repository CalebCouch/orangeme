import 'dart:ui';
import 'package:material/material.dart';

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

class TorchRed {
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


class Transparent {
    static const Color shade0 = Color(0x00FFFFFF);
    static const Color shade50 = Color(0x15FFFDEB);
    static const Color shade100 = Color(0x2AFEFAC7);
    static const Color shade200 = Color(0x40FDF48A);
    static const Color shade300 = Color(0x55FCE94D);
    static const Color shade400 = Color(0x6AFBD924);
    static const Color shade500 = Color(0x80F5BD14);
    static const Color shade600 = Color(0x95D99106);
    static const Color shade700 = Color(0xAAB46809);
    static const Color shade800 = Color(0xC092500E);
    static const Color shade900 = Color(0xD578420F);
    static const Color shade950 = Color(0xEA452203);
    static const Color shade1000 = Color(0xFFFFFFF);
}

class Display {
    static const Color bg_primary = Tapa.shade1000;
    static const Color bg_secondary = Tapa.shade950;

    static const Color outline_primary = Tapa.shade0;
    static const Color outline_secondary = Tapa.shade700;
    static const Color outline_tint = Tapa.shade300;

    static const Color text_heading = Tapa.shade0;
    static const Color text_primary = Tapa.shade100;
    static const Color text_secondary = Tapa.shade300;

    static const Color status_success = Malachite.shade500;
    static const Color status_warning = Lightning.shade500;
    static const Color status_danger = TorchRed.shade500;

    static const Color brand_primary = TorchRed.shade500;
    static const Color brand_secondary = Tapa.shade0;
}

class IconColor {
    static const Color enabled = Tapa.shade0;
    static const Color inactive = Tapa.shade300;
    static const Color disabled = Tapa.shade950;
}

class ButtonColor {
    final Color background;
    final Color label;
    final Color outline;

    const ButtonColor(this.background, this.label, this.outline);
}

Map buttonColors = {
    'primary': {
        ButtonState.enabled: const ButtonColor( TorchRed.shade500, Tapa.shade0, Transparent.shade0 ),
        ButtonState.hover: const ButtonColor( TorchRed.shade600, Tapa.shade0, Transparent.shade0 ),
        ButtonState.disabled: const ButtonColor( Tapa.shade500, Tapa.shade1000, Transparent.shade0 ),
        ButtonState.selected: const ButtonColor( TorchRed.shade700, Tapa.shade0, Transparent.shade0 ),
    },
    'secondary': {
        ButtonState.enabled: const ButtonColor( Transparent.shade0, Tapa.shade0, Tapa.shade700 ),
        ButtonState.hover: const ButtonColor( Tapa.shade950, Tapa.shade0, Tapa.shade700 ),
        ButtonState.disabled: const ButtonColor( Tapa.shade500, Tapa.shade1000, Tapa.shade700 ),
        ButtonState.selected: const ButtonColor( Transparent.shade0, Tapa.shade0, Tapa.shade700 ),
    },
    'ghost': {
        ButtonState.enabled: const ButtonColor( Transparent.shade0, Tapa.shade0, Transparent.shade0 ),
        ButtonState.hover: const ButtonColor( Transparent.shade100, Tapa.shade0, Transparent.shade0 ),
        ButtonState.disabled: const ButtonColor( Transparent.shade0, Tapa.shade500, Transparent.shade0 ),
        ButtonState.selected: const ButtonColor( Tapa.shade950, Tapa.shade0, Transparent.shade0 ),
    },
};