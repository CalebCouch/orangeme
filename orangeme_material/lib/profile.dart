import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orangeme_material/color.dart';
import 'package:orangeme_material/icon.dart';
import 'dart:io';


Widget ProfilePhoto (BuildContext context, [String? pfp, double size = ProfileSize.md, bool isGroup = false ] ){
    return Container(
        alignment: Alignment.center,
        height: size,
        width: size,

        decoration: BoxDecoration(
            border: isGroup ? Border.all(color: ThemeColor.bg) : null,
            color: ThemeColor.bgSecondary,
            shape: BoxShape.circle,
            // IF the pfp is not null, display picture
            image: pfp == null ? null : DecorationImage(
                image: FileImage(File(pfp)),
                fit: BoxFit.cover,
            ),
        ),

        // IF the pfp is null, or a group icon, display preset
        child: pfp == null || isGroup ? SvgPicture.asset(
            height: _getIconSize(size),
            width: _getIconSize(size),
            isGroup ? ThemeIcon.group : ThemeIcon.profile,
            colorFilter: const ColorFilter.mode(ThemeColor.textSecondary, BlendMode.srcIn),
        ) : null,
    );
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

_getIconSize(double profileSize) {
    switch (profileSize) {
        case 96: return IconSizeProfile.xxl;
        case 64: return IconSizeProfile.xl;
        case 48: return IconSizeProfile.lg;
        case 32: return IconSizeProfile.md;
        case 24: return IconSizeProfile.sm;
    }
}
