import 'package:flutter/material.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/flows/bitcoin/home.dart';
import 'package:orange/flows/messages/profile/my_profile.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/flows/messages/new_message/choose_recipient.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/flows/messages/conversation/exchange.dart';
import 'package:orange/classes.dart';

import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/global.dart' as global;

class MessagesHome extends GenericWidget {
  MessagesHome({super.key});

  List<Conversation> conversations = []; //List of all conversations
  String profile_picture = "";
  @override
  MessagesHomeState createState() => MessagesHomeState();
}

class MessagesHomeState extends GenericState<MessagesHome> {
  @override
  String stateName() {
    return "MessagesHome";
  }

  @override
  int refreshInterval() {
    return 100;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.profile_picture = json["profile_picture"];
      widget.conversations = List<Conversation>.from(json['conversations'].map((json) => Conversation.fromJson(json)));
    });
  }

  createNewMessage() {
    navigateTo(ChooseRecipient());
  }

  toProfile() {
    navigateTo(MyProfile());
  }

  setConversation(int i) {
    BigInt bigIntValue = BigInt.from(i);
    setStateConversation(path: global.dataDir!, index: bigIntValue);
  }

  @override
  Widget build(BuildContext context) {
    return Root_Home(
      Header_Home(ProfileButton(context, widget.profile_picture, toProfile), "Messages"),
      [listConversations()],
      Bumper(context, [CustomButton('New Message', 'primary lg expand none', createNewMessage, 'enabled')]),
      TabNav(1, [
        TabInfo(BitcoinHome(), 'wallet'),
        TabInfo(MessagesHome(), 'message'),
      ]),
    );
  }

  Widget noMessages() {
    return const Expanded(
      child: Center(
        child: CustomText('text md text_secondary', 'No messages yet.\nGet started by messaging a friend.'),
      ),
    );
  }

  Widget listConversations() {
    List<Conversation> conversations = widget.conversations;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.conversations.length,
      itemBuilder: (context, index) {
        return ConversationItem(
          context,
          conversations[index].members,
          conversations[index].messages[0].message,
          () {
            setConversation(index);
            navigateTo(Exchange());
          },
        );
      },
    );
  }

  Widget ConversationItem(BuildContext context, List<Profile> contact, String lastText, onTap) {
    bool isGroup = contact.length > 1;
    return ListItem(
      onTap: onTap,
      visual: ProfilePhoto(context, contact[0].pfp, ProfileSize.lg, false, isGroup),
      title: isGroup ? 'Group Message' : contact[0].name,
      desc: lastText,
    );
  }
}
