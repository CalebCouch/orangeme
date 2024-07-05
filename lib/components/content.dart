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
    // Use a Column to layout the content widgets. Each child should handle its own overflow.
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.content,
      ),
    );
  }
}
