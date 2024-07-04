import 'package:flutter/material.dart';
import 'package:orange/theme/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/list_item/default_list_item.dart';

class TransactionListItem extends StatelessWidget {
  final String topLeft;
  final String bottomLeft;
  final String topRight;
  final String bottomRight;

  const TransactionListItem({
    super.key,
    required this.topLeft,
    required this.bottomLeft,
    required this.topRight,
    required this.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultListItem(
      topLeft: CustomText(
        alignment: TextAlign.left,
        textType: "text",
        textSize: TextSize.md,
        text: topLeft,
      ),
      bottomLeft: CustomText(
        alignment: TextAlign.left,
        textType: "text",
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: bottomLeft,
      ),
      topRight: CustomText(
        alignment: TextAlign.right,
        textType: "text",
        textSize: TextSize.md,
        text: topRight,
      ),
      bottomRight: CustomText(
        alignment: TextAlign.right,
        textType: "text",
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: bottomRight,
        underline: true,
      ),
    );
  }
}
