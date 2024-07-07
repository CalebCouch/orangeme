import 'package:flutter/material.dart';
import 'package:orange/components/tabular/transaction_tabular.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/data_item/data_item.dart';
import 'package:orange/util.dart';
import 'package:orange/flows/wallet_flow/send_flow/send_amount.dart';
import 'package:orange/flows/wallet_flow/send_flow/transaction_speed.dart';

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
            TransactionTabular(
                transactionDetails: TransactionDetails(
                  false,
                  "12/1/24",
                  "6:08 PM",
                  "12FWmGPUC...qEL",
                  0.00076664,
                  null,
                  null,
                  null,
                  'Priority',
                ),
                direction: 'Send'),
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
