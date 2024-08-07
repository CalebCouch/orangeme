import 'package:flutter/material.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/flows/messages/conversation/info.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/test_classes.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class Room extends StatefulWidget {
  final GlobalState globalState;
  final Conversation conversation;
  const Room(
    this.globalState, {
    super.key,
    required this.conversation,
  });

  @override
  RoomState createState() => RoomState();
}

class RoomState extends State<Room> {
  Contact myInfo = const Contact('Ella Couch', 'gs3xToh8r...', null, null);
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
    String roomName = getName(widget.conversation.info, true);
    return DefaultInterface(
      header: stackHeader(
        context,
        roomName,
        backButton(
          context,
          MessagesHome(
            widget.globalState,
          ),
        ),
        infoButton(
          context,
          MessageInfo(
            widget.globalState,
            contacts: widget.conversation.members,
            info: widget.conversation.info,
          ),
        ),
      ),
      content: Content(
        content: widget.conversation.messages == null
            ? const Center(
                child: CustomText(
                  text: 'No messages yet.',
                  textSize: TextSize.md,
                  color: ThemeColor.textSecondary,
                ),
              )
            : slackMessageGroup(
                widget.globalState,
                context,
                widget.conversation.messages!,
              ),
      ),
      bumper: messageInput(),
    );
  }
}
