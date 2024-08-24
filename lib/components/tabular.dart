import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:intl/intl.dart';

// Displays tabular information for transactions, contacts, and confirmations
// using SingleTab widgets to organize and present various details.

/*  A widget displaying a title and subtitle in a row, with padding applied. */
class SingleTab extends StatelessWidget {
  final String title;
  final String subtitle;

  const SingleTab({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.tab),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            textSize: TextSize.sm,
          ),
          CustomText(
            text: subtitle,
            textSize: TextSize.sm,
          )
        ],
      ),
    );
  }
}

/* Creates a column of SingleTab widgets showing detailed information about a transaction, including date, time, addresses, amounts, and value in USD. */
Widget transactionTabular(BuildContext context, Transaction tx) {
  late String formattedDate;
  if (tx.date != null) {
    formattedDate = DateFormat.yMd()
        .format(DateFormat('yyyy-MM-dd').parse(tx.date!))
        .toString();
  }
  return Column(
    children: [
      /*if (tx.recipient != null)
      SingleTab(
        title: "Contact",
        subtitle: "${tx.recipient}",
      ),*/
      SingleTab(
          title: "Date", subtitle: tx.date != null ? formattedDate : "Pending"),
      SingleTab(title: "Time", subtitle: tx.time ?? "Pending"),
      if (tx.sentAddress != null)
        SingleTab(
            title: "Sent to Address",
            subtitle: transactionCut(tx.sentAddress!)),
      if (tx.sentAddress == null)
        SingleTab(
            title: "Received From Address", subtitle: transactionCut(tx.txid)),
      if (tx.sentAddress == null)
        SingleTab(
          title: "Amount Received",
          subtitle: "${(tx.btc).abs()} BTC",
        ),
      if (tx.sentAddress != null)
        SingleTab(
          title: "Amount Sent",
          subtitle: "${(tx.btc).abs()} BTC",
        ),
      SingleTab(
        title: "Bitcoin Price",
        subtitle: "\$${NumberFormat('#,##,000.00').format(tx.price)}",
      ),
      if (tx.sentAddress == null)
        SingleTab(
          title: "USD Value Received",
          subtitle: "\$${formatValue(tx.usd)}",
        ),
      if (tx.sentAddress != null)
        SingleTab(
          title: "USD Value Sent",
          subtitle: "\$${formatValue(tx.usd.abs() - tx.fee.abs())}",
        ),
      if (tx.sentAddress != null) const Spacing(height: AppPadding.content),
      if (tx.sentAddress != null)
        SingleTab(
          title: "Fee",
          subtitle: "\$${formatValue(tx.fee)}",
        ),
      if (tx.sentAddress != null)
        SingleTab(
          title: "Total Amount",
          subtitle: "\$${formatValue(tx.usd.abs())}",
        ),
    ],
  );
}

/* Shows a column of SingleTab widgets with contact details, including profile name and digital ID. */
Widget contactTabular(BuildContext context, String name, String did) {
  return Column(
    children: [
      SingleTab(title: "Profile name", subtitle: name),
      SingleTab(title: "Digital ID", subtitle: middleCut(did, 20)),
    ],
  );
}

/* Provides a column of SingleTab widgets summarizing transaction confirmation details, 
such as sent address, amount sent, and USD value. */

Widget confirmationTabular(BuildContext context, Transaction tx, [recipient]) {
  return Column(
    children: [
      if (recipient != null)
        SingleTab(
          title: "Contact",
          subtitle: "${recipient.name}",
        ),
      if (tx.sentAddress != null)
        SingleTab(
            title: "Sent to Address",
            subtitle: transactionCut(tx.sentAddress!)),
      if (tx.sentAddress != null)
        SingleTab(
          title: "Amount Sent",
          subtitle: "${tx.btc.abs()} BTC",
        ),
      if (tx.sentAddress != null)
        SingleTab(
          title: "USD Value Sent",
          subtitle: "\$${tx.usd.abs()}",
        ),
      if (tx.sentAddress != null)
        SingleTab(
          title: "Fee",
          subtitle: "\$${formatValue(tx.fee)} USD",
        ),
    ],
  );
}
