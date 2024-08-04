import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/classes.dart';

class MessageExchange extends StatefulWidget {
  final GlobalState globalState;
  final Conversation conversation;
  const MessageExchange(
    this.globalState,
    this.conversation, {
    super.key,
  });

  @override
  MessageExchangeState createState() => MessageExchangeState();
}

class MessageExchangeState extends State<MessageExchange> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return DefaultInterface(
      header:
          stackMessageHeader(widget.globalState, context, widget.conversation),
      content: Content(
        content: widget.conversation.messages.isEmpty
            ? const Center(
                child: CustomText(
                  text: 'No messages yet.',
                  textSize: TextSize.md,
                  color: ThemeColor.textSecondary,
                ),
              )
            : messageStack(context, widget.conversation.members,
                widget.conversation.messages),
      ),
      bumper: messageInput(),
    );
  }
}
