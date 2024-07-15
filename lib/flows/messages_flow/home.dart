import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/bumpers/single_button_bumper.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/messages_header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/list_item/message_list_item.dart';
import 'package:orange/components/tab_navigator/tab_navigator.dart';

import 'package:orange/classes/message_info.dart';
import 'package:orange/classes/contact_info.dart';

import 'package:orange/flows/messages_flow/new_message_flow/choose_recipient.dart';
import 'package:orange/flows/messages_flow/direct_message_flow/conversation.dart';
import 'package:orange/flows/messages_flow/profile_flows/my_profile.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

//  class GenericWidget extends StatefulWidget {
//    final GlobalState globalState;
//    const GenericWidget({
//      required this.globalState,
//      super.key,
//    });

//    @override
//    GenericWidgetState createState() => GenericWidgetState();
//  }

//  class GenericWidgetState extends State<GenericWidget> {
//    GenericWidgetState()
//    @override
//    Widget build(BuildContext context) {
//      return ;
//    }
//  }

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
    return DefaultInterface(
      header: MessagesHeader(
        onTap: () {
          navigateTo(
            context,
            const MyProfile(),
          );
        },
        profilePhoto: null,
      ),
      content: Content(
        content: testMessages.isNotEmpty
            ? ListView.builder(
                itemCount: testMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageListItem(
                    message: testMessages[index],
                    onTap: () {
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
      bumper: SingleButton(
          text: "New Message",
          onTap: () {
            navigateTo(context, const ChooseRecipient());
          }),
      navBar: TabNav(globalState: widget.globalState, index: 1),
    );
  }
}
