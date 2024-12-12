import '../shapes/ball_shape.dart';
import '../shapes/frame_shape.dart';
import '../shapes/pixel_shape.dart';

class QrShapes {
  final QrPixelShape darkPixel;
  final QrPixelShape lightPixel;
  final QrBallShape ball;
  final QrFrameShape frame;

  const QrShapes(
      {this.darkPixel = const QrPixelShapeDefault(),
      this.lightPixel = const QrPixelShapeDefault(),
      this.ball = const QrBallShapeDefault(),
      this.frame = const QrFrameShapeDefault()});

  @override
  bool operator ==(Object other) =>
      other is QrShapes &&
      other.darkPixel == darkPixel &&
      other.lightPixel == lightPixel &&
      other.ball == ball &&
      other.frame == frame;

  @override
  int get hashCode =>
      (((darkPixel.hashCode * 31) + lightPixel.hashCode * 31) + ball.hashCode) *
          31 +
      frame.hashCode;
}
