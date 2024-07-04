import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class Content extends StatefulWidget {
  final Widget content;

  const Content({
    super.key,
    required this.content,
  });

  @override
  StatefulCustomContentState createState() => StatefulCustomContentState();
}

class StatefulCustomContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.bumperInsetPadding,
      alignment: Alignment.center,
      child: widget.content,
    );
  }
}
