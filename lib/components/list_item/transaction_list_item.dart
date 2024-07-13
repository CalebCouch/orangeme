import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/transaction_details.dart';

import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/list_item/list_item.dart';

import 'package:orange/flows/wallet_flow/transaction_details.dart';

import 'package:orange/util.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionDetails transactionDetails;

  const TransactionListItem({
    super.key,
    required this.transactionDetails,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultListItem(
      onTap: transactionDetails.isReceived
          ? () {
              navigateTo(
                  context,
                  TransactionDetailsWidget(
                      transactionDetails: transactionDetails));
            }
          : () {
              navigateTo(
                  context,
                  TransactionDetailsWidget(
                      transactionDetails: transactionDetails));
            },
      topLeft: CustomText(
        alignment: TextAlign.left,
        textType: "text",
        textSize: TextSize.md,
        text:
            transactionDetails.isReceived ? "Received bitcoin" : "Sent bitcoin",
      ),
      bottomLeft: CustomText(
        alignment: TextAlign.left,
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: transactionDetails.date,
      ),
      topRight: CustomText(
        alignment: TextAlign.right,
        textSize: TextSize.md,
        text: "\$${transactionDetails.value}",
      ),
      bottomRight: const CustomText(
        alignment: TextAlign.right,
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: "Details",
        underline: true,
      ),
    );
  }
}
