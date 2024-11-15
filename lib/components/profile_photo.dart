import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';

_getIconSize(double profileSize) {
  switch (profileSize) {
    case 96:
      return IconSizeProfile.xxl;
    case 64:
      return IconSizeProfile.xl;
    case 48:
      return IconSizeProfile.lg;
    case 32:
      return IconSizeProfile.md;
    case 24:
      return IconSizeProfile.sm;
  }
}

Widget ProfilePhoto(
  BuildContext context, [
  String? pfp,
  double size = ProfileSize.md,
  bool outline = false,
  bool isGroup = false,
]) {
  bool isValidPfp = pfp != null && pfp.isNotEmpty && !isGroup;

  return Container(
    alignment: Alignment.center,
    height: size,
    width: size,
    decoration: BoxDecoration(
      border: outline ? Border.all(color: ThemeColor.bg) : null,
      color: ThemeColor.bgSecondary,
      shape: BoxShape.circle,
      image: isValidPfp
          ? DecorationImage(
              image: AssetImage(pfp),
              fit: BoxFit.cover,
            )
          : null,
    ),
    child: !isValidPfp
        ? SvgPicture.asset(
            height: _getIconSize(size),
            width: _getIconSize(size),
            isGroup ? ThemeIcon.group : ThemeIcon.profile,
            colorFilter: const ColorFilter.mode(ThemeColor.textSecondary, BlendMode.srcIn),
          )
        : null,
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
          child: ProfilePhoto(context, contacts[index].pfpPath, ProfileSize.md, true, false),
        );
      },
    ),
  );
}

Widget EditPhoto(BuildContext context, onTap, [pfp]) {
  return CustomColumn(
    [
      ProfilePhoto(context, pfp, ProfileSize.xxl),
      CustomButton('Photo', 'secondary md hug edit', onTap, true),
    ],
    AppPadding.header,
  );
}
