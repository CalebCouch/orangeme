import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:intl/intl.dart';
import 'package:orange/classes.dart';
import 'package:orange/widgets/transaction_details.dart';

//formats a unix timestamp into a human readable date
String formatTimestamp(DateTime? time) {
  if (time == null) {
    return "Pending";
  } else {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime localTime = time.toLocal();
    DateTime localDate =
        DateTime(localTime.year, localTime.month, localTime.day);

    if (localTime.isAfter(now.subtract(const Duration(minutes: 1)))) {
      return 'Just now';
    } else if (localDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (localDate
        .isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else if (localTime.year == now.year) {
      return DateFormat('MMMM d').format(time);
    } else {
      return DateFormat('MMMM d, yyyy').format(time);
    }
  }
}

//formats a number of satoshis into dollars at the current price
String formatSatsToDollars(int sats, double price) {
  double amount = (sats / 100000000) * price;
  return "${amount >= 0 ? '' : '- '}\$${amount.abs().toStringAsFixed(2)}";
}

//lists all of the transaction cards
Widget transactionsList(ValueNotifier<List<Transaction>> transactions,
    ValueNotifier<double> price) {
  return ValueListenableBuilder<List<Transaction>>(
    valueListenable: transactions,
    builder: (BuildContext context, List<Transaction> value, Widget? child) {
      return Expanded(
          child: ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          return buildTransactionCard(context, value[index], price);
        },
      ));
    },
  );
}

//each transaction card represents a single transaction
Widget buildTransactionCard(BuildContext context, Transaction transaction,
    ValueNotifier<double> price) {
  return InkWell(
    onTap: () {
      double currentPrice = price.value;
      print("current price before navigating: $currentPrice");
      print("transaction before navigating: $transaction");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            TransactionDetails(transaction: transaction, price: currentPrice),
      ));
    },
    child: Card(
      color: AppColors.background,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(transaction.net < 0 ? "Sent Bitcoin" : "Received Bitcoin",
                  style: AppTextStyles.textMD),
              ValueListenableBuilder<double>(
                valueListenable: price,
                builder:
                    (BuildContext innerContext, double value, Widget? child) {
                  return Text(formatSatsToDollars(transaction.net, value),
                      style: AppTextStyles.textMD);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTimestamp(transaction.timestamp),
                  style: AppTextStyles.textMD
                      .copyWith(color: AppColors.textSecondary)),
              Text("Details",
                  style: AppTextStyles.textMD.copyWith(
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    ),
  );
}
