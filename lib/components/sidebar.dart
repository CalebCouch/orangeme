import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/wallet/home.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';

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
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    var splitName = state.personal.name.split(" ");
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
          buttonList(context, widget.globalState, widget.index),
          const Spacer(),
          CustomButton(
            expand: true,
            text: splitName[0],
            buttonAlignment: Alignment.centerLeft,
            onTap: () {
              if (widget.index != 2) {
                switchPageTo(
                  context,
                  MyProfile(widget.globalState,
                      profilePhoto: state.personal.pfp),
                );
              }
              ;
            },
            pfp: state.personal.pfp,
            variant: ButtonVariant.ghost,
            status: (widget.index == 2) ? 3 : 0,
          ),
        ],
      ),
    );
  }
}

void openMessages(BuildContext context, GlobalState globalState) {
  print("switching to messages");
  switchPageTo(context, MessagesHome(globalState));
}

void openWallet(BuildContext context, GlobalState globalState) {
  print("switching to wallet");
  switchPageTo(context, WalletHome(globalState));
}

Widget buttonList(BuildContext context, GlobalState globalState, int index) {
  return Column(
    children: [
      CustomButton(
        expand: true,
        text: 'Wallet',
        buttonAlignment: Alignment.centerLeft,
        onTap: () {
          if (index != 0) openWallet(context, globalState);
        },
        icon: ThemeIcon.wallet,
        variant: ButtonVariant.ghost,
        status: (index == 0) ? 3 : 0,
      ),
      const Spacing(height: AppPadding.buttonList),
      CustomButton(
        variant: ButtonVariant.ghost,
        buttonAlignment: Alignment.centerLeft,
        expand: true,
        text: 'Messages',
        onTap: () {
          if (index != 1) openMessages(context, globalState);
        },
        icon: ThemeIcon.chat,
        status: (index == 1) ? 3 : 0,
      ),
    ],
  );
}
