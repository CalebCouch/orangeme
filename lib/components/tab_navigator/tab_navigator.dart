import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/buttons/icon_button.dart';

class TabNav extends StatelessWidget {
  const TabNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            icon: ThemeIcon.wallet,
          ),
          Spacing(width: AppPadding.navBar),
          CustomIconButton(
            icon: ThemeIcon.chat,
            isEnabled: false,
          ),
        ],
      ),
    );
  }
}
