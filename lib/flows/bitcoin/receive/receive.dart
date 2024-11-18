import 'package:flutter/material.dart';
import 'package:orange/components/qr_code/options/options.dart';
import 'package:orange/components/qr_code/options/shapes.dart';
import 'package:orange/components/qr_code/qr_painter.dart';
import 'package:orange/components/qr_code/shapes/pixel_shape.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:share/share.dart';
import 'package:orange/global.dart' as global;

class Receive extends GenericWidget {
    Receive({super.key});

    String address = "";
    
    @override
    ReceiveState createState() => ReceiveState();
}

class ReceiveState extends GenericState<Receive> {

    @override
    PageName getPageName() {
        return PageName.receive();
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
    }

    onShare() => Share.share("Send me Bitcoin:\n${widget.address}");

    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, "Receive bitcoin"),
            content: [
                QRCode(widget.address),
                Instructions(),
            ],
            bumper: Bumper(context, 
                content: [CustomButton(txt: 'Share', variant: 'primary', size: 'lg', onTap: onShare)]
            ),
            alignment: Alignment.center,
            scroll: false,
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
    return CustomText(
        variant: 'text', 
        font_size: 'md', 
        text_color: 'text_secondary', 
        txt: 'Scan to receive bitcoin.'
    );
}
