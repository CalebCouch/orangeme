import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orangeme_material/color.dart';

class ThemeIcon {
  static const String copy = 'assets/icons/copy.svg';
  static const String back = 'assets/icons/back.svg';
  static const String forward = 'assets/icons/forward.svg';
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
  static const String message = 'assets/icons/message.svg';
  static const String group = 'assets/icons/group.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String info = 'assets/icons/info.svg';
  static const String send = 'assets/icons/send.svg';
  static const String logo = 'assets/icons/logo.svg';
  static const String appstore = 'assets/icons/app-store.svg';
  static const String googleplay = 'assets/icons/google-play.svg';
  static const String monitor = 'assets/icons/monitor.svg';
  static const String twitter = 'assets/icons/x-twitter.svg';
  static const String facebook = 'assets/icons/facebook.svg';
  static const String instagram = 'assets/icons/instagram.svg';
  static const String door = 'assets/icons/door.svg';
}

final Map<String, String> icon = {
  'copy': ThemeIcon.copy,
  'back': ThemeIcon.back,
  'forward': ThemeIcon.forward,
  'close': ThemeIcon.close,
  'left': ThemeIcon.left,
  'right': ThemeIcon.right,
  'up': ThemeIcon.up,
  'down': ThemeIcon.down,
  'paste': ThemeIcon.paste,
  'scan': ThemeIcon.scan,
  'qrcode': ThemeIcon.qrcode,
  'radio': ThemeIcon.radio,
  'radioFilled': ThemeIcon.radioFilled,
  'edit': ThemeIcon.edit,
  'home': ThemeIcon.home,
  'bitcoin': ThemeIcon.bitcoin,
  'wallet': ThemeIcon.wallet,
  'error': ThemeIcon.error,
  'message': ThemeIcon.message,
  'group': ThemeIcon.group,
  'profile': ThemeIcon.profile,
  'info': ThemeIcon.info,
  'send': ThemeIcon.send,
  'logo': ThemeIcon.logo,
  'twitter': ThemeIcon.twitter,
  'instagram': ThemeIcon.instagram,
  'facebook': ThemeIcon.facebook,
  'monitor': ThemeIcon.monitor,
  'google-play': ThemeIcon.googleplay,
  'app-store': ThemeIcon.appstore,
  'door': ThemeIcon.door,
};

final Map<String, double> icon_size = {
  'xxl': 128,
  'xl': 48,
  'lg': 32,
  'md': 20,
};

class CustomIcon extends StatefulWidget {
  final String size;
  final String icon;
  final String? color;

  const CustomIcon({super.key, required this.icon, required this.size, this.color});

  @override
  State<CustomIcon> createState() => CustomIconState();
}

class CustomIconState extends State<CustomIcon> {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon[widget.icon],
      width: icon_size[widget.size],
      height: icon_size[widget.size],
      colorFilter: ColorFilter.mode(
        (widget.color != null ? customize_color[widget.color] : ThemeColor.secondary)!,
        BlendMode.srcIn,
      ),
    );
  }
}
