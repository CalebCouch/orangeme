import 'package:flutter/material.dart';
//import 'package:orange/styles/stylesheet.dart';

class DefaultHeader extends StatelessWidget {
  final Widget? left;
  final Widget center;
  final Widget? right;

  const DefaultHeader({
    super.key,
    this.left,
    required this.center,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        alignment: Alignment.centerLeft,
        child: left,
      ),
      Container(
        alignment: Alignment.center,
        child: center,
      ),
      Container(
        alignment: Alignment.centerRight,
        child: right,
      ),
    ]);
  }
}
