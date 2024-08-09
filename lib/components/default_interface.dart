import 'package:flutter/material.dart';

class DefaultInterface extends StatelessWidget {
  final bool? resizeToAvoidBottomInset;
  final Widget header;
  final Widget content;
  final Widget? bumper;
  final Widget? navBar;

  const DefaultInterface({
    super.key,
    this.resizeToAvoidBottomInset,
    required this.header,
    required this.content,
    this.bumper,
    this.navBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: SafeArea(
          child: Column(
            children: [
              header,
              Expanded(child: content),
              if (bumper != null) bumper!,
              if (navBar != null) navBar!,
            ],
          ),
        ),
      ),
    );
  }
}

class DesktopInterface extends StatelessWidget {
  final bool? resizeToAvoidBottomInset;
  final Widget header;
  final Widget content;
  final Widget? bumper;
  final Widget? sidebar;

  const DesktopInterface({
    super.key,
    this.resizeToAvoidBottomInset,
    required this.header,
    required this.content,
    this.bumper,
    this.sidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: SafeArea(
            child: Row(
          children: [
            if(sidebar != null) sidebar!,
            Column(
              children: [
                header,
                Expanded(child: content),
                if (bumper != null) bumper!,
              ],
            ),
          ],
        )),
      ),
    );
  }
}
