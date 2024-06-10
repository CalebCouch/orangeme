import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/screens/social/social.dart';

class ModeNavigator extends StatefulWidget {
  final int navIndex;
  final VoidCallback onDashboardPopBack;

  const ModeNavigator(
      {super.key, required this.navIndex, required this.onDashboardPopBack});

  @override
  ModeNavigatorState createState() => ModeNavigatorState();
}

class ModeNavigatorState extends State<ModeNavigator> {
  void navigateWallet() {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Dashboard(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ));
  }

  void navigateSocial() {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SocialDashboard(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ));
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
            icon: widget.navIndex == 0
                ? SvgPicture.asset(
                    'assets/icons/Icon=wallet_filled.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.primary, BlendMode.srcIn),
                    width: 50,
                    height: 50,
                  )
                : SvgPicture.asset(
                    'assets/icons/Icon=wallet_filled.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.textSecondary, BlendMode.srcIn),
                    width: 50,
                    height: 50,
                  ),
            onPressed: () {
              if (widget.navIndex != 0) {
                navigateWallet();
              } else {
                return;
              }
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Icon=chat.svg',
              colorFilter: ColorFilter.mode(
                  widget.navIndex == 1
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  BlendMode.srcIn),
              width: 22,
              height: 22,
            ),
            onPressed: () {
              if (widget.navIndex != 1) {
                navigateSocial();
              } else {
                return;
              }
            },
          ),
        ],
      ),
    );
  }
}
