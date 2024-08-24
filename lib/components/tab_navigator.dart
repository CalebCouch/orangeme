import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/bitcoin/wallet.dart';
import 'package:orange/flows/messages/home.dart';

// Creates a tab navigation bar with icons for switching between the different
// tabs, providing visual feedback and navigation functionality.

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
      HapticFeedback.heavyImpact();
      switchPageTo(context, MessagesHome(widget.globalState));
    }

    void openBitcoin() {
      print("switching to bitcoin");
      HapticFeedback.heavyImpact();
      switchPageTo(context, WalletHome(widget.globalState));
    }

    return Container(
      //color: const Color.fromARGB(255, 21, 48, 61),
      width: MediaQuery.sizeOf(context).width,
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (widget.index == 1) openBitcoin();
              },
              child: Container(
                //color: const Color.fromARGB(255, 134, 175, 195),
                padding: const EdgeInsets.only(right: AppPadding.navBar),
                alignment: Alignment.centerRight,
                child: CustomIcon(
                  icon: ThemeIcon.wallet,
                  iconSize: IconSize.md,
                  iconColor: (widget.index == 0)
                      ? ThemeColor.secondary
                      : ThemeColor.textSecondary,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (widget.index == 0) openMessages();
              },
              child: Container(
                //color: const Color.fromARGB(255, 55, 75, 85),
                padding: const EdgeInsets.only(left: AppPadding.navBar),
                alignment: Alignment.centerLeft,
                child: CustomIcon(
                  icon: ThemeIcon.chat,
                  iconSize: IconSize.md,
                  iconColor: (widget.index == 1)
                      ? ThemeColor.secondary
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
