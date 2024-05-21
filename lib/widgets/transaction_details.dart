import 'package:flutter/material.dart';
import 'package:orange/widgets/value_display.dart';
import 'package:orange/classes.dart';
import 'transaction_list.dart';

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;
  final double? price;

  const TransactionDetails(
      {super.key, required this.transaction, required this.price});

  String formatSatsToDollars(int sats, double price) {
    double amount = (sats / 100000000) * price;
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    print("Transaction Details Builder...");
    print("transaction net: ${transaction.net}");
    final displayPrice = price ?? 0;
    print("display price: $displayPrice");
    return Scaffold(
      appBar: AppBar(
        title: Text(transaction.net < 0 ? "Sent Bitcoin" : "Received Bitcoin"),
      ),
      body: Column(
        children: [
          ValueDisplay(
            fiatAmount: formatSatsToDollars(transaction.net, displayPrice),
            quantity: (transaction.net / 100000000).toStringAsFixed(8),
          ),
          Expanded(
            child: ListView(
              children: [
                const DetailRow(label: "Date", value: "date placeholder")
                // DateFormat('MMMM d, yyyy')
                //     .format(transaction.timestamp!))
                ,
                const DetailRow(label: "Time", value: "time placeholder"),

                // DateFormat('jm').format(transaction.timestamp!)),
                const DetailRow(
                    label: "Received to address", value: "address placeholder"
                    // transaction.address
                    ),
                DetailRow(
                    label: "Amount Received", value: "${transaction.net} sats"),
                DetailRow(
                    label: "Bitcoin Price",
                    value: "\$${displayPrice.toStringAsFixed(2)}"),
                DetailRow(
                    label: "USD value received",
                    value:
                        "\$${formatSatsToDollars(transaction.net, displayPrice)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
