import 'package:flutter/material.dart';
import 'package:material/material.dart';
import './custom_qr_generator.dart';
import './options/options.dart';
import './options/shapes.dart';
import './qr_painter.dart';
import './shapes/pixel_shape.dart';

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