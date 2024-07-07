import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/buttons/icon_button.dart';
import 'package:orange/util.dart';

import 'package:orange/flows/wallet_flow/home.dart';
import 'package:orange/flows/messages_flow/home.dart';

class TabNav extends StatelessWidget {
  int index = 0;
  bool messagesEnabled = true;
  const TabNav({
    super.key,
    this.index,
    this.messagesEnable,
  });

  @override
  Widget build(BuildContext context) {
    void openWallet(int index) {
      //index 0
      print("index: $index");
      if (index == 1) {
        index = 0;
        messagesEnabled = false;
        navigateTo(context, const WalletHome());
      }
    }

    void openMessages(int index) {
      //index 1
      print("index: $index");
      if (index == 0) {
        index = 1;
        messagesEnabled = true;
        navigateTo(context, const MessagesHome());
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            icon: ThemeIcon.wallet,
            isEnabled: messagesEnabled ? false : true,
            onTap: () => openWallet(index),
          ),
          const Spacing(width: AppPadding.navBar),
          CustomIconButton(
            icon: ThemeIcon.chat,
            onTap: () => openMessages(index),
            isEnabled: messagesEnabled,
          ),
        ],
      ),
    );
  }
}
