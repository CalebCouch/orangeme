import 'package:flutter/material.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/bumpers/bumper.dart';

class SingleButton extends StatelessWidget {
  final String text;

  final VoidCallback? onTap;

  const SingleButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultBumper(
      content: CustomButton(
        text: text,
        onTap: onTap,
      ),
    );
  }
}
