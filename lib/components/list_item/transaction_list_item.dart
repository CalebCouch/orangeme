import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/list_item/list_item.dart';

class TransactionListItem extends StatelessWidget {
  final bool isReceived;
  final String timestamp;
  final double amount;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.isReceived,
    required this.timestamp,
    required this.amount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultListItem(
      onTap: onTap ?? onTap!,
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
        text: timestamp,
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
