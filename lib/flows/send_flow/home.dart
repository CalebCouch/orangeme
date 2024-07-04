import 'package:flutter/material.dart';
import 'package:orange/components/list_item/transaction_list_item.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/interfaces/default_interface.dart';
import 'package:orange/components/headers/primary_header.dart';
import 'package:orange/components/btc_value/btc_value.dart';
import 'package:orange/components/bumpers/double_button_bumper.dart';
import 'package:orange/components/tab_navigator/tab_navigator.dart';

class WalletHome extends StatelessWidget {
  const WalletHome({super.key});

  _enterReceiveFlow() {}
  _enterSendFlow() {}

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          child: SafeArea(
            child: DefaultInterface(
              header: const PrimaryHeader(
                text: "Wallet",
              ),
              content: const Column(children: [
                AmountDisplay(
                  value: 0,
                ),
                Spacing(height: AppPadding.content),
                TransactionListItem(
                  topLeft: "Sent Bitcoin",
                  topRight: "\$48.61",
                  bottomLeft: "4:52 PM",
                  bottomRight: "Details",
                )
              ]),
              bumper: DoubleButton(
                firstText: "Receive",
                secondText: "Send",
                firstOnTap: _enterReceiveFlow(),
                secondOnTap: _enterSendFlow(),
              ),
              navBar: const TabNav(),
            ),
          ),
        ),
      ),
    );
  }
}
