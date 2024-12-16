import 'package:flutter_svg/flutter_svg.dart';
import 'package:material/material.dart';
import 'dart:io';


Widget ProfilePhoto({
  String? variant, 
  String? display_icon, 
  String? profile_picture,
  String size = 'lg',
}) {
  if (profile_picture != null && profile_picture.isNotEmpty) {
    return _buildPhotoVariant(profile_picture, size);
  }
  
  final resolvedVariant = variant ?? 'default';
  switch (resolvedVariant) {
    case 'brand':
      return _buildIconVariant(
        display_icon, 
        size, 
        borderColor: Display.outline_primary,
        backgroundColor: Display.brand_primary,
        iconFallback: 'wallet',
        iconColor: IconColor.enabled,
      );
    default:
      return _buildIconVariant(
        display_icon, 
        size, 
        borderColor: Colors.transparent,
        backgroundColor: Display.bg_secondary,
        iconFallback: 'profile',
        iconColor: Display.text_secondary,
      );
  }
}


Widget _buildPhotoVariant(String profile_picture, String size) {
    return Container(
        alignment: Alignment.center,
        height: profileSize[size],
        width: profileSize[size],
        decoration: BoxDecoration(
            border: Border.all(
                color: Display.bg_primary,
                width: borderThickness[size]!,
            ),
            shape: BoxShape.circle,
            image: DecorationImage(
                image: FileImage(File(profile_picture)),
                fit: BoxFit.cover,
            ),
        ),
    );
}

Widget _buildIconVariant(
    String? display_icon,
    String size, {
    required Color borderColor,
    required Color backgroundColor,
    required String iconFallback,
    required Color iconColor,
}) {
    return Container(
        alignment: Alignment.center,
        height: profileSize[size],
        width: profileSize[size],
        decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderThickness[size]!),
            color: backgroundColor,
            shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
            height: profileIconSize[size],
            width: profileIconSize[size],
            icon[display_icon] ?? icon[iconFallback]!,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
    );
}


const Map<String, double> profileSize = {
    'xxl': 96,
    'xl': 64,
    'lg': 48,
    'md': 32,
    'sm': 24,
};

const Map<String, double> profileIconSize = {
    'xxl': 74,
    'xl': 48,
    'lg': 36,
    'md': 24,
    'sm': 18,
};

const Map<String, double> borderThickness = {
    'xxl': 2.0,
    'xl': 1.5,
    'lg': 1.0,
    'md': 0.75,
    'sm': 0.50,
};
