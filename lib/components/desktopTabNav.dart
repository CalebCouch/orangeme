import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/wallet/home.dart';
import 'package:orange/flows/messages/home.dart';

const String walletIconString = 'wallet';
const String chatIconString = 'chat';

class DesktopTabNav extends StatefulWidget {
  final GlobalState globalState;
  final int initialIndex;

  const DesktopTabNav({
    required this.globalState,
    this.initialIndex = 0,
    super.key,
  });

  @override
  State<DesktopTabNav> createState() => _SidebarState();
}

class _SidebarState extends State<DesktopTabNav> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    switch (index) {
      case 0:
        page = WalletHome(widget.globalState);
        break;
      case 1:
        page = MessagesHome(globalState: widget.globalState);
        break;
      default:
        page = WalletHome(widget.globalState);
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 0),
      ),
    );
  }

  Widget _buildTab({
    required String icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        color: isSelected ? Colors.grey[800] : Colors.black,
        child: ListTile(
          leading: CustomIcon(
            icon: icon,
            iconSize: IconSize.md,
            iconColor:
                isSelected ? ThemeColor.primary : ThemeColor.textSecondary,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: isSelected ? ThemeColor.primary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
        // Remove the border property to eliminate the white bar
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.black,
            width: double.infinity,
            child: const Text(
              'DesktopTabNav',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildTab(
                  icon: walletIconString,
                  label: 'Wallet',
                  index: 0,
                ),
                _buildTab(
                  icon: chatIconString,
                  label: 'Messages',
                  index: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
