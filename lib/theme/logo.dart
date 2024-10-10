import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Logo extends StatelessWidget {
  final double size;

  const Logo({
    super.key,
    this.size = BrandSize.lg,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      ThemeIcon.logo,
      width: size,
      height: size,
    );
  }
}
