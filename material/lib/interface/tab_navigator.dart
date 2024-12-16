import 'package:material/navigation.dart';
import 'package:material/material.dart';

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
    _TabNavState createState() => _TabNavState();
}

class _TabNavState extends State<TabNav> {
    void _openTab(int i) {
        HapticFeedback.heavyImpact();
        switchPageTo(context, widget.tabs[i].page);
    }

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: double.infinity,
            height: 64,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    widget.tabs.length,
                    (i) => _TabButton(i),
                ),
            ),
        );
    }

    Widget _TabButton(int i) {
        return Expanded(
            child: InkWell(
                onTap: () => widget.index != i ? _openTab(i) : null,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.navBar),
                    alignment: i == 0 ? Alignment.centerRight : Alignment.centerLeft,
                    child: CustomIcon(
                        icon: widget.tabs[i].icon,
                        size: 'lg',
                        color: widget.index == i ? 'secondary' : 'text_secondary',
                    ),
                ),
            ),
        );
    }
}
