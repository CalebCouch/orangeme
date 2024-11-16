import 'dart:math';
import 'custom_qr_generator.dart';
import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:zxing_lib/qrcode.dart';
import './util.dart';

class QrPainter extends CustomPainter {
  final String data;
  final QrOptions options;
  late ByteMatrix matrix;

  QrPainter({
    required this.data,
    required this.options,
  }) {
    matrix = Encoder.encode(data, options.H).matrix!;

    var width = matrix.width ~/ 4;
    if (width % 2 != matrix.width % 2) {
      width++;
    }
    var height = matrix.height ~/ 4;
    if (height % 2 != matrix.height % 2) {
      height++;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final codeSize = min(size.width, size.height);
    final padding = codeSize * options.padding / 3;
    final pixelSize = (codeSize - 2 * padding) / matrix.width;
    final realCodeSize = codeSize - padding * 2;
    final lightPaint =
        options.colors.light.createPaint(realCodeSize, realCodeSize);
    final darkPaint =
        options.colors.dark.createPaint(realCodeSize, realCodeSize);
    Path? darkPath;
    Path? lightPath;
    Path fullDarkPath = Path();
    Path fullLightPath = Path();

    var frameSize = pixelSize * 7;
    var ballSize = pixelSize * 3;

    final framePathZeroOffset = options.shapes.frame
        .createPath(Offset.zero, frameSize, Neighbors.empty);
    final framePaint =
        options.colors.frame.createPaint(pixelSize * 3, pixelSize * 3);

    final ballPathZeroOffset = options.shapes.ball
        .createPath(Offset.zero, pixelSize * 3, Neighbors.empty);
    final ballPaint =
        options.colors.ball.createPaint(pixelSize * 3, pixelSize * 3);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        options.colors.background.createPaint(size.width, size.height));

    canvas.save();
    canvas.translate(padding, padding);

    void drawFrame(double dx, double dy) {
      if (options.colors.frame is! QrColorUnspecified) {
        canvas.save();
        canvas.translate(dx, dy);
        canvas.drawPath(framePathZeroOffset, framePaint);
        canvas.restore();
      } else {
        var path = options.shapes.frame
            .createPath(Offset(dx, dy), frameSize, Neighbors.empty);
        canvas.drawPath(path, darkPaint);
      }
    }

    void drawBall(double dx, double dy) {
      if (options.colors.ball is! QrColorUnspecified) {
        canvas.save();
        canvas.translate(dx, dy);
        canvas.drawPath(ballPathZeroOffset, ballPaint);
        canvas.restore();
      } else {
        var path = options.shapes.ball
            .createPath(Offset(dx, dy), ballSize, Neighbors.empty);
        canvas.drawPath(path, darkPaint);
      }
    }

    drawFrame(0, 0);
    drawBall(pixelSize * 2, pixelSize * 2);

    drawFrame(pixelSize * (matrix.width - 7), 0);
    drawBall(pixelSize * (matrix.width - 5), pixelSize * 2);

    drawFrame(0, pixelSize * (matrix.width - 7));
    drawBall(pixelSize * 2, pixelSize * (matrix.height - 5));

    int middleSize =
        (matrix.width / 3.4).floor(); // Make the center square bigger
    int middleStart = (matrix.width - middleSize) ~/ 2;
    int middleEnd = middleStart + middleSize;

    for (int i = 0; i < matrix.width; i++) {
      for (int j = 0; j < matrix.height; j++) {
        // Skip drawing behind the eyes
        if ((i < 7 && j < 7) ||
            (i >= matrix.width - 7 && j < 7) ||
            (i < 7 && j >= matrix.height - 7)) {
          continue;
        }

        // Skip drawing within the middle square
        if (i >= middleStart &&
            i < middleEnd &&
            j >= middleStart &&
            j < middleEnd) {
          continue;
        }

        if (options.colors.dark is! QrColorUnspecified) {
          darkPath = options.shapes.darkPixel
              .createPath(Offset.zero, pixelSize, matrix.neighbors(i, j));
          if (matrix.get(i, j) == 1) {
            fullDarkPath.addPath(
                darkPath, Offset(i * pixelSize, j * pixelSize));
          }
        }
        if (options.colors.light is! QrColorUnspecified) {
          lightPath = options.shapes.lightPixel
              .createPath(Offset.zero, pixelSize, matrix.neighbors(i, j));
          if (matrix.get(i, j) != 0) {
            fullLightPath.addPath(
                lightPath, Offset(i * pixelSize, j * pixelSize));
          }
        }
      }
    }

    if (options.colors.dark is! QrColorUnspecified) {
      canvas.drawPath(fullDarkPath, darkPaint);
    }
    if (options.colors.light is! QrColorUnspecified) {
      canvas.drawPath(fullLightPath, lightPaint);
    }
    canvas.restore();
  }

  @override
  bool operator ==(Object other) =>
      other is QrPainter && other.data == data && other.options == options;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  int get hashCode => (data.hashCode) * 31 + options.hashCode;
}
