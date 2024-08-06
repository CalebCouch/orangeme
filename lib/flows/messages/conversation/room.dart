import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/contact_info.dart';
import 'package:orange/classes/single_message.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/util.dart';

class Room extends StatefulWidget {
  final List<Contact> contacts;
  final Info? info;
  const Room({
    this.contacts = const [Contact('JOHN', null, 'a938ixOh2R...')],
    super.key,
    this.info,
  });

  @override
  RoomState createState() => RoomState();
}

class RoomState extends State<Room> {
  Contact myInfo = const Contact('Josh Thayer', null, 'gs3xToh8r...');
  List<SingleMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    bool isRoom = false;
    if (widget.info != null) isRoom = true;
    String roomName = getName(widget.info, isRoom);
    return DefaultInterface(
      header: stackHeader(context, roomName, null,
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
