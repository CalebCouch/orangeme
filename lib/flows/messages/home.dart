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
import 'package:orange/flows/messages/conversation/room.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

class MessagesHome extends StatefulWidget {
  final GlobalState globalState;
  const MessagesHome(
    this.globalState, {
    super.key,
  });

  @override
  MessagesHomeState createState() => MessagesHomeState();
}

class MessagesHomeState extends State<MessagesHome> {
  List<Conversation> testConversations = [
    const Conversation(
      [
        Contact('Chris Slaughter', 'ta3Th1Omn...',
            'assets/images/chrisSlaughter.png', null)
      ],
      [
        Message(
            Contact('Chris Slaughter', 'ta3Th1Omn...', null, null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:21 PM',
            true),
        Message(
            Contact('Chris Slaughter', 'ta3Th1Omn...', null, null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:21 PM',
            true),
        Message(
            Contact('Chris Slaughter', 'ta3Th1Omn...', null, null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:21 PM',
            false),
        Message(
            Contact('Chris Slaughter', 'ta3Th1Omn...', null, null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:21 PM',
            true),
      ],
    ),
    const Conversation(
      [
        Contact('Josh Thayer', 'ta3Th1Omn...', 'assets/images/joshThayer.png',
            null),
        Contact('Chris Slaughter', 'astakxec...',
            'assets/images/chrisSlaughter.png', null)
      ],
      [
        Message(
            Contact('Josh Thayer', 'ta3Th1Omn...',
                'assets/images/joshThayer.png', null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:21 PM',
            true),
        Message(
            Contact('Chris Slaughter', 'ta3Th1Omn...',
                'assets/images/chrisSlaughter.png', null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:21 PM',
            true),
        Message(
            Contact('Josh Thayer', 'ta3Th1Omn...',
                'assets/images/joshThayer.png', null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:21 PM',
            true)
      ],
      Info(
        null,
        null,
        null,
        Contact('Josh Thayer', 'unknown', 'assets/images/joshThayer.png', null),
        '8/5/24',
        [
          Contact('Josh Thayer', 'ta3Th1Omn...', 'assets/images/joshThayer.png',
              null),
          Contact('Chris Slaughter', 'astakxec...',
              'assets/images/chrisSlaughter.png', null)
        ],
      ),
    ),
    const Conversation(
      [
        Contact('Chris Slaughter', 'ta3Th1Omn...',
            'assets/images/chrisSlaughter.png', null),
        Contact('Josh Thayer', 'ta3Th1Omn...', 'assets/images/joshThayer.png',
            null),
        Contact('Ella Couch', 'ta3Th1Omn...', null, null)
      ],
      [
        Message(
            Contact('Josh Thayer', 'ta3Th1Omn...',
                'assets/images/joshThayer.png', null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:21 PM',
            true),
        Message(
            Contact('Chris Slaughter', 'ta3Th1Omn...',
                'assets/images/chrisSlaughter.png', null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:23 PM',
            true),
        Message(
            Contact('Me', 'ta3Th1Omn...', null, null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:24 PM',
            false),
        Message(
            Contact('Ella Couch', 'ta3Th1Omn...', null, null),
            'totally. that makes sense. More text. I need even more text. I need it to wrap down. Then it needs to cut off with elipses',
            '8/5/24',
            '12:27 PM',
            true),
      ],
    ),
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
    return DefaultInterface(
      header: primaryHeader(context, null, 'Messages'),
      content: Content(
        content: testConversations.isNotEmpty
            ? ListView.builder(
                itemCount: testConversations.length,
                itemBuilder: (BuildContext context, int index) {
                  if (testConversations[index].info != null) {
                    return messageListItem(
                      context,
                      testConversations[index],
                      () {
                        print("room");
                        navigateTo(
                          context,
                          Room(
                            widget.globalState,
                            conversation: testConversations[index],
                          ),
                        );
                      },
                      testConversations[index].info,
                    );
                  } else {
                    return messageListItem(
                      context,
                      testConversations[index],
                      () {
                        print("nav");
                        navigateTo(
                          context,
                          Exchange(
                            widget.globalState,
                            conversation: testConversations[index],
                          ),
                        );
                      },
                    );
                  }
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
