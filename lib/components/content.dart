import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

//This Content widget serves as a reusable layout component for pages, providing
//consistent padding, maximum width, and optional scrolling for the main content.

class Content extends StatelessWidget {
  final Widget content;
  final bool scrollable;

  const Content({
    super.key,
    required this.content,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 396),
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
