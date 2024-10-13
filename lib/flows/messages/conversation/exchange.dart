import 'package:flutter/material.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/classes.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/flows/messages/conversation/info.dart';
import 'package:orange/flows/messages/profile/user_profile.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orangeme_material/orangeme_material.dart';
// import 'package:orange/global.dart' as global;

class Exchange extends GenericWidget {
  final Conversation conversation;
  Exchange(this.conversation, {super.key});

  @override
  ExchangeState createState() => ExchangeState();
}

class ExchangeState extends GenericState<Exchange> {
  @override
  String stateName() {
    return "Exchange";
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.conversation;
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    super.initState();
  }

  _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  directProfile() {
    navigateTo(UserProfile(widget.conversation.members[0]));
  }

  @override
  Widget build(BuildContext context) {
    List<Contact> members = widget.conversation.members;

    return Stack_Chat(
      Header_Message(
        context,
        ChatRecipients(context, members),
        members.length > 1 ? infoButton(context, MessageInfo(members)) : iconButton(directProfile, 'info lg'),
      ),
      [
        widget.conversation.messages.isNotEmpty,
        messageStack(context, scrollController, members, widget.conversation.messages),
      ],
      Bumper(context, [MessageInput()], true),
    );
  }
}

Widget ChatRecipients(BuildContext context, List<Contact> contacts) {
  bool isGroup = contacts.length > 1;
  return CustomColumn([
    isGroup ? profilePhotoStack(context, contacts) : ProfilePhoto(context, contacts[0].pfp, ProfileSize.lg, true, true),
    CustomText('heading h5', isGroup ? 'Group Message' : contacts[0].name),
  ], 8);
}

Widget MessageInput() {
  return Container(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: const CustomTextInput(
      hint: 'Message',
      showIcon: true,
    ),
  );
}
