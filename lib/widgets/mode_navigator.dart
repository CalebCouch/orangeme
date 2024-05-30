import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/styles/constants.dart';

class ModeNavigator extends StatefulWidget {
  const ModeNavigator({super.key});

  @override
  ModeNavigatorState createState() => ModeNavigatorState();
}

class ModeNavigatorState extends State<ModeNavigator> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 80),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: _selectedIndex == 0
                ? SvgPicture.asset(
                    'assets/icons/Icon=wallet_filled.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.orange, BlendMode.srcIn),
                    width: 50,
                    height: 50,
                  )
                : SvgPicture.asset(
                    'assets/icons/Icon=wallet_filled.svg',
                    colorFilter:
                        const ColorFilter.mode(AppColors.grey, BlendMode.srcIn),
                    width: 50,
                    height: 50,
                  ),
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Icon=chat.svg',
              colorFilter: ColorFilter.mode(
                  _selectedIndex == 1 ? AppColors.orange : AppColors.grey,
                  BlendMode.srcIn),
              width: 22,
              height: 22,
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
        ],
      ),
    );
  }
}
