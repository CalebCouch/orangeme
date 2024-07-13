import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/util.dart';

import 'package:orange/flows/wallet_flow/home.dart';
import 'package:orange/flows/messages_flow/home.dart';

class TabNav extends StatefulWidget {
  final int index;
  const TabNav({
    super.key,
    required this.index,
  });
  @override
  State<TabNav> createState() => TabNavState();
}

class TabNavState extends State<TabNav> {
  @override
  Widget build(BuildContext context) {
    void openMessages() {
      print("switching to messages");
      switchPageTo(context, const MessagesHome());
    }

    void openWallet() {
      print("switching to wallet");
      switchPageTo(context, const WalletHome());
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
                if (widget.index == 1) openWallet();
              },
              child: Container(
                color: ThemeColor.bg,
                padding: const EdgeInsets.only(right: AppPadding.navBar / 2),
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
                if (widget.index == 0) openMessages();
              },
              child: Container(
                color: ThemeColor.bg,
                padding: const EdgeInsets.only(left: AppPadding.navBar / 2),
                alignment: Alignment.centerLeft,
                child: CustomIcon(
                  icon: ThemeIcon.chat,
                  iconSize: IconSize.md,
                  iconColor: (widget.index == 1)
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
