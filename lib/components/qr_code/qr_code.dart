import 'package:flutter/material.dart';
import 'package:orange/theme/brand/logo.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/qr_code/custom_qr_generator.dart';
import 'package:orange/theme/border.dart';

Widget qrCode(String address) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        child: ClipRRect(
          borderRadius: CornerRadius.qrCode,
          child: CustomPaint(
            size: const Size(312, 312),
            painter: QrPainter(
              data: address,
              options: const QrOptions(
                shapes: QrShapes(
                  darkPixel: QrPixelShapeCircle(),
                ),
              ),
            ),
          ),
        ),
      ),
      const Positioned(
        child: Logo(size: LogoSize.xxl),
      ),
    ],
  );
}
