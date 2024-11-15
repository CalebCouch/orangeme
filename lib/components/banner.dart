import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';

Widget CustomBanner(String message) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(width: 1, color: ThemeColor.border),
                bottom: BorderSide(width: 1, color: ThemeColor.border),
            ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const CustomIcon(icon: 'error', size: 'xl'),
                    const Spacing(8),
                    CustomText(variant: 'text', font_size: 'sm',  text_color: 'heading', txt: message);
                ],
            ),
        ),
    );
}