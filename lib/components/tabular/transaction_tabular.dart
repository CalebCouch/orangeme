import 'package:flutter/material.dart';
import 'package:orange/flows/wallet_flow/receive_flow/receive.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/tabular/single_tab.dart';

class TransactionDetails {
  final bool isReceived;
  final String date;
  final String time;
  final String address;
  final double btcValueSent;
  final double bitcoinPrice;
  final double value;
  final double? fee;

  const TransactionDetails(
    this.isReceived,
    this.date,
    this.time,
    this.address,
    this.btcValueSent,
    this.bitcoinPrice,
    this.value,
    this.fee,
  );
}

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
        SingleTab(
            title: "Bitcoin Price",
            subtitle: "\$${transactionDetails.bitcoinPrice}"),
        SingleTab(
            title: "USD Value $direction",
            subtitle: '\$${transactionDetails.value}'),
        if (!transactionDetails.isReceived)
          const Spacing(height: AppPadding.content),
        if (!transactionDetails.isReceived)
          SingleTab(
            title: "Fee",
            subtitle: "\$${transactionDetails.fee}",
          ),
        if (!transactionDetails.isReceived)
          SingleTab(
            title: "Total Amount",
            subtitle: "\$${transactionDetails.value + transactionDetails.fee!}",
          ),
      ],
    );
  }
}
