import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
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
    return SizedBox(
      height: 48,
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            child: left,
          ),
          Container(
            alignment: Alignment.center,
            child: center,
          ),
          Container(
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: right,
          ),
        ],
      ),
    );
  }
}
