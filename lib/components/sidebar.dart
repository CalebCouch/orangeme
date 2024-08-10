import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/wallet/home.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/savings/set_up/get_mobile.dart';

class Sidebar extends StatefulWidget {
  final int index;
  final GlobalState globalState;
  const Sidebar(this.globalState, {required this.index, super.key});
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
      switchPageTo(context, MobileSetUp(widget.globalState));
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.sidebar,
        horizontal: AppPadding.sidebar / 2,
      ),
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            Brand.logomark,
            height: BrandSize.xl,
          ),
          const Spacing(height: AppPadding.sidebar),
          CustomButton(
            expand: true,
            text: 'Wallet',
            buttonAlignment: Alignment.centerLeft,
            onTap: () {
              if (widget.index != 0) openWallet();
            },
            icon: ThemeIcon.wallet,
            variant: ButtonVariant.ghost,
            status: (widget.index == 0) ? 3 : 0,
          ),
          const Spacing(height: AppPadding.buttonList),
          CustomButton(
            variant: ButtonVariant.ghost,
            expand: true,
            text: 'Savings',
            buttonAlignment: Alignment.centerLeft,
            onTap: () {
              if (widget.index != 1) openSavings();
            },
            icon: ThemeIcon.savings,
            status: (widget.index == 1) ? 3 : 0,
          ),
          const Spacing(height: AppPadding.buttonList),
          CustomButton(
            variant: ButtonVariant.ghost,
            buttonAlignment: Alignment.centerLeft,
            expand: true,
            text: 'Messages',
            onTap: () {
              if (widget.index != 2) openMessages();
            },
            icon: ThemeIcon.chat,
            status: (widget.index == 2) ? 3 : 0,
          ),
        ],
      ),
    );
  }
}
