import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_message_header.dart';
import 'package:orange/components/bumpers/message_bumper.dart';
import 'package:orange/components/contact_info/contact_info.dart';
import 'package:orange/components/message_info/message_info.dart';
import 'package:orange/components/message_bubble/message_stack.dart';

class NewConversation extends StatefulWidget {
  const NewConversation({
    super.key,
  });

  @override
  NewConversationState createState() => NewConversationState();
}

class NewConversationState extends State<NewConversation> {
  List<Contact> contacts = [
    const Contact('Stacy', ThemeIcon.profile, 'a938ixOh2R...'),
  ];
  Contact myInfo =
      const Contact('Ella Couch', ThemeIcon.profile, 'gs3xToh8r...');
  List<Message> messages = [];
  _getMessages() {
    messages.add(Message('what\'s up?', true, '11:23 PM', contacts[0]));
    messages.add(
        Message('Nothing much, how are you?', false, '11:23 PM', contacts[0]));
    messages.add(Message(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a mauris elementum, mollis erat sed',
        true,
        '11:23 PM',
        contacts[0]));
    messages.add(Message(
        'cool. We should catch up soon', false, '11:23 PM', contacts[0]));
    messages
        .add(Message('yes, that would be fun', true, '11:23 PM', contacts[0]));
    messages.add(Message('tuesday?', true, '11:23 PM', contacts[0]));
  }

  @override
  Widget build(BuildContext context) {
    _getMessages();
    return DefaultInterface(
      header: StackMessageHeader(
        name: contacts[0].name,
        profilePhoto: contacts[0].photo,
      ),
      content: Content(
        content: MessageStack(contacts: contacts, messages: messages),
      ),
      bumper: const MessageBumper(),
    );
  }
}
