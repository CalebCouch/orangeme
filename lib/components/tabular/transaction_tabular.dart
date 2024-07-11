import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/tabular/single_tab.dart';

import 'package:orange/classes/transaction.dart';

class TransactionTabular extends StatelessWidget {
  final TransactionDetails transactionDetails;
  final String direction;

  const TransactionTabular({
    super.key,
    required this.transactionDetails,
    required this.direction,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleTab(title: "Date", subtitle: transactionDetails.date),
        SingleTab(title: "Time", subtitle: transactionDetails.time),
        SingleTab(
            title: "Sent to Address", subtitle: transactionDetails.address),
        SingleTab(
          title: "Amount $direction",
          subtitle: "${transactionDetails.btcValueSent} BTC",
        ),
        if (transactionDetails.bitcoinPrice != null)
          SingleTab(
              title: "Bitcoin Price",
              subtitle: "\$${transactionDetails.bitcoinPrice}"),
        if (transactionDetails.value != null)
          SingleTab(
              title: "USD Value $direction",
              subtitle: '\$${transactionDetails.value}'),
        if (transactionDetails.speed == null && !transactionDetails.isReceived)
          const Spacing(height: AppPadding.content),
        if (transactionDetails.fee != null && !transactionDetails.isReceived)
          SingleTab(
            title: "Fee",
            subtitle: "\$${transactionDetails.fee}",
          ),
        if (transactionDetails.value != null &&
            transactionDetails.fee != null &&
            !transactionDetails.isReceived)
          SingleTab(
            title: "Total Amount",
            subtitle:
                "\$${transactionDetails.value! + transactionDetails.fee!}",
          ),
        if (transactionDetails.speed != null)
          SingleTab(
            title: "Speed",
            subtitle: "${transactionDetails.speed}",
          ),
      ],
    );
  }
}
