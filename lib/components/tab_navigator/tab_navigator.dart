import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/wallet_flow/home.dart';
import 'package:orange/flows/messages_flow/home.dart';

//NOTES:
//1. Should be a function
//2. Accept List of IconButton why does this not exist???
//3. Use a list builder so its easy to add more IconButtons later
//4. When declaring the TabNav pass in the Icon button for the current page but just have it disabled and custom color set to highlight. IE:
//tabNav(context, [IconButton("wallet", disabled: true, color: highlight), IconButton("messaging", onTap(nav to messaging))])

class TabNav extends StatefulWidget {
  final int index;
  final GlobalState globalState;
  const TabNav({
    required this.globalState,
    required this.index,
    super.key
  });
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
