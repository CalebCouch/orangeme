import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

class Content extends StatelessWidget {
  final Widget content;

  const Content({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 512),
      padding: const EdgeInsets.all(AppPadding.content),
      width: MediaQuery.sizeOf(context).width,
      child: content,
    );
  }
}
