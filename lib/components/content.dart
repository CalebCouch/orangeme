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
    return Expanded(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.content,
          ),
          if (widget.onRefresh != null)
            Positioned.fill(
              child: RefreshIndicator(
                onRefresh: () async {
                  widget.onRefresh!(); // Execute the provided callback
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
