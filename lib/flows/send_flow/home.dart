import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/interfaces/default_interface.dart';
import 'package:orange/components/headers/primary_header.dart';
import 'package:orange/components/btc_value/btc_value.dart';
import 'package:orange/components/bumpers/double_button_bumper.dart';

class WalletHome extends StatelessWidget {
  const WalletHome({super.key});

  _enterReceiveFlow() {}
  _enterSendFlow() {}
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: DefaultInterface(
          header: const PrimaryHeader(
            text: "Wallet",
          ),
          content: const Column(children: [
            AmountDisplay(
              value: 0, //needs to be users balance,
            ),
            Spacing(height: AppPadding.content),
            /*TransactionHistory(
              transactionsList: transactionsList,
            ),*/
          ]),
          bumper: DoubleButton(
            firstText: "Receive",
            secondText: "Send",
            firstOnTap: _enterReceiveFlow(),
            secondOnTap: _enterSendFlow(),
          ),
          /*
        navBar: ModeNav(
          onWallet: true,
        ),*/
        ),
      ),
    );
  }
}
