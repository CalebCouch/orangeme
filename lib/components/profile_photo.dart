import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';

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

  Future<bool> checkIfAssetExists(String assetPath) async {
    try {
      final bundle = DefaultAssetBundle.of(context);
      await bundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  return FutureBuilder<bool>(
    future: isValidPfp ? checkIfAssetExists(pfp) : Future.value(false),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return loadingCircle();
      } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
        return Container(
          alignment: Alignment.center,
          height: size,
          width: size,
          decoration: BoxDecoration(
            border: outline ? Border.all(color: ThemeColor.bg) : null,
            color: ThemeColor.bgSecondary,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            height: _getIconSize(size),
            width: _getIconSize(size),
            isGroup ? ThemeIcon.group : ThemeIcon.profile,
            colorFilter: const ColorFilter.mode(ThemeColor.textSecondary, BlendMode.srcIn),
          ),
        );
      } else {
        return Container(
          alignment: Alignment.center,
          height: size,
          width: size,
          decoration: BoxDecoration(
            border: outline ? Border.all(color: ThemeColor.bg) : null,
            color: ThemeColor.bgSecondary,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(pfp!),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    },
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
          child: ProfilePhoto(context, contacts[index].pfp, ProfileSize.md, true, false),
        );
      },
    ),
  );
}

Widget EditPhoto(BuildContext context, onTap, [pfp]) {
  return CustomColumn(
    [
      ProfilePhoto(context, pfp, ProfileSize.xxl),
      CustomButton('Photo', 'secondary md hug edit', onTap, 'enabled'),
    ],
    AppPadding.header,
  );
}

Widget loadingCircle() {
  return const Center(
    child: CircularProgressIndicator(
      strokeCap: StrokeCap.round,
      backgroundColor: ThemeColor.bgSecondary,
    ),
  );
}
