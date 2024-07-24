import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/amount_display.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/flows/wallet/transaction_details.dart';

import 'package:orange/flows/wallet/send/send.dart';
import 'package:orange/flows/wallet/receive/receive.dart';

import 'package:orange/util.dart';

class WalletHome extends StatefulWidget {
  final GlobalState globalState;
  const WalletHome(this.globalState, {super.key});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget transactionListItem(BuildContext context, Transaction transaction) {
    return DefaultListItem(
      onTap: () {
        navigateTo(
            context, TransactionDetailsWidget(widget.globalState, transaction));
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
        text: "\$${formatValue(transaction.usd)}",
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
      header: primaryHeader(
        context,
        "Wallet",
      ),
      content: Content(
        content: Column(
          children: [
            AmountDisplay(
              state.usdBalance,
              state.btcBalance,
            ),
            const Spacing(height: AppPadding.content),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: state.transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return transactionListItem(
                        context, state.transactions[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bumper: doubleButtonBumper(
        context,
        "Receive",
        "Send",
        () async {
          var address =
              (await widget.globalState.invoke("get_new_address", "")).data;
          navigateTo(context, Receive(widget.globalState, address));
        },
        () {
          navigateTo(context, Send(widget.globalState));
        },
      ),
      navBar: TabNav(globalState: widget.globalState, index: 0),
    );
  }
}
