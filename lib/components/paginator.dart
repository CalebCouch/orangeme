import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

Widget paginator(int pageIndex) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        circle(pageIndex, 0),
        const Spacing(width: 4),
        circle(pageIndex, 1),
        const Spacing(width: 4),
        circle(pageIndex, 2),
        const Spacing(width: 4),
        circle(pageIndex, 3),
      ],
    ),
  );
}

Widget circle(int pageIndex, int myIndex) {
  return Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      color: pageIndex == myIndex ? ThemeColor.border : ThemeColor.bgSecondary,
      shape: BoxShape.circle,
    ),
  );
}
