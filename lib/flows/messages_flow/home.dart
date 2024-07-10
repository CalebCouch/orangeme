import 'package:flutter/material.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';

import 'package:orange/components/interfaces/default_interface.dart';

import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/messages_header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/list_item/message_list_item.dart';

import 'package:orange/flows/messages_flow/new_message_flow/choose_recipient.dart';

import 'package:orange/components/tab_navigator/tab_navigator.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/util.dart';

class Message {
  final bool isReceived;
  final String name;
  final String time;
  final String message;
  final String photo;

  const Message(
      this.isReceived, this.time, this.name, this.message, this.photo);
}

class MessagesHome extends StatefulWidget {
  const MessagesHome({
    super.key,
  });

  @override
  MessagesHomeState createState() => MessagesHomeState();
}

class MessagesHomeState extends State<MessagesHome> {
  List<Message> testMessages = [
    const Message(
      true,
      '12:21 PM',
      'Ann Davidson',
      'totally. that makes sense',
      ThemeIcon.profile,
    ),
    const Message(
      false,
      '1:34 PM',
      'James',
      'Probably not, but ok',
      ThemeIcon.profile,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const MessagesHeader(
        profilePhoto: ThemeIcon.profile,
      ),
      content: Content(
        content: testMessages.isNotEmpty
            ? ListView.builder(
                itemCount: testMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageListItem(
                    isReceived: testMessages[index].isReceived,
                    profilePhoto: testMessages[index].photo,
                    name: testMessages[index].name,
                    recentMessage: testMessages[index].message,
                  );
                },
              )
            : const Center(
                child: CustomText(
                  text: 'No messages yet.\nGet started by messaging a friend.',
                  color: ThemeColor.textSecondary,
                  textSize: TextSize.md,
                ),
              ),
      ),
      bumper: SingleButton(
          text: "New Message",
          onTap: () {
            navigateTo(context, const ChooseRecipient());
          }),
      navBar: const TabNav(index: 1),
    );
  }
}
