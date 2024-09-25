import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';

import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

// Provides a sidebar navigation component for desktop with options for
// switching between different sections and a user profile button.

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
    var displayName;
    if (state.personal.name.length > 12) {
      displayName = state.personal.name.split(" ")[0];
      if (displayName.length > 12) {
        displayName = displayName.substring(0, 10) + '...';
      }
    } else {
      displayName = state.personal.name;
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
          buttonList(context, widget.globalState, widget.index),
          const Spacer(),
          CustomButton(
            expand: true,
            text: displayName,
            buttonAlignment: Alignment.centerLeft,
            onTap: () async {
              if (widget.index != 2) {
                var address =
                    (await widget.globalState.invoke("get_new_address", ""))
                        .data;
                switchPageTo(
                  context,
                  MyProfile(
                    widget.globalState,
                    address,
                    profilePhoto: state.personal.pfp,
                  ),
                );
              }
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

/* Creates a list of sidebar buttons for navigating to the different tabs. */
Widget buttonList(BuildContext context, GlobalState globalState, int index) {
  return Column(
    children: [
      CustomButton(
        expand: true,
        text: 'Bitcoin',
        buttonAlignment: Alignment.centerLeft,
        onTap: () {
          if (index != 0) switchPageTo(context, BitcoinHome(globalState));
          if (index == 0) resetNavTo(context, BitcoinHome(globalState));
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
          if (index != 1) switchPageTo(context, MessagesHome(globalState));
          if (index == 1) resetNavTo(context, MessagesHome(globalState));
        },
        icon: ThemeIcon.chat,
        status: (index == 1) ? 3 : 0,
      ),
    ],
  );
}
