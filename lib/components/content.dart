import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

class Content extends StatelessWidget {
  final Widget content;
  final bool scrollable;

  const Content({
    super.key,
    required this.content,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 396),
      padding: const EdgeInsets.all(AppPadding.content),
      width: MediaQuery.sizeOf(context).width,
      child: scrollable
          ? SingleChildScrollView(
              child: content,
            )
          : content,
    );
  }
}
