import 'package:flutter/material.dart';
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
        borderColor: ThemeColor.heading,
        backgroundColor: ThemeColor.primary,
        iconFallback: 'wallet',
        iconColor: ThemeColor.heading,
      );
    default:
      return _buildIconVariant(
        display_icon, 
        size, 
        borderColor: Colors.transparent,
        backgroundColor: ThemeColor.bgSecondary,
        iconFallback: 'profile',
        iconColor: ThemeColor.textSecondary,
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
                color: ThemeColor.bg, 
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
