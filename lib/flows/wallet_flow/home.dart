import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/transaction_details.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/list_item/transaction_list_item.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/primary_header.dart';
import 'package:orange/components/amount_display/amount_display.dart';
import 'package:orange/components/bumpers/double_button_bumper.dart';
import 'package:orange/components/tab_navigator/tab_navigator.dart';

import 'package:orange/flows/wallet_flow/send_flow/send.dart';
import 'package:orange/flows/wallet_flow/receive_flow/receive.dart';

import 'package:orange/util.dart';

import 'dart:convert';
import 'dart:async';



class WalletHome extends StatefulWidget {
  const WalletHome({super.key});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {

  ValueNotifier<Balance> _balance = ValueNotifier(Balance(0, 0));
  ValueNotifier<Iterable<HomeTx>> _txs = ValueNotifier([]);
  Timer? _timer = null;

  refresh() async {
    var balance = Balance.fromJson(jsonDecode((await invoke("get_balance", "")).data));
    var txs = jsonDecode((await invoke("get_home_transactions", "")).data).map((tx) => {
      HomeTx.fromJson(tx)
    });
    setState(() {
      _balance.value = balance;
    });
  }

  @override
  initState() {
    refresh();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {await refresh();});
  }

  _getTransactions() {
    return <TransactionDetails>[
      const TransactionDetails(
        true,
        "12/1/24",
        "6:08 PM",
        "12FWmGPUC...qEL",
        0.00076664,
        62831.17,
        48.61,
        null,
        null,
      ),
      const TransactionDetails(
        true,
        "12/1/24",
        "6:08 PM",
        "12FWmGPUC...qEL",
        0.00076664,
        62831.17,
        48.61,
        null,
        null,
      ),
      const TransactionDetails(
        true,
        "12/1/24",
        "6:08 PM",
        "12FWmGPUC...qEL",
        0.00076664,
        62831.17,
        48.61,
        null,
        null,
      ),
      const TransactionDetails(
        true,
        "12/1/24",
        "6:08 PM",
        "12FWmGPUC...qEL",
        0.00076664,
        62831.17,
        48.61,
        null,
        null,
      ),
      const TransactionDetails(
        false,
        "12/1/24",
        "6:08 PM",
        "12FWmGPUC...qEL",
        0.00076664,
        62831.17,
        48.61,
        3.45,
        null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    currentCtx = context;
    List<TransactionDetails> tList = _getTransactions();
    return DefaultInterface(
      header: const PrimaryHeader(
        text: "Wallet",
      ),
      content: Content(
        content: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _balance,
              builder: (BuildContext context, Balance value, Widget? child){
                return AmountDisplay(
                  value: value.usd,
                  converted: value.btc,
                );
              }
            ),
            const Spacing(height: AppPadding.content),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: tList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TransactionListItem(
                      transactionDetails: tList[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bumper: DoubleButton(
        firstText: "Receive",
        secondText: "Send",
        firstOnTap: () {
          navigateTo(context, const Receive());
        },
        secondOnTap: () {
          navigateTo(context, const Send());
        },
      ),
      navBar: const TabNav(index: 0),
    );
  }
}
