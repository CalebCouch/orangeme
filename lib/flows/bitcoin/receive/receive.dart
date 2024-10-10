import 'package:flutter/material.dart';
import 'package:orange/components/qr_code/options/options.dart';
import 'package:orange/components/qr_code/options/shapes.dart';
import 'package:orange/components/qr_code/qr_painter.dart';
import 'package:orange/components/qr_code/shapes/pixel_shape.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:share/share.dart';
import 'package:orange/global.dart' as global;

class Receive extends GenericWidget {
  Receive({super.key});

  String address = "8475729859832898587463636536474388384";

  @override
  ReceiveState createState() => ReceiveState();
}

class ReceiveState extends GenericState<Receive> {
  @override
  String stateName() {
    return "Receive";
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.address = json["address"];
    });
  }

  @override
  void initState() {
    super.initState();
    global.invoke("get_new_address", "");
  }

  onShare() {
    Share.share(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    return Stack_Default(
      Header_Stack(context, "Receive bitcoin"),
      [
        QRCode(widget.address),
        Instructions(),
      ],
      Bumper(context, [
        CustomButton('Share', 'primary lg enabled expand none', onShare),
      ]),
      Alignment.center,
      false,
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
