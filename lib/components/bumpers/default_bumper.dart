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
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(AppPadding.bumper),
      alignment: Alignment.center,
      child: content,
    );
  }
}
