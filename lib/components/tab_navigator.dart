import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/messages/home.dart';

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
      switchPageTo(context, MessagesHome(widget.globalState));
    }

    void openBitcoin() {
      print("switching to bitcoin");
      switchPageTo(context, BitcoinHome(widget.globalState));
    }

    return Container(
      padding: const EdgeInsets.all(AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (widget.index == 1) openBitcoin();
              },
              child: Container(
                color: ThemeColor.bg,
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
                color: ThemeColor.bg,
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
