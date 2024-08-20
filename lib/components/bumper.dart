import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/custom/custom_button.dart';

class DefaultBumper extends StatelessWidget {
  final Widget content;
  const DefaultBumper({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 396),
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      alignment: Alignment.center,
      child: content,
    );
  }
}

Widget singleButtonBumper(BuildContext context, String text, onTap,
    [bool isEnabled = true, variant, bool padding = true]) {
  return DefaultBumper(
    content: Container(
      padding: padding
          ? const EdgeInsets.symmetric(vertical: AppPadding.bumper)
          : null,
      child: CustomButton(
        variant: variant ?? ButtonVariant.primary,
        text: text,
        onTap: onTap,
        status: isEnabled ? 0 : 2,
      ),
    ),
  );
}

Widget doubleButtonBumper(BuildContext context, String text, String secondText,
    onTapFirst, onTapSecond,
    [bool padding = true]) {
  return DefaultBumper(
    content: Container(
      padding: padding
          ? const EdgeInsets.symmetric(vertical: AppPadding.bumper)
          : null,
      child: Row(
        children: [
          Flexible(
            child: CustomButton(
              text: text,
              onTap: onTapFirst,
            ),
          ),
          const Spacing(width: AppPadding.bumper),
          Flexible(
            child: CustomButton(
              text: secondText,
              onTap: onTapSecond,
            ),
          ),
        ],
      ),
    ),
  );
}
