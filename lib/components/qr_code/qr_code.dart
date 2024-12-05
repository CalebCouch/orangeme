import 'package:flutter/material.dart';
import 'package:orange/theme/logo.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/components/qr_code/custom_qr_generator.dart';
import 'package:orange/components/qr_code/options/options.dart';
import 'package:orange/components/qr_code/options/shapes.dart';
import 'package:orange/components/qr_code/qr_painter.dart';
import 'package:orange/components/qr_code/shapes/pixel_shape.dart';

Widget QRCode(String address) {
    return Stack(
        alignment: Alignment.center,
        children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
            Positioned(
                child: Logo('xxl'),
            ),
        ],
    );
}
