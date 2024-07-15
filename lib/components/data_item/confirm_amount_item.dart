import 'package:flutter/material.dart';

import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/tabular/transaction_tabular.dart';
import 'package:orange/components/data_item/data_item.dart';

import 'package:orange/flows/wallet_flow/send_flow/send_amount.dart';
import 'package:orange/flows/wallet_flow/send_flow/transaction_speed.dart';

import 'package:orange/classes/transaction_details.dart';

import 'package:orange/util.dart';

class ConfirmAmountItem extends StatelessWidget {
  const ConfirmAmountItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataItem(
      title: "Confirm Amount",
      listNum: 2,
      content: Container(
        child: const Column(
          children: [
            Spacing(height: AppPadding.bumper),
          //transactionTabular(
          //    context,
          //    Transaction(
          //      false,
          //      "12/1/24",
          //      "6:08 PM",
          //      "12FWmGPUC...qEL",
          //      0.00076664,
          //      null,
          //      null,
          //      null,
          //      'Priority',
          //      null,
          //    ),
          //  ),
            Spacing(height: AppPadding.bumper),
          ],
        ),
      ),
      buttonNames: const ["Amount", "Speed"],
      buttonActions: [
        () {
          navigateTo(context, const SendAmount());
        },
        () {
          navigateTo(context, const TransactionSpeed());
        }
      ],
    );
  }
}
