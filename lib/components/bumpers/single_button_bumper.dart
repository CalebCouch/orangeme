import 'package:flutter/material.dart';

import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/bumpers/bumper.dart';

class SingleButton extends StatelessWidget {
  final String text;
  final String variant;

  final VoidCallback? onTap;

  const SingleButton({
    super.key,
    required this.text,
    required this.onTap,
    this.variant = ButtonVariant.bitcoin,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultBumper(
      content: CustomButton(
        variant: variant,
        text: text,
        onTap: onTap,
      ),
    );
  }
}
