import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/bumper.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/list_item.dart';

import 'package:orange/flows/messages/new_message/choose_recipient.dart';
import 'package:orange/flows/messages/conversation/exchange.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';

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
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    //print(state.users);
    return Interface(
      widget.globalState,
      header: homeHeader(
        context,
        widget.globalState,
        "Messages",
        state.personal.pfp,
      ),
      content: Content(
        content: state.conversations.isEmpty
            ? const Center(
                child: CustomText(
                  text: 'No messages yet.\nGet started by messaging a friend.',
                  color: ThemeColor.textSecondary,
                  textSize: TextSize.md,
                ),
              )
            : ListView.builder(
                itemCount: state.conversations.length,
                itemBuilder: (BuildContext context, int index) {
                  return messageListItem(
                    context,
                    state.conversations[index],
                    () {
                      navigateTo(
                        context,
                        Exchange(
                          widget.globalState,
                          conversation: state.conversations[index],
                        ),
                      );
                    },
                  );
                },
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
      navigationIndex: 1,
    );
  }
}
