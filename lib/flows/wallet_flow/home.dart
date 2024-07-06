import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/interfaces/default_interface.dart';

import 'package:orange/components/list_item/transaction_list_item.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/primary_header.dart';
import 'package:orange/components/amount_display/amount_display.dart';
import 'package:orange/components/bumpers/double_button_bumper.dart';
import 'package:orange/components/tab_navigator/tab_navigator.dart';

import 'package:orange/flows/wallet_flow/send_flow/send.dart';
import 'package:orange/flows/wallet_flow/receive_flow/receive.dart';

class WalletHome extends StatelessWidget {
  const WalletHome({super.key});

  void _enterReceiveFlow(context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const Receive(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  _enterSendFlow(context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const Send(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const PrimaryHeader(
        text: "Wallet",
      ),
      content: const Content(
        content: Column(
          children: [
            AmountDisplay(
              value: 0,
            ),
            Spacing(height: AppPadding.content),
            TransactionListItem(
              amount: 48.41,
              timestamp: "4:52 PM",
              isReceived: true,
            ),
          ],
        ),
      ),
      bumper: DoubleButton(
        firstText: "Receive",
        secondText: "Send",
        firstOnTap: () {
          _enterReceiveFlow(context);
        },
        secondOnTap: () {
          _enterSendFlow(context);
        },
      ),
      navBar: const TabNav(),
    );
  }
}
