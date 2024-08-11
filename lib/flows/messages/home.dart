import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/bumper.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/list_item.dart';

import 'package:orange/classes/message_info.dart';
import 'package:orange/classes/contact_info.dart';

import 'package:orange/flows/messages/new_message/choose_recipient.dart';
import 'package:orange/flows/messages/conversation/conversation.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class MessagesHome extends StatefulWidget {
  final GlobalState globalState;
  const MessagesHome({
    required this.globalState,
    super.key,
  });

  @override
  MessagesHomeState createState() => MessagesHomeState();
}

class MessagesHomeState extends State<MessagesHome> {
  List<Message> testMessages = [
    const Message(
      'totally. that makes sense',
      true,
      '12:21 PM',
      [Contact('Ann Davidson', null, 'ta3Th1Omn...')],
    ),
    const Message(
      'Only so much though',
      false,
      '12:21 PM',
      [Contact('James', null, 'ta3Th1Omn...')],
    ),
    const Message(
      'tuesday?',
      true,
      '12:21 PM',
      [
        Contact('Barbara B', null, 'ta3Th1Omn...'),
        Contact('Cam', null, 'ta3Th1Omn...'),
        Contact('Rita Jones', null, 'ta3Th1Omn...')
      ],
    ),
    const Message(
      'tuesday?',
      true,
      '12:21 PM',
      [Contact('Barbara B', null, 'ta3Th1Omn...')],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Interface(
      header: messagesHeader(
        context,
        () {
          navigateTo(
            context,
            const MyProfile(),
          );
        },
        null,
      ),
      content: Content(
        scrollable: true,
        content: testMessages.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                reverse: true,
                physics: const ScrollPhysics(),
                itemCount: testMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  return messageListItem(
                    context,
                    testMessages[index],
                    () {
                      navigateTo(context,
                          Conversation(contacts: testMessages[index].contacts));
                    },
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
      bumper: singleButtonBumper(
        context,
        "New Message",
        () {
          navigateTo(
            context,
            const ChooseRecipient(),
          );
        },
      ),
      globalState: widget.globalState,
      navigationIndex: 2,
    );
  }
}
