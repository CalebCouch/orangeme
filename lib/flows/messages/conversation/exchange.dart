import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/messages/conversation/info.dart';

import 'package:orange/classes/test_classes.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/classes.dart';

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

  Widget build_screen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: stackMessageHeader(
        widget.globalState,
        context,
        widget.conversation.members,
        MessagesHome(widget.globalState),
        MessageInfo(
          widget.globalState,
          contacts: widget.conversation.members,
        ),
      ),
      content: Content(
        content: widget.conversation.messages == null
            ? const Center(
                child: CustomText(
                  text: 'No messages yet.',
                  textSize: TextSize.md,
                  color: ThemeColor.textSecondary,
                ),
              )
            : messageStack(context, widget.conversation.members,
                widget.conversation.messages!),
      ),
      bumper: messageInput(),
    );
  }
}
