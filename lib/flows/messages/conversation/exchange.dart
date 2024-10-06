import 'package:flutter/material.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';

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
    return Stack_Chat(
      Header_Message(context, "Confirm send"), //widget.conversation,
      [
        widget.conversation.messages.isEmpty,
        messageStack(widget.globalState, context, scrollController, widget.conversation.members, widget.conversation.messages)
      ],
      Bumper([MessageInput()]),
    );
  }
}

Widget MessageInput() {
  return Container(
    padding: const EdgeInsets.only(bottom: 16, top: 8),
    child: const CustomTextInput(
      hint: 'Message',
      showIcon: true,
    ),
  );
}
