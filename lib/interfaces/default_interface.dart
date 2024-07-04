import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

class DefaultInterface extends StatelessWidget {
  final Widget header;
  final Widget content;
  final Widget? bumper;
  final Widget? navBar;

  const DefaultInterface({
    super.key,
    required this.header,
    required this.content,
    this.bumper,
    this.navBar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppPadding.header),
            child: header,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppPadding.content),
            child: content,
          ),
          const Spacer(),
          Container(
            child: bumper,
          ),
          // ignore: sized_box_for_whitespace
          Container(
            width: double.infinity,
            child: navBar,
          ),
        ],
      ),
    );
  }
}
