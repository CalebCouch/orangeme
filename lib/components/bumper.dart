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
      constraints: BoxConstraints(maxWidth: 512),
      padding: const EdgeInsets.all(AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      alignment: Alignment.center,
      child: content,
    );
  }
}

Widget singleButtonBumper(BuildContext context, String text, onTap,
    [bool isEnabled = true, variant]) {
  return DefaultBumper(
    content: CustomButton(
      variant: variant ?? ButtonVariant.bitcoin,
      text: text,
      onTap: onTap,
      status: isEnabled ? 0 : 2,
    ),
  );
}

Widget doubleButtonBumper(BuildContext context, String text, String secondText,
    onTapFirst, onTapSecond) {
  return DefaultBumper(
    content: Row(
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
  );
}
