import 'package:flutter/material.dart';

//to import add: import 'package:orange/styles/stylesheet.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: ThemeColor.bg,
    fontFamily: "Outfit",
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
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
  static const double h4 = 20;
  static const double h5 = 16;
  static const double h6 = 14;
}

class TextType {
  static const String header = "header";
  static const String label = "label";
  static const String text = "text";
  static const String brand = "brand";
}

//// BRAND ////

class BrandSize {
  static const double xxl = 74;
  static const double xl = 64;
  static const double lg = 48;
  static const double md = 32;
  static const double sm = 24;
  static const double xs = 16;
}

class Brand {
  static const String icon = 'assets/icons/logo.svg';
  static const String logomark = 'assets/icons/logomark.svg';
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
  static const Color primary = ConstantsColor._orange;
  static const Color secondary = ConstantsColor._white;
  static const Color handle = ConstantsColor._black;
  static const Color colorHandle = ConstantsColor._white;
  static const Color outline = ConstantsColor._darkGrey;
  static const Color brand = ConstantsColor._white;
  static const Color success = ConstantsColor._green;
  static const Color danger = ConstantsColor._red;
}

////ICONS////

class ThemeIcon {
  static const String copy = 'assets/icons/copy.svg';
  static const String back = 'assets/icons/back.svg';
  static const String close = 'assets/icons/exit.svg';
  static const String left = 'assets/icons/left.svg';
  static const String right = 'assets/icons/right.svg';
  static const String up = 'assets/icons/up.svg';
  static const String down = 'assets/icons/down.svg';
  static const String paste = 'assets/icons/paste.svg';
  static const String scan = 'assets/icons/scan.svg';
  static const String qrcode = 'assets/icons/qr-code.svg';
  static const String radio = 'assets/icons/radio.svg';
  static const String radioFilled = 'assets/icons/radio-filled.svg';
  static const String edit = 'assets/icons/edit.svg';
  static const String home = 'assets/icons/home.svg';
  static const String bitcoin = 'assets/icons/bitcoin.svg';
  static const String wallet = 'assets/icons/wallet.svg';
  static const String error = 'assets/icons/error.svg';
  static const String chat = 'assets/icons/chat.svg';
  static const String group = 'assets/icons/group.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String info = 'assets/icons/info.svg';
  static const String send = 'assets/icons/send.svg';
  static const String cancel = 'assets/icons/cancel.svg';
  static const String checkmark = 'assets/icons/checkmark.svg';
  static const String add = 'assets/icons/add.svg';
}

class IconSize {
  static const double lg = 48;
  static const double md = 32;
}

//// PROFILE ////

class ProfilePlaceholder {
  static const String single = 'assets/icons/photo.svg';
  static const String group = 'assets/icons/group_photo.svg';
}

class ProfileSize {
  static const double xxl = 96;
  static const double xl = 64;
  static const double lg = 48;
  static const double md = 32;
  static const double sm = 24;
}

class IconSizeProfile {
  static const double xxl = 74;
  static const double xl = 48;
  static const double lg = 36;
  static const double md = 24;
  static const double sm = 18;
}

//// BUTTONS ////

class ButtonSize {
  static const double lg = 48;
  static const double md = 32;
}

//// PADDINGS ////

class AppPadding {
  static const double desktop = 16;
  static const double header = 16;
  static const double content = 24;
  static const double bumper = 16;
  static const double valueDisplaySep = 8;
  static const double valueDisplay = 32;
  static const double navBar = 32;
  static const double listItem = 16;
  static const double textInput = 12;
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
  static final BorderRadius textInput = BorderRadius.circular(8);
  static final BorderRadius button = BorderRadius.circular(24);
  static final BorderRadius messageBubble = BorderRadius.circular(8);
}

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

class CornerRadius {
  static BorderRadius qrCode = BorderRadius.circular(12);
}
