import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/bumper.dart';
import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/list_item.dart';

import 'package:orange/flows/messages/new_message/choose_recipient.dart';
import 'package:orange/flows/messages/conversation/exchange.dart';

import 'package:orange/classes.dart';

import 'package:flutter/services.dart';
import 'package:orange/util.dart';
import 'dart:io' show Platform;

// Provides an overview of user conversations with an option to start a new message,
// displaying a list of conversations or a prompt to begin messaging if none are present.

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

  bool onDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  createNewMessage() {
    navigateTo(
      context,
      ChooseRecipient(widget.globalState),
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      resizeToAvoidBottomInset: false,
      header: homeHeader(
        context,
        widget.globalState,
        "Messages",
        null,
      ),
      content: Content(
        scrollable: false,
        children: state.conversations.isEmpty
            ? [noMessages()]
            : [
                listConversations(state, widget.globalState),
              ],
      ),
      bumper: singleButtonBumper(
        context,
        "New Message",
        createNewMessage,
        true,
        ButtonVariant.primary,
        onDesktop ? true : false,
      ),
      navigationIndex: 1,
    );
  }
}

Widget noMessages() {
  return const Expanded(
    child: Center(
      child: CustomText(
        text: 'No messages yet.\nGet started by messaging a friend.',
        color: ThemeColor.textSecondary,
        textSize: TextSize.md,
      ),
    ),
  );
}

Widget listConversations(state, GlobalState globalState) {
  return Expanded(
    child: ListView.builder(
      itemCount: state.conversations.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return messageListItem(
          context,
          state.conversations[index],
          () {
            HapticFeedback.mediumImpact();
            navigateTo(
              context,
              Exchange(globalState, conversation: state.conversations[index]),
            );
          },
        );
      },
    ),
  );
}
