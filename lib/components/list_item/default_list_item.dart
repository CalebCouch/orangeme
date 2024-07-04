import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

class DefaultListItem extends StatelessWidget {
  final Widget? topLeft;
  final Widget? bottomLeft;
  final Widget? topRight;
  final Widget? bottomRight;

  const DefaultListItem({
    super.key,
    this.topLeft,
    this.bottomLeft,
    this.topRight,
    this.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppHeights.listItem,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (topLeft != null) topLeft!,
                  if (bottomLeft != null) bottomLeft!,
                ],
              ),
            ),
          ),
          Column(
            children: [
              if (topRight != null) topRight!,
              if (bottomRight != null) bottomRight!,
            ],
          ),
        ],
      ),
    );
  }
}
