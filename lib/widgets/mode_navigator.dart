import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/screens/social/social.dart';

class ModeNavigator extends StatefulWidget {
  final int navIndex;
  final VoidCallback onDashboardPopBack;
  final VoidCallback stopTimer;

  const ModeNavigator(
      {super.key,
      required this.navIndex,
      required this.onDashboardPopBack,
      required this.stopTimer});

  @override
  ModeNavigatorState createState() => ModeNavigatorState();
}

class ModeNavigatorState extends State<ModeNavigator> {
  void navigateWallet() {
    widget.onDashboardPopBack();
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Dashboard(loading: true),
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ));
  }

  void navigateSocial() {
    widget.stopTimer();
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SocialDashboard(
            onDashboardPopBack: widget.onDashboardPopBack,
            stopTimer: widget.stopTimer,
          ),
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
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.wallet,
              colorFilter: ColorFilter.mode(
                  widget.navIndex == 0
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  BlendMode.srcIn),
              width: 32,
              height: 32,
            ),
            onPressed: () {
              if (widget.navIndex != 0) {
                navigateWallet();
              } else {
                return;
              }
            },
          ),
          const SizedBox(width: 64),
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.chat,
              colorFilter: ColorFilter.mode(
                  widget.navIndex == 1
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  BlendMode.srcIn),
              width: 32,
              height: 32,
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
