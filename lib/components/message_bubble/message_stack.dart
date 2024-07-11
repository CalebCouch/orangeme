import 'package:flutter/material.dart';
import 'package:orange/components/message_bubble/message_bubble.dart';
import 'package:orange/classes/contact_info.dart';
import 'package:orange/classes/single_message.dart';

class MessageStack extends StatelessWidget {
  final List<Contact> contacts;
  final List<SingleMessage> messages;

  const MessageStack({
    super.key,
    required this.messages,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    var isGroup = false;
    if (contacts.length > 1) isGroup = true;
    return SizedBox(
        height: double.infinity,
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return MessageBubble(
              previousMessage: index >= 1 ? messages[index - 1] : null,
              nextMessage:
                  index < (messages.length - 1) ? messages[index + 1] : null,
              isGroup: isGroup,
              message: messages[index],
            );
          },
        ));
  }
}
