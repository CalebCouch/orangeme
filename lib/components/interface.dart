import 'package:flutter/material.dart';

class Interface extends StatefulWidget {
  final Widget header;
  final Widget content;
  final Widget bumper;
  final Widget? navBar;

  const Interface({
    super.key,
    required this.header,
    required this.content,
    required this.bumper,
    this.navBar,
  });

  @override
  StatefulCustomInterfaceState createState() => StatefulCustomInterfaceState();
}

class StatefulCustomInterfaceState extends State<Interface> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.header,
            widget.content,
            widget.bumper,
            if (widget.navBar != null) widget.navBar!,
          ],
        ),
      ),
    );
  }
}
