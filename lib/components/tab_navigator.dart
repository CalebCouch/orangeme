import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

class TabInfo {
  final Widget page;
  final String icon;

  const TabInfo(this.page, this.icon);
}

class TabNav extends StatefulWidget {
  final int index;
  final List<TabInfo> tabs;
  const TabNav(this.index, this.tabs, {super.key});
  @override
  State<TabNav> createState() => TabNavState();
}

class TabNavState extends State<TabNav> {
  @override
  Widget build(BuildContext context) {
    void openTabZero() {
      HapticFeedback.heavyImpact();
      switchPageTo(context, widget.tabs[0].page);
    }

    void openTabOne() {
      HapticFeedback.heavyImpact();
      switchPageTo(context, widget.tabs[1].page);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (widget.index != 0) openTabZero();
              },
              child: Container(
                padding: const EdgeInsets.only(right: AppPadding.navBar),
                alignment: Alignment.centerRight,
                child: CustomIcon('${widget.tabs[0].icon} lg ${(widget.index == 0) ? 'secondary' : 'text_secondary'}'),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (widget.index != 1) openTabOne();
              },
              child: Container(
                padding: const EdgeInsets.only(left: AppPadding.navBar),
                alignment: Alignment.centerLeft,
                child: CustomIcon('${widget.tabs[1].icon} lg ${(widget.index == 1) ? 'secondary' : 'text_secondary'}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
