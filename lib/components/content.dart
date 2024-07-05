import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  final List<Widget> content;
  final VoidCallback? onRefresh;
  const Content({
    super.key,
    this.onRefresh,
    required this.content,
  });
  @override
  StatefulCustomContentState createState() => StatefulCustomContentState();
}

class StatefulCustomContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    // Base content widget wrapped in a SingleChildScrollView
    Widget contentWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.content,
    ); // Optionally wrap the content widget with a RefreshIndicator
    if (widget.onRefresh != null) {
      contentWidget = RefreshIndicator(
        onRefresh: () async {
          widget.onRefresh!(); // Execute the provided callback
        },
        child: contentWidget,
      );
    } // Return the content widget, which is now conditionally wrapped with RefreshIndicator
    return Expanded(
      child: contentWidget,
    );
  }
}
