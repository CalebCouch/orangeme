import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/classes.dart';

// Provides a chat interface for viewing and sending messages within a conversation.

class Exchange extends StatefulWidget {
  final GlobalState globalState;
  final Conversation conversation;
  const Exchange(
    this.globalState, {
    required this.conversation,
    super.key,
  });

  @override
  ExchangeState createState() => ExchangeState();
}

class ExchangeState extends State<Exchange> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    super.initState();
  }

  _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  Widget build_screen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: stackMessageHeader(
        widget.globalState,
        context,
        widget.conversation,
      ),
      content: Content(
        scrollable: false,
        children: [
          widget.conversation.messages.isEmpty
              ? noMessages()
              : Expanded(
                  child: messageStack(
                      widget.globalState,
                      context,
                      scrollController,
                      widget.conversation.members,
                      widget.conversation.messages),
                ),
        ],
      ),
      bumper: messageInput(),
      desktopOnly: true,
      navigationIndex: 1,
    );
  }
}

Widget noMessages() {
  return const Center(
    child: CustomText(
      text: 'No messages yet.',
      textSize: TextSize.md,
      color: ThemeColor.textSecondary,
    ),
  );
}
