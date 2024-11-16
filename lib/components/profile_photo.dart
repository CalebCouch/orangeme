import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';


Widget ProfilePhoto ( 
    BuildContext context, [ 
        String? pfp, 
        double size = ProfileSize.md, 
        bool isGroup = false,
    ]
){
        
    bool isValidPfp = pfp != null && !isGroup;

    return Container(
        alignment: Alignment.center,
        height: size,
        width: size,
        decoration: BoxDecoration(
            border: isGroup ? Border.all(color: ThemeColor.bg) : null,
            color: ThemeColor.bgSecondary,
            shape: BoxShape.circle,
            image: !isValidPfp ? null : DecorationImage(
                image: AssetImage(pfp),
                fit: BoxFit.cover,
            )
        ),
        child: isValidPfp ? null : SvgPicture.asset(
            height: _getIconSize(size),
            width: _getIconSize(size),
            isGroup ? ThemeIcon.group : ThemeIcon.profile,
            colorFilter: const ColorFilter.mode(ThemeColor.textSecondary, BlendMode.srcIn),
        ),
    );
}

Widget ProfileButton(BuildContext context, pfp, onTap) {
    return InkWell(onTap: onTap, child: ProfilePhoto(context));
}

Widget profilePhotoStack(BuildContext context, List<Profile> contacts) {
    return Container(
        width: 128,
        height: 32,
        alignment: Alignment.center,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: contacts.length < 5 ? contacts.length : 5,
            itemBuilder: (BuildContext context, int index) {
                return Align(
                    widthFactor: 0.75,
                    child: ProfilePhoto(context, contacts[index].pfpPath, ProfileSize.md, true),
                );
            },
        ),
    );
}

Widget EditPhoto(BuildContext context, onTap, [pfp]) {
    return CustomColumn([
            ProfilePhoto(context, pfp, ProfileSize.xxl),
            CustomButton(
                txt: 'Photo', 
                variant: 'secondary', 
                size: 'md', 
                expand: false, 
                icon: 'edit', 
                onTap: onTap
            ),
        ], AppPadding.header,
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
