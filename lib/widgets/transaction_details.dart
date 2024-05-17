import 'package:flutter/material.dart';
import 'package:orange/widgets/dashboard_value.dart';
import 'package:orange/classes.dart';
import 'transaction_list.dart'; // Assuming this file contains formatSatsToDollars and other necessary functions.
import 'package:intl/intl.dart';

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;
  final double price;

  TransactionDetails(
      {super.key, required this.transaction, required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
      ),
      body: Column(
        children: [
          DashboardValue(
            fiatAmount: formatSatsToDollars(transaction.net, price),
            quantity: (transaction.net / 100000000),
          ),
          Expanded(
            child: ListView(
              children: [
                DetailRow(
                    label: "Date",
                    value: DateFormat('MMMM d, yyyy')
                        .format(transaction.timestamp!)),
                DetailRow(
                    label: "Time",
                    value: DateFormat('jm').format(transaction.timestamp!)),
                DetailRow(
                    label: "Received to address", value: "address placeholder"
                    // transaction.address
                    ),
                DetailRow(
                    label: "Amount Received", value: "${transaction.net} sats"),
                DetailRow(
                    label: "Bitcoin Price",
                    value: "\$${price.toStringAsFixed(2)}"),
                DetailRow(
                    label: "USD value received",
                    value: "\$${formatSatsToDollars(transaction.net, price)}"),
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

  DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
