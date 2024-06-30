import 'package:flutter/material.dart';

class AppColors {
  //Greys
  static const Color black = Colors.black;
  static const Color offBlack = Color(0xFF262626);
  static const Color darkGrey = Color(0xFF515357);
  static const Color grey = Color(0xFF8A8C93);
  static const Color lightGrey = Color(0xFFD7D8E5);
  static const Color offWhite = Color(0xFFF4F5F5);
  static const Color white = Colors.white;

  //Colors
  static const Color red = Color(0xFFFF3B00);
  static const Color green = Color(0xFF00CC00);
  static const Color orange = Color(0xFFF3474D);

  //Layout
  static const Color background = Colors.black;
  static const Color backgroundSecondary = Color(0xFF262626);
  static const Color border = Color(0xFF262626);

  //Typography
  static const Color heading = Colors.white;
  static const Color text = Color(0xFFD7D8E5);
  static const Color textSecondary = Color(0xFF8A8C93);

  //Interactive
  static const Color primary = Colors.white;
  static const Color handle = Colors.black;
  static const Color colorHandle = Colors.white;
  static const Color outline = Color(0xFF515357);

  //Special
  static const Color brand = Colors.white;
  static const Color danger = Color(0xFFFF3800);
  static const Color success = Color(0xFF00CC00);
  static const Color bitcoin = Color(0xFFF3474D);
}

class AppTextStyles {
  //Headings
  static const TextStyle heading1 = TextStyle(
      fontSize: 48,
      color: AppColors.heading,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w700,
      height: 0);
  static const TextStyle heading2 = TextStyle(
      fontSize: 32,
      color: AppColors.heading,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w700,
      height: 0);
  static const TextStyle heading3 = TextStyle(
      fontSize: 24,
      color: AppColors.heading,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w700,
      height: 0);
  static const TextStyle heading4 = TextStyle(
      fontSize: 20,
      color: AppColors.heading,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w700,
      height: 0);
  static const TextStyle heading5 = TextStyle(
      fontSize: 16,
      color: AppColors.heading,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w700,
      height: 0);
  static const TextStyle heading6 = TextStyle(
      fontSize: 14,
      color: AppColors.heading,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w700,
      height: 0);

  //Text
  static const TextStyle textXL = TextStyle(
      fontSize: 24,
      color: AppColors.text,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w400,
      height: 0);
  static const TextStyle textLG = TextStyle(
      fontSize: 20,
      color: AppColors.text,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w400,
      height: 0);
  static const TextStyle textMD = TextStyle(
      fontSize: 16,
      color: AppColors.text,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w400,
      height: 0);
  static const TextStyle textSM = TextStyle(
      fontSize: 14,
      color: AppColors.text,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w400,
      height: 0);
  static const TextStyle textXS = TextStyle(
      fontSize: 12,
      color: AppColors.text,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w400,
      height: 0);

  //Labels
  static const TextStyle labelXL = TextStyle(
      fontSize: 24,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w500,
      height: 0);
  static const TextStyle labelLG = TextStyle(
      fontSize: 20,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w500,
      height: 0);
  static const TextStyle labelMD = TextStyle(
      fontSize: 16,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w500,
      height: 0);
  static const TextStyle labelSM = TextStyle(
      fontSize: 14,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w500,
      height: 0);
  static const TextStyle labelXS = TextStyle(
      fontSize: 12,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w500,
      height: 0);

  //Brand
  static const TextStyle brandXL = TextStyle(
      fontSize: 24,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w900,
      height: 0);
  static const TextStyle brandLG = TextStyle(
      fontSize: 20,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w900,
      height: 0);
  static const TextStyle brandMD = TextStyle(
      fontSize: 16,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w900,
      height: 0);
  static const TextStyle brandSM = TextStyle(
      fontSize: 14,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w900,
      height: 0);
  static const TextStyle brandXS = TextStyle(
      fontSize: 12,
      color: AppColors.primary,
      fontFamily: "Outfit",
      fontWeight: FontWeight.w900,
      height: 0);
}

class AppIcons {
  //Brand Mark
  static const String brandmarkXL = 'assets/icons/brandmarkXL.svg';
  static const String brandmarkLG = 'assets/icons/brandmarkLG.svg';
  static const String brandmarkMD = 'assets/icons/brandmarkMD.svg';
  static const String brandmarkSM = 'assets/icons/brandmarkSM.svg';
  static const String brandmarkXS = 'assets/icons/brandmarkXS.svg';

  //Icons
  static const String back = 'assets/icons/Icon=back.svg';
  static const String bitcoin = 'assets/icons/Icon=bitcoin.svg';
  static const String close = 'assets/icons/Icon=close.svg';
  static const String chat = 'assets/icons/Icon=chat.svg';
  static const String down = 'assets/icons/Icon=down.svg';
  static const String edit = 'assets/icons/Icon=edit.svg';
  static const String error = 'assets/icons/Icon=error.svg';
  static const String group = 'assets/icons/Icon=group.svg';
  static const String home = 'assets/icons/Icon=home.svg';
  static const String info = 'assets/icons/Icon=info.svg';
  static const String left = 'assets/icons/Icon=left.svg';
  static const String paste = 'assets/icons/Icon=paste.svg';
  static const String profile = 'assets/icons/Icon=profile.svg';
  static const String qrcode = 'assets/icons/Icon=qr-code.svg';
  static const String radioFilled = 'assets/icons/Icon=radio-filled.svg';
  static const String radio = 'assets/icons/Icon=radio.svg';
  static const String right = 'assets/icons/Icon=right.svg';
  static const String scan = 'assets/icons/Icon=scan.svg';
  static const String send = 'assets/icons/Icon=send.svg';
  static const String up = 'assets/icons/Icon=up.svg';
  static const String wallet = 'assets/icons/Icon=wallet.svg';
}

class AppImages {
  //images
  static const String defaultProfileXL = 'assets/images/default_profileXL.png';
  static const String defaultProfileLG = 'assets/images/default_profileLG.png';
  static const String defaultProfileMD = 'assets/images/default_profileMD.png';
  static const String defaultProfileSM = 'assets/images/default_profileSM.png';
  static const String test1 = 'assets/images/test1.png';
  static const String test2 = 'assets/images/test2.png';
  static const String test3 = 'assets/images/test3.png';
  static const String test4 = 'assets/images/test4.png';
  static const String test5 = 'assets/images/test5.png';
  static const String test6 = 'assets/images/test6.png';
  static const String test7 = 'assets/images/test7.png';
  static const String test8 = 'assets/images/test8.png';
  static const String test9 = 'assets/images/test9.png';
}

//Text Mark Base
class _TextMarkBase extends StatelessWidget {
  final double fontSize;

  const _TextMarkBase({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'orange',
            style: TextStyle(
              color: AppColors.orange,
              fontFamily: 'Outfit',
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          TextSpan(
            text: '.me',
            style: TextStyle(
              color: AppColors.grey,
              fontFamily: 'Outfit',
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

//Text Marks
class TextMarkXL extends _TextMarkBase {
  const TextMarkXL({super.key}) : super(fontSize: 24);
}

class TextMarkLG extends _TextMarkBase {
  const TextMarkLG({super.key}) : super(fontSize: 20);
}

class TextMarkMD extends _TextMarkBase {
  const TextMarkMD({super.key}) : super(fontSize: 16);
}

class TextMarkSM extends _TextMarkBase {
  const TextMarkSM({super.key}) : super(fontSize: 14);
}

class TextMarkXS extends _TextMarkBase {
  const TextMarkXS({super.key}) : super(fontSize: 12);
}
