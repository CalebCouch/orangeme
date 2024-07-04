import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class Header extends StatefulWidget {
  final Widget? left;
  final Widget center;
  final Widget? right;

  const Header({
    super.key,
    this.left,
    required this.center,
    this.right,
  });

  @override
  StatefulCustomHeaderState createState() => StatefulCustomHeaderState();
}

class StatefulCustomHeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      padding: AppPadding.headerInsetPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.left ?? Container(),
          Expanded(child: Center(child: widget.center)),
          widget.right ?? Container(),
        ],
      ),
    );
  }
}
