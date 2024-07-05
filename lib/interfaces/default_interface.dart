import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: SafeArea(
          child: Column(
            children: [
              header,
              content,
              const Spacer(),
              if (bumper != null) bumper!,
              if (navBar != null) navBar!,
            ],
          ),
        ),
      ),
    );
  }
}
