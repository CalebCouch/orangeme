import 'package:flutter/material.dart';

//to import add: import 'package:orange/styles/stylesheet.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: ThemeColor.bg,
    fontFamily: "Outfit",
  );
}

////TEXT////

class TextSize {
  static const double title = 74;
  static const double subtitle = 64;

  static const double xl = 24;
  static const double lg = 20;
  static const double md = 16;
  static const double sm = 14;
  static const double xs = 12;

  static const double h1 = 48;
  static const double h2 = 32;
  static const double h3 = 24;
  static const double h4 = 14;
  static const double h5 = 12;
  static const double h6 = 12;
}

class TextType {
  static const String header = "header";
  static const String label = "label";
  static const String text = "text";
}

////COLORS////

class ConstantsColor {
  static const Color _black = Colors.black;
  static const Color _offBlack = Color(0xFF262626);
  static const Color _darkGrey = Color(0xFF525458);
  static const Color _grey = Color(0xFF8A8C93);
  static const Color _lightGrey = Color(0xFFD7D8E5);
  // ignore: unused_field
  static const Color _offWhite = Color(0xFFF4F5F5);
  static const Color _white = Color(0xFFFFFFFF);

  static const Color _red = Color(0xFFFF3B00);
  static const Color _green = Color(0xFF00CC00);
  static const Color _orange = Color(0xFFF3474D);
}

class ThemeColor {
  static const Color bg = ConstantsColor._black;
  static const Color bgSecondary = ConstantsColor._offBlack;
  static const Color border = ConstantsColor._darkGrey;
  static const Color heading = ConstantsColor._white;
  static const Color text = ConstantsColor._lightGrey;
  static const Color textSecondary = ConstantsColor._grey;
  static const Color primary = ConstantsColor._white;
  static const Color handle = ConstantsColor._black;
  static const Color colorHandle = ConstantsColor._white;
  static const Color outline = ConstantsColor._darkGrey;
  static const Color brand = ConstantsColor._white;
  static const Color success = ConstantsColor._green;
  static const Color danger = ConstantsColor._red;
  static const Color bitcoin = ConstantsColor._orange;
}

////ICONS////

class ThemeIcon {
  static const String close = 'assets/icons/Icon=close.svg';
  static const String left = 'assets/icons/Icon=left.svg';
  static const String right = 'assets/icons/Icon=right.svg';
  static const String up = 'assets/icons/Icon=up.svg';
  static const String down = 'assets/icons/Icon=down.svg';
  static const String paste = 'assets/icons/Icon=paste.svg';
  static const String scan = 'assets/icons/Icon=scan.svg';
  static const String qrcode = 'assets/icons/Icon=qr-code.svg';
  static const String radio = 'assets/icons/Icon=radio.svg';
  static const String radioFilled = 'assets/icons/Icon=radio-filled.svg';
  static const String edit = 'assets/icons/Icon=edit.svg';
  static const String home = 'assets/icons/Icon=home.svg';
  static const String bitcoin = 'assets/icons/Icon=bitcoin.svg';
  static const String wallet = 'assets/icons/Icon=wallet.svg';
  static const String error = 'assets/icons/Icon=error.svg';
  static const String chat = 'assets/icons/Icon=chat.svg';
  static const String group = 'assets/icons/Icon=group.svg';
  static const String profile = 'assets/icons/Icon=profile.svg';
  static const String info = 'assets/icons/Icon=info.svg';
  static const String send = 'assets/icons/Icon=send.svg';
}

class IconSize {
  static const double lg = 48;
  static const double md = 32;
}

//// BUTTONS ////

class ButtonSize {
  static const double lg = 48;
  static const double md = 32;
}

//// PADDINGS ////

class AppPadding {
  static const double header = 16;
  static const double content = 24;
  static const double bumper = 16;
  static const double valueDisplay = 8;

  static const buttonSpacing = [12, 8];
  static const button = [16, 12];
}

//// SPACINGS ////

class Spacing extends StatelessWidget {
  final double? width;
  final double? height;

  const Spacing({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}

//// BORDERS ////

class ThemeBorders {
  static final BorderRadius button = BorderRadius.circular(24);
}