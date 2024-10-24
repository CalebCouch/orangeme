import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';

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
          CustomText('text sm', title),
          CustomText('text sm', subtitle),
        ],
      ),
    );
  }
}

Widget sendTransactioTabular(BuildContext context, ExtTransaction tx) {
  return Column(
    children: [
      SingleTab(title: "Date", subtitle: tx.tx.tx.date),
      SingleTab(title: "Time", subtitle: tx.tx.tx.time),
      SingleTab(title: "Sent to Address", subtitle: transactionCut(tx.tx.address)),
      SingleTab(title: "Amount Sent", subtitle: tx.tx.tx.btc.toString()),
      SingleTab(title: "Bitcoin Price", subtitle: tx.tx.price),
      SingleTab(title: "USD Value Sent", subtitle: tx.tx.tx.usd),
      const Spacing(AppPadding.content),
      SingleTab(title: "Fee", subtitle: tx.fee),
      SingleTab(title: "Total Amount", subtitle: tx.total),
    ],
  );
}

Widget transactionTabular(BuildContext context, BasicTransaction tx) {
  return Column(
    children: [
      SingleTab(title: "Date", subtitle: tx.tx.date),
      SingleTab(title: "Time", subtitle: tx.tx.time),
      SingleTab(title: "Sent to Address", subtitle: transactionCut(tx.address)),
      SingleTab(title: "Amount Sent", subtitle: tx.tx.btc.toString()),
      SingleTab(title: "Bitcoin Price", subtitle: tx.price),
      SingleTab(title: "USD Value Sent", subtitle: tx.tx.usd),
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

Widget confirmationTabular(BuildContext context, String address, String fee, String usd, String btc) {
  return Column(
    children: [
      SingleTab(title: "Sent to Address", subtitle: transactionCut(address)),
      SingleTab(title: "Amount Sent", subtitle: btc),
      SingleTab(title: "USD Value Sent", subtitle: usd),
      SingleTab(title: "Fee", subtitle: fee),
    ],
  );
}
