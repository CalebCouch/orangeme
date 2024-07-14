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
  final GlobalState globalState;
  const WalletHome({
    required this.globalState,
    super.key
  });

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
    _getTransactions() {
    return <TransactionDetails>[
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
        'Chris Slaughter',
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
        null,
      ),
    ];
  }

  Widget build_screen(BuildContext context, DartState state) {
    var tList = _getTransactions();
    return DefaultInterface(
      header: const PrimaryHeader(
        text: "Wallet",
      ),
      content: Content(
        content: Column(
          children: [
            AmountDisplay(
              value: state.usdBalance,
              converted: state.btcBalance,
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
      navBar: TabNav(globalState: widget.globalState, index: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionDetails> tList = _getTransactions();
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child){
        return build_screen(context, state);
      }
    );
  }
}
