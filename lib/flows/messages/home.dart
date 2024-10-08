import 'package:flutter/material.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/list_item.dart';

import 'package:orange/flows/messages/new_message/choose_recipient.dart';
import 'package:orange/flows/messages/conversation/exchange.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';
import 'dart:io' show Platform;

import 'package:orangeme_material/orangeme_material.dart';

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

  toProfile() async {
    var address = (await widget.globalState.invoke("get_new_address", "")).data;
    navigateTo(context, MyProfile(widget.globalState, address));
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return Root_Home(
      Header_Home(ProfileButton(context, state.personal.pfp, toProfile), "Messages"),
      [listConversations(state, widget.globalState)],
      Bumper(context, [CustomButton('New Message', 'primary lg enabled expand none', createNewMessage)]),
      TabNav(widget.globalState, 1),
    );
  }

//state.conversations.isEmpty ? [noMessages()] :

  Widget noMessages() {
    return const Expanded(
      child: Center(
        child: CustomText('text md text_secondary', 'No messages yet.\nGet started by messaging a friend.'),
      ),
    );
  }

  Widget listConversations(state, GlobalState globalState) {
    List<Conversation> conversations = state.conversations;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.conversations.length,
      itemBuilder: (context, index) {
        return ConversationItem(
          context,
          conversations[index].members,
          conversations[index].messages[0].message,
          () {
            navigateTo(
              context,
              Exchange(globalState, conversation: conversations[index]),
            );
          },
        );
      },
    );
  }

  Widget ConversationItem(BuildContext context, List<Contact> contact, String lastText, onTap) {
    bool isGroup = contact.length > 1;
    return ListItem(
      onTap: onTap,
      visual: ProfilePhoto(context, contact[0].pfp, ProfileSize.lg, isGroup),
      title: isGroup ? 'Group Message' : contact[0].name,
      desc: lastText,
    );
  }
}
