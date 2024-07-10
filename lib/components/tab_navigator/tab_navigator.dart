import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/buttons/icon_button.dart';
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
      navigateTo(context, const MessagesHome());
    }

    void openWallet() {
      print("switching to wallet");
      navigateTo(context, const WalletHome());
    }

    return Container(
      padding: const EdgeInsets.all(AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: CustomIconButton(
              onTap: () {
                print(widget.index);
                openWallet();
              },
              icon: ThemeIcon.wallet,
              iconColor: (widget.index == 0)
                  ? ThemeColor.primary
                  : ThemeColor.textSecondary,
            ),
          ),
          const Spacing(width: AppPadding.navBar),
          Container(
            child: CustomIconButton(
              onTap: () {
                print(widget.index);
                openMessages();
              },
              icon: ThemeIcon.chat,
              iconColor: (widget.index == 1)
                  ? ThemeColor.primary
                  : ThemeColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
