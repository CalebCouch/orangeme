import 'package:flutter/material.dart';
import 'package:orange/flows/savings/set_up/get_mobile.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/wallet/home.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/savings/home.dart';
import 'dart:io' show Platform;

class TabNav extends StatefulWidget {
  final int index;
  final GlobalState globalState;
  const TabNav(this.globalState, {required this.index, super.key});
  @override
  State<TabNav> createState() => TabNavState();
}

class TabNavState extends State<TabNav> {
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
      if (Platform.isAndroid || Platform.isIOS) {
        switchPageTo(context, SavingsHome(widget.globalState));
      } else {
        switchPageTo(context, MobileSetUp(widget.globalState));
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.index != 0) openWallet();
              },
              child: Container(
                color: ThemeColor.bg,
                padding: const EdgeInsets.only(right: AppPadding.navBar),
                alignment: Alignment.centerRight,
                child: CustomIcon(
                  icon: ThemeIcon.wallet,
                  iconSize: IconSize.md,
                  iconColor: (widget.index == 0)
                      ? ThemeColor.primary
                      : ThemeColor.textSecondary,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.index != 1) openSavings();
              },
              child: Container(
                color: ThemeColor.bg,
                alignment: Alignment.center,
                child: CustomIcon(
                  icon: ThemeIcon.savings,
                  iconSize: IconSize.md,
                  iconColor: (widget.index == 1)
                      ? ThemeColor.primary
                      : ThemeColor.textSecondary,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.index != 2) openMessages();
              },
              child: Container(
                color: ThemeColor.bg,
                padding: const EdgeInsets.only(left: AppPadding.navBar),
                alignment: Alignment.centerLeft,
                child: CustomIcon(
                  icon: ThemeIcon.chat,
                  iconSize: IconSize.md,
                  iconColor: (widget.index == 2)
                      ? ThemeColor.primary
                      : ThemeColor.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
