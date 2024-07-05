import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';

class Logo extends StatelessWidget {
  final double size;

  const Logo({
    super.key,
    this.size = LogoSize.lg,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      BrandLogo.icon,
      width: size,
      height: size,
    );
  }
}
