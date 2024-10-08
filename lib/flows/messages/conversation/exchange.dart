import 'package:flutter/material.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/classes.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/flows/messages/conversation/info.dart';
import 'package:orange/flows/messages/profile/user_profile.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/util.dart';
import 'package:orangeme_material/orangeme_material.dart';

class Exchange extends StatefulWidget {
  final GlobalState globalState;
  final Conversation conversation;
  const Exchange(
    this.globalState, {
    required this.conversation,
    super.key,
  });

  @override
  ExchangeState createState() => ExchangeState();
}

class ExchangeState extends State<Exchange> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
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

  directProfile() async {
    var address = (await widget.globalState.invoke("get_new_address", "")).data;
    navigateTo(
      context,
      UserProfile(
        widget.globalState,
        address,
        userInfo: widget.conversation.members[0],
      ),
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    List<Contact> members = widget.conversation.members;

    return Stack_Chat(
      Header_Message(
        context,
        ChatRecipients(context, members),
        members.length > 1 ? infoButton(context, MessageInfo(widget.globalState, contacts: members)) : iconButton(directProfile, 'info lg'),
      ),
      [
        widget.conversation.messages.isNotEmpty,
        messageStack(widget.globalState, context, scrollController, members, widget.conversation.messages),
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
