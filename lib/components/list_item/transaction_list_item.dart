import 'package:flutter/material.dart';
import 'package:orange/theme/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/list_item/default_list_item.dart';

class TransactionListItem extends StatelessWidget {
  final bool isReceived;
  final String time;
  final int amount;

  const TransactionListItem({
    super.key,
    required this.isReceived,
    required this.time,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultListItem(
      topLeft: CustomText(
        alignment: TextAlign.left,
        textType: "text",
        textSize: TextSize.md,
        text: isReceived ? "Received bitcoin" : "Sent bitcoin",
      ),
      bottomLeft: CustomText(
        alignment: TextAlign.left,
        textType: "text",
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: time,
      ),
      topRight: CustomText(
        alignment: TextAlign.right,
        textType: "text",
        textSize: TextSize.md,
        text: "\$ ${amount}",
      ),
      bottomRight: const CustomText(
        alignment: TextAlign.right,
        textType: "text",
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: "Details",
        underline: true,
      ),
    );
  }
}
