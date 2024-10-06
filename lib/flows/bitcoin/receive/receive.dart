import 'package:flutter/material.dart';
import 'package:orange/components/qr_code/options/options.dart';
import 'package:orange/components/qr_code/options/shapes.dart';
import 'package:orange/components/qr_code/qr_painter.dart';
import 'package:orange/components/qr_code/shapes/pixel_shape.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:share/share.dart';
import 'package:orange/classes.dart';

class Receive extends StatefulWidget {
  final GlobalState globalState;
  final String address;
  const Receive(this.globalState, this.address, {super.key});

  @override
  ReceiveState createState() => ReceiveState();
}

class ReceiveState extends State<Receive> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  onShare() {
    () => {Share.share(widget.address)};
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return Stack_Default(
      Header_Stack(context, "Receive bitcoin"),
      [
        QRCode(widget.address),
        Instructions(),
      ],
      Bumper([
        CustomButton('Share', 'primary lg enabled expand none', onShare()),
      ]),
    );
  }
}

//The following widgets can ONLY be used in this file

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

Widget Instructions() {
  return const CustomText('text md text_secondary', 'Scan to receive bitcoin.');
}
