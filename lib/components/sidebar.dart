import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/wallet/home.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/savings/home.dart';

class Sidebar extends StatefulWidget {
  final int index;
  final GlobalState globalState;
  const Sidebar({required this.globalState, required this.index, super.key});
  @override
  State<Sidebar> createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    void openMessages() {
      print("switching to messages");
      switchPageTo(context, MessagesHome(globalState: widget.globalState));
    }

    void openWallet() {
      print("switching to wallet");
      switchPageTo(context, WalletHome(widget.globalState));
    }

    void openSavings() {
      print("switching to savings");
      switchPageTo(context, SavingsHome(widget.globalState));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      width: 250,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(
          child: CustomButton(
            text: 'Wallet',
            onTap: () {},
            icon: ThemeIcon.wallet,
            status: 3,
          ),
        ),
      ]),
    );
  }
}
