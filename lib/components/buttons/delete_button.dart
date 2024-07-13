import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_icon.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const CustomIcon(
      icon: ThemeIcon.back,
      iconSize: IconSize.md,
      iconColor: ThemeColor.primary,
    );
  }
}
