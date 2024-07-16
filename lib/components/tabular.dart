import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/classes.dart';

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
  return Column(children: [
    SingleTab(title: "Date", subtitle: tx.date ?? "Pending"),
    SingleTab(title: "Time", subtitle: tx.time ?? "Pending"),
  ]);
//    children: [
//      if (tx.recipient != null)
//        SingleTab(
//          title: "Contact",
//          subtitle: "${transactionDetails.recipient}",
//        ),
//      SingleTab(title: "Date", subtitle: transactionDetails.date),
//      SingleTab(title: "Time", subtitle: transactionDetails.time),
//      SingleTab(
//          title: "Sent to Address", subtitle: transactionDetails.address),
//      SingleTab(
//        title: "Amount $direction",
//        subtitle: "${transactionDetails.btcValueSent} BTC",
//      ),
//      if (transactionDetails.bitcoinPrice != null)
//        SingleTab(
//            title: "Bitcoin Price",
//            subtitle: "\$${transactionDetails.bitcoinPrice}"),
//      if (transactionDetails.value != null)
//        SingleTab(
//            title: "USD Value $direction",
//            subtitle: '\$${transactionDetails.value}'),
//      if (transactionDetails.speed == null && !transactionDetails.isReceived)
//        const Spacing(height: AppPadding.content),
//      if (transactionDetails.fee != null && !transactionDetails.isReceived)
//        SingleTab(
//          title: "Fee",
//          subtitle: "\$${transactionDetails.fee}",
//        ),
//      if (transactionDetails.value != null &&
//          transactionDetails.fee != null &&
//          !transactionDetails.isReceived)
//        SingleTab(
//          title: "Total Amount",
//          subtitle:
//              "\$${transactionDetails.value! + transactionDetails.fee!}",
//        ),
//      if (transactionDetails.speed != null)
//        SingleTab(
//          title: "Speed",
//          subtitle: "${transactionDetails.speed}",
//        ),
//    ],
//  );
}

Widget contactTabular(BuildContext context, String name, String did) {
  return Column(
    children: [
      SingleTab(title: "Profile name", subtitle: name),
      SingleTab(title: "Digital ID", subtitle: did),
    ],
  );
}
