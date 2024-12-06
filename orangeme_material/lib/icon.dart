import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orangeme_material/color.dart';

const Map<String, String> icon = {
  'up': 'assets/icons/up.svg',
  'back': 'assets/icons/back.svg',
  'copy': 'assets/icons/copy.svg',
  'down': 'assets/icons/down.svg',
  'edit': 'assets/icons/edit.svg',
  'home': 'assets/icons/home.svg',
  'info': 'assets/icons/info.svg',
  'left': 'assets/icons/left.svg',
  'logo': 'assets/icons/logo.svg',
  'link': 'assets/icons/link.svg',
  'send': 'assets/icons/send.svg',
  'scan': 'assets/icons/scan.svg',
  'door': 'assets/icons/door.svg',
  'exit': 'assets/icons/exit.svg',
  'right': 'assets/icons/right.svg',
  'error': 'assets/icons/error.svg',
  'group': 'assets/icons/group.svg',
  'radio': 'assets/icons/radio.svg',
  'wallet': 'assets/icons/wallet.svg',
  'qrcode': 'assets/icons/qr-code.svg',
  'profile': 'assets/icons/profile.svg',
  'message': 'assets/icons/message.svg',
  'bitcoin': 'assets/icons/bitcoin.svg',
  'forward': 'assets/icons/forward.svg',
  'monitor': 'assets/icons/monitor.svg',
  'facebook': 'assets/icons/facebook.svg',
  'twitter': 'assets/icons/x-twitter.svg',
  'wordmark': 'assets/icons/wordmark.svg',
  'appstore': 'assets/icons/app-store.svg',
  'checkmark': 'assets/icons/checkmark.svg',
  'instagram': 'assets/icons/instagram.svg',
  'googleplay': 'assets/icons/google-play.svg',
  'radioFilled': 'assets/icons/radio-filled.svg',
  'download-apple': 'assets/icons/download-apple.svg',
  'download-google': 'assets/icons/download-google.svg',
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
            icon[widget.icon] ?? icon['logo']!,
            width: icon_size[widget.size],
            height: icon_size[widget.size],
            colorFilter: ColorFilter.mode(
                (widget.color != null ? customize_color[widget.color] : ThemeColor.secondary)!,
                BlendMode.srcIn,
            ),
        );
    }
}
