import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

//This Content widget serves as a reusable layout component for pages, providing
//consistent padding, maximum width, and optional scrolling for the main content.

class Content extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment alignment;
  final bool scrollable;

  const Content({
    super.key,
    required this.children,
    this.scrollable = true,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 396),
      padding: const EdgeInsets.all(AppPadding.content),
      width: MediaQuery.sizeOf(context).width,
      child: scrollable
          ? SingleChildScrollView(child: items(alignment, children))
          : items(alignment, children),
    );
  }
}

items(alignment, children) {
  return Column(
    mainAxisAlignment: alignment,
    spacing: AppPadding.content,
    children: children,
  );
}
