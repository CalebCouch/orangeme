import 'package:flutter/material.dart';
import 'package:orange/flows/messages_flow/direct_message_flow/group_message_info.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/contact_info.dart';
import 'package:orange/classes/single_message.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/classes.dart';

class Conversation extends StatefulWidget {
  final List<Contact> contacts;
  final GlobalState globalState;
  const Conversation(
    this.globalState, {
    this.contacts = const [Contact('JOHN', null, 'a938ixOh2R...')],
    super.key,
  });

  @override
  ConversationState createState() => ConversationState();
}

class ConversationState extends State<Conversation> {
  Contact myInfo = const Contact('Ella', null, 'gs3xToh8r...');
  List<SingleMessage> messages = [];
  _getMessages() {
    messages.add(
        SingleMessage('what\'s up?', true, '11:19 PM', widget.contacts[0]));
    messages.add(
        SingleMessage('Nothing much, how are you?', false, '11:23 PM', myInfo));
    messages.add(SingleMessage(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a mauris elementum, mollis erat sed',
        true,
        '11:23 PM',
        widget.contacts[0]));
    messages.add(SingleMessage(
        'cool. We should catch up soon', false, '11:23 PM', myInfo));
    messages.add(SingleMessage(
        'yes, that would be fun', true, '11:23 PM', widget.contacts[0]));
    messages
        .add(SingleMessage('tuesday?', true, '11:23 PM', widget.contacts[0]));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  buildScreen(BuildContext context, DartState state) {
    _getMessages();
    return DefaultInterface(
      header: stackMessageHeader(
          context, widget.contacts, GroupMessageInfo(widget.globalState)),
      content: Content(
        content: messages.isEmpty
            ? const Center(
                child: CustomText(
                  text: 'No messages yet.',
                  textSize: TextSize.md,
                  color: ThemeColor.textSecondary,
                ),
              )
            : messageStack(context, widget.contacts, messages),
      ),
      bumper: messageInput(),
    );
  }
}
