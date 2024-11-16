import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class BrandSize {
    static const double xxl = 74;
    static const double xl = 64;
    static const double lg = 48;
    static const double md = 32;
    static const double sm = 24;
    static const double xs = 16;
}