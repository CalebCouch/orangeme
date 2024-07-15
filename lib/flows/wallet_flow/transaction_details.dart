import 'package:flutter/material.dart';
import 'package:orange/components/tabular/transaction_tabular.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/amount_display/amount_display.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/classes/transaction_details.dart';
import 'package:orange/classes.dart';

class TransactionDetailsWidget extends StatefulWidget {
  final GlobalState globalState;
  const TransactionDetailsWidget(this.globalState, {super.key});

  @override
  TransactionDetailsWidgetState createState() =>
      TransactionDetailsWidgetState();
}

class TransactionDetailsWidgetState extends State<TransactionDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    Transaction tx = widget.globalState.getStore("transaction")!;
    String direction = tx.isReceive ? "Received" : "Sent";

    return DefaultInterface(
      header: StackHeader(text: "$direction bitcoin"),
      content: Content(
        content: Column(
          children: [
            AmountDisplay(
              value: tx.usd,
              converted: tx.btc
            ),
            const Spacing(height: AppPadding.content),
            transactionTabular(context, tx),
          ],
        ),
      ),
      bumper: SingleButton(
        variant: ButtonVariant.secondary,
        text: "Done",
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
