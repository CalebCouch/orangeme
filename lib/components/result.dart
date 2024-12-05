import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:orange/generic.dart';

Widget Result({String? icon, required String message}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            CustomIcon(icon: icon ?? 'bitcoin', size: 'xxl'),
            const Spacing(16),
            CustomText(variant:'heading', font_size: 'h3', txt: message),
        ],
    );
}