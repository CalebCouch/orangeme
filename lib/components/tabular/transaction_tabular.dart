import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/tabular/single_tab.dart';

class TransactionTab extends StatelessWidget {
  final List<dynamic> transactionDetails;

  const TransactionTab({
    super.key,
    required this.transactionDetails,
  });

  /*List<dynamic> received = [
    date: "1/13/24",
    time: "6:08pm",
    address: "12FWmGPUC...qEL",
    valueBTC: 0.00076664,
    btcPrice: 62,831.17,
    value: 48.61, 
  ];*/

  /*List<dynamic> sent = [
    date: "1/13/24",
    time: "6:08pm",
    address: "12FWmGPUC...qEL",
    valueBTC: 0.00076664,
    btcPrice: 62,831.17,
    value: 48.61, 
  ];*/

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SingleTab(title: "Date", subtitle: transactionDetails[0]),
      ],
    );
  }
}
