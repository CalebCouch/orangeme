import 'package:flutter/material.dart';
import 'package:orange/components/message_bubble/message_bubble.dart';
import 'package:orange/components/contact_info/contact_info.dart';
import 'package:orange/components/message_info/message_info.dart';

class MessageStack extends StatelessWidget {
  final List<Contact> contacts;
  final List<Message> messages;

  const MessageStack({
    super.key,
    required this.messages,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    bool isGroup = false;
    if (contacts.length > 1) isGroup = true;
    return SizedBox(
      height: double.infinity,
      child: messages.isNotEmpty
          ? ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return MessageBubble(
                  isGroup: isGroup,
                  isReceived: messages[index].isReceived,
                  name: messages[index].contact.name,
                  text: messages[index].text,
                  time: messages[index].time,
                );
              },
            )
          : null,
    );
  }
}
