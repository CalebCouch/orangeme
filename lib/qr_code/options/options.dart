import 'colors.dart';
import 'shapes.dart';
import 'package:zxing_lib/qrcode.dart';

class QrOptions {

  final double padding;
  final QrColors colors;
  final QrShapes shapes;
  final ErrorCorrectionLevel H;

  const QrOptions({
    this.padding = .125,
    this.H = ErrorCorrectionLevel.H,
    this.colors = const QrColors(),
    this.shapes = const QrShapes(),
  });

  @override
  bool operator ==(Object other) =>
      other is QrOptions &&
          other.padding == padding &&
          other.colors == colors &&
          other.shapes == shapes &&
          other.H == H;

  @override
  // TODO: implement hashCode
  int get hashCode => ((((padding.hashCode * 31) + colors.hashCode) * 31)
      + shapes.hashCode) * 31 + H.hashCode;

}