import 'package:flutter_svg/svg.dart';
import 'package:material/material.dart';

const Map<String, String> icon = {
    'copy': 'assets/icons/copy.svg',
    'back': 'assets/icons/back.svg',
    'forward': 'assets/icons/forward.svg',
    'close': 'assets/icons/exit.svg',
    'left': 'assets/icons/left.svg',
    'right': 'assets/icons/right.svg',
    'up': 'assets/icons/up.svg',
    'down': 'assets/icons/down.svg',
    'paste': 'assets/icons/paste.svg',
    'scan': 'assets/icons/scan.svg',
    'qrcode': 'assets/icons/qr-code.svg',
    'radio': 'assets/icons/radio.svg',
    'radioFilled': 'assets/icons/radio-filled.svg',
    'edit': 'assets/icons/edit.svg',
    'home': 'assets/icons/home.svg',
    'bitcoin': 'assets/icons/bitcoin.svg',
    'wallet': 'assets/icons/wallet.svg',
    'error': 'assets/icons/error.svg',
    'message': 'assets/icons/message.svg',
    'group': 'assets/icons/group.svg',
    'profile': 'assets/icons/profile.svg',
    'info': 'assets/icons/info.svg',
    'send': 'assets/icons/send.svg',
    'logo': 'assets/icons/logo.svg',
    'appstore': 'assets/icons/app-store.svg',
    'googleplay': 'assets/icons/google-play.svg',
    'monitor': 'assets/icons/monitor.svg',
    'twitter': 'assets/icons/x-twitter.svg',
    'facebook': 'assets/icons/facebook.svg',
    'instagram': 'assets/icons/instagram.svg',
    'door': 'assets/icons/door.svg',
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
            icon[widget.icon]!,
            width: icon_size[widget.size],
            height: icon_size[widget.size],
            colorFilter: ColorFilter.mode(
                (widget.color != null ? customize_color[widget.color] : ThemeColor.secondary)!,
                BlendMode.srcIn,
            ),
        );
    }
}

final Map<String, double> icon_size = {
    'xxl': 128,
    'xl': 48,
    'lg': 32,
    'md': 20,
};

