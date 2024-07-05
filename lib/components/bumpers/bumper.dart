import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

class DefaultBumper extends StatelessWidget {
  final Widget content;

  const DefaultBumper({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.bumper),
      width: MediaQuery.sizeOf(context).width,
      alignment: Alignment.center,
      child: content,
    );
  }
}
