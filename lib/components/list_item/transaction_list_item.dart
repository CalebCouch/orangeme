import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/list_item/list_item.dart';
import 'package:orange/flows/wallet_flow/transaction_details/receive_details.dart';

import 'package:orange/util.dart';

class TransactionListItem extends StatelessWidget {
  final bool isReceived;
  final String timestamp;
  final double amount;

  const TransactionListItem({
    super.key,
    required this.isReceived,
    required this.timestamp,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> transactionDetails = [
      "1/13/24",
      "6:08pm",
      "12FWmGPUC...qEL",
      0.00076664,
      62,
      831.17,
      48.61,
    ];
    return DefaultListItem(
      onTap: isReceived
          ? () {
              navigateTo(context,
                  ReceiveDetails(transactionDetails: transactionDetails));
            }
          : () {
              navigateTo(context,
                  ReceiveDetails(transactionDetails: transactionDetails));
            },
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
