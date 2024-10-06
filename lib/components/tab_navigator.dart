import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orangeme_material/orangeme_material.dart';

// Creates a tab navigation bar with icons for switching between the different
// tabs, providing visual feedback and navigation functionality.

class TabNav extends StatefulWidget {
  final int index;
  final GlobalState globalState;
  const TabNav(this.globalState, this.index, {super.key});
  @override
  State<TabNav> createState() => TabNavState();
}

class TabNavState extends State<TabNav> {
  @override
  Widget build(BuildContext context) {
    void openMessages() {
      HapticFeedback.heavyImpact();
      switchPageTo(context, MessagesHome(widget.globalState));
    }

    void openBitcoin() {
      HapticFeedback.heavyImpact();
      switchPageTo(context, BitcoinHome(widget.globalState));
    }

    return SizedBox(
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
                padding: const EdgeInsets.only(right: AppPadding.navBar),
                alignment: Alignment.centerRight,
                child: CustomIcon('wallet md ${(widget.index == 0) ? 'secondary' : 'text_secondary'}'),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (widget.index == 0) openMessages();
              },
              child: Container(
                padding: const EdgeInsets.only(left: AppPadding.navBar),
                alignment: Alignment.centerLeft,
                child: CustomIcon('message md ${(widget.index == 1) ? 'secondary' : 'text_secondary'}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
