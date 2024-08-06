import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/bumper.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/tab_navigator.dart';

import 'package:orange/classes/test_classes.dart';

import 'package:orange/flows/messages/new_message/choose_recipient.dart';
import 'package:orange/flows/messages/conversation/exchange.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class MessagesHome extends StatefulWidget {
  final GlobalState globalState;
  final Conversation? newConversation;
  const MessagesHome(
    this.globalState, {
    super.key,
    this.newConversation,
  });

  @override
  MessagesHomeState createState() => MessagesHomeState();
}

class MessagesHomeState extends State<MessagesHome> {
  List<Conversation> testConversations = [
    const Conversation([
      Contact('Chris Slaughter', 'ta3Th1Omn...', null, null)
    ], [
      Message(Contact('Chris Slaughter', 'ta3Th1Omn...', null, null),
          'totally. that makes sense', '8/5/24', '12:21 PM', true)
    ])
  ];

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
    if (widget.newConversation != null) {
      testConversations.add(widget.newConversation!);
    }
    return DefaultInterface(
      header: primaryHeader(context, null, 'Messages'),
      content: Content(
        content: testConversations.isNotEmpty
            ? ListView.builder(
                itemCount: testConversations.length,
                itemBuilder: (BuildContext context, int index) {
                  return messageListItem(
                    context,
                    testConversations[index],
                    () {
                      navigateTo(
                        context,
                        Exchange(
                          conversation: testConversations[index],
                        ),
                      );
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
            ChooseRecipient(widget.globalState),
          );
        },
      ),
      navBar: TabNav(globalState: widget.globalState, index: 1),
    );
  }
}
