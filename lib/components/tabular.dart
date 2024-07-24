import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';

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
            color: ThemeColor.textSecondary,
          ),
          CustomText(
            text: subtitle,
            textSize: TextSize.sm,
            color: ThemeColor.textSecondary,
          )
        ],
      ),
    );
  }
}

Widget transactionTabular(BuildContext context, Transaction tx) {
  return Column(
    children: [
      /*if (tx.recipient != null)
      SingleTab(
        title: "Contact",
        subtitle: "${tx.recipient}",
      ),*/
      SingleTab(title: "Date", subtitle: tx.date ?? "Pending"),
      SingleTab(title: "Time", subtitle: tx.time ?? "Pending"),
      if (tx.sentAddress != null)
        SingleTab(
            title: "Sent to Address",
            subtitle: transactionCut(tx.sentAddress!)),
      if (tx.sentAddress == null)
        SingleTab(
            title: "Received from Address", subtitle: transactionCut(tx.txid)),
      if (tx.sentAddress == null)
        SingleTab(
          title: "Amount Received",
          subtitle: "${tx.btc} BTC",
        ),
      if (tx.sentAddress != null)
        SingleTab(
          title: "Amount Sent",
          subtitle: "${tx.btc} BTC",
        ),
      if (tx.sentAddress != null)
        SingleTab(title: "Bitcoin Price", subtitle: "\$${tx.price}"),
      if (tx.sentAddress == null)
        SingleTab(
          title: "USD Value Received",
          subtitle: "${tx.usd} USD",
        ),
      if (tx.sentAddress != null)
        SingleTab(
          title: "USD Value Sent",
          subtitle: "${(tx.usd).abs()} USD",
        ),
      if (tx.sentAddress != null) const Spacing(height: AppPadding.content),
      if (tx.sentAddress != null)
        SingleTab(
          title: "Fee",
          subtitle: "\$${tx.fee}",
        ),
      if (tx.sentAddress != null)
        SingleTab(
          title: "Total Amount",
          subtitle: "\$${tx.usd + tx.fee}",
        ),
    ],
  );
}

Widget contactTabular(BuildContext context, String name, String did) {
  return Column(
    children: [
      SingleTab(title: "Profile name", subtitle: name),
      SingleTab(title: "Digital ID", subtitle: middleCut(did, 20)),
    ],
  );
}

Widget confirmationTabular(BuildContext context, Transaction tx, [recipient]) {
  return Column(children: [
    if (recipient != null)
      SingleTab(
        title: "Contact",
        subtitle: "${recipient.name}",
      ),
    SingleTab(title: "Date", subtitle: tx.date ?? "Pending"),
    SingleTab(title: "Time", subtitle: tx.time ?? "Pending"),
    if (tx.sentAddress != null)
      SingleTab(
          title: "Sent to Address", subtitle: transactionCut(tx.sentAddress!)),
    if (tx.sentAddress != null)
      SingleTab(
        title: "Amount Sent",
        subtitle: "${tx.btc} BTC",
      ),
    if (tx.sentAddress != null)
      SingleTab(
        title: "Fee",
        subtitle: "${tx.fee} USD",
      ),
  ]);
}
