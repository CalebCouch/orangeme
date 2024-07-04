import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  final List<Widget> content;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.content,
    );
  }
}
