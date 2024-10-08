import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';

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
    String displayName;
    if (state.personal.name.length > 12) {
      displayName = state.personal.name.split(" ")[0];
      if (displayName.length > 12) {
        displayName = displayName.substring(0, 10) + '...';
      }
    } else {
      displayName = state.personal.name;
    }

    OpenProfile() async {
      if (widget.index != 2) {
        var address = (await widget.globalState.invoke("get_new_address", "")).data;
        switchPageTo(
          context,
          MyProfile(
            widget.globalState,
            address,
            profilePhoto: state.personal.pfp,
          ),
        );
      }
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
          const Spacing(AppPadding.sidebar),
          buttonList(context, widget.globalState, widget.index),
          const Spacer(),
          CustomButton(displayName, 'ghost lg ${(widget.index == 2) ? 'selected' : 'enabled'} expand none', OpenProfile),
          //state.personal.pfp,
        ],
      ),
    );
  }
}

/* Creates a list of sidebar buttons for navigating to the different tabs. */
Widget buttonList(BuildContext context, GlobalState globalState, int index) {
  bitcoinPressed() {
    if (index != 0) switchPageTo(context, BitcoinHome(globalState));
    if (index == 0) resetNavTo(context, BitcoinHome(globalState));
  }

  messagesPressed() {
    if (index != 1) switchPageTo(context, MessagesHome(globalState));
    if (index == 1) resetNavTo(context, MessagesHome(globalState));
  }

  return CustomColumn([
    CustomButton('Bitcoin', 'ghost lg ${(index == 0) ? 'selected' : 'enabled'} expand wallet', bitcoinPressed),
    CustomButton('Messages', 'ghost lg ${(index == 1) ? 'selected' : 'enabled'} expand message', messagesPressed),
  ], AppPadding.buttonList);
}
