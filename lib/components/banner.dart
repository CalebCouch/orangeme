import 'package:flutter/material.dart';
import 'package:orangeme_material/orangeme_material.dart';

Widget CustomBanner(String message) {
  final messageToDisplay = message.contains("orange") ? _buildTextWithBrandMark(message.split('orange')) : _buildMessage(message);
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
          const CustomIcon('error xl'),
          const Spacing(8),
          messageToDisplay,
        ],
      ),
    ),
  );
}

Widget _buildMessage(String message) {
  return CustomText('text sm heading', message);
}

Widget _buildTextWithBrandMark(List<String> parts) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: parts[0],
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ThemeColor.heading,
          ),
        ),
        const TextSpan(
          text: 'orange',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: ThemeColor.primary,
          ),
        ),
        TextSpan(
          text: parts[1],
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ThemeColor.heading,
          ),
        ),
      ],
    ),
  );
}
