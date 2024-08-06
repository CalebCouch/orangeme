import 'package:flutter/material.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/test_classes.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class Room extends StatefulWidget {
  final GlobalState globalState;
  final List<Contact> contacts;
  final Info? info;
  const Room(
    this.globalState, {
    this.contacts = const [Contact('JOHN', 'a938ixOh2R...', null, null)],
    super.key,
    this.info,
  });

  @override
  RoomState createState() => RoomState();
}

class RoomState extends State<Room> {
  Contact myInfo = const Contact('Ella Couch', 'gs3xToh8r...', null, null);
  List<Message> messages = [];

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
    bool isRoom = false;
    if (widget.info != null) isRoom = true;
    String roomName = getName(widget.info, isRoom);
    return DefaultInterface(
      header: stackHeader(
          context,
          roomName,
          backButton(
            context,
            MessagesHome(
              widget.globalState,
              newConversation:
                  isRoom ? Conversation(widget.info!.members) : null,
            ),
          ),
          infoButton(context, widget.contacts, widget.info)),
      content: Content(
        content: messages.isEmpty
            ? const Center(
                child: CustomText(
                  text: 'No messages yet.',
                  textSize: TextSize.md,
                  color: ThemeColor.textSecondary,
                ),
              )
            : const Center(
                child: CustomText(
                  text: 'No messages yet.',
                  textSize: TextSize.md,
                  color: ThemeColor.textSecondary,
                ),
              ),
      ),
      bumper: messageInput(),
    );
  }
}
