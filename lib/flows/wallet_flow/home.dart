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

import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes/transaction_details.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/list_item/list_item.dart';
import 'package:orange/flows/wallet_flow/transaction_details.dart';


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
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child){
        return build_screen(context, state);
      }
    );
  }

  Widget transactionListItem(BuildContext context, Transaction transaction) {
    return DefaultListItem(
      onTap: () {
        widget.globalState.setStore("transaction", transaction, false);
        navigateTo(context, TransactionDetailsWidget(widget.globalState));
      },
      topLeft: CustomText(
        alignment: TextAlign.left,
        textType: "text",
        textSize: TextSize.md,
        text: transaction.isReceive ? "Received bitcoin" : "Sent bitcoin",
      ),
      bottomLeft: CustomText(
        alignment: TextAlign.left,
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: transaction.date ?? "Pending",
      ),
      topRight: CustomText(
        alignment: TextAlign.right,
        textSize: TextSize.md,
        text: "\$${transaction.usd}",
      ),
      bottomRight: const CustomText(
        alignment: TextAlign.right,
        textSize: TextSize.sm,
        color: ThemeColor.textSecondary,
        text: "Details",
        underline: true,
      ),
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
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
                  itemCount: state.transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return transactionListItem(context, state.transactions[index]);
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
        firstOnTap: () async {
          var address = (await widget.globalState.invoke("get_new_address", "")).data;
          navigateTo(context, Receive(widget.globalState, address));
        },
        secondOnTap: () {
          navigateTo(context, const Send());
        },
      ),
      navBar: TabNav(globalState: widget.globalState, index: 0),
    );
  }
}
