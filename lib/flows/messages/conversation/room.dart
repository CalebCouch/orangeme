import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/contact_info.dart';
import 'package:orange/classes/single_message.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/message_bubble.dart';

class Room extends StatefulWidget {
  final List<Contact> contacts;
  final String? roomName;
  const Room({
    this.contacts = const [Contact('JOHN', null, 'a938ixOh2R...')],
    super.key,
    this.roomName,
  });

  @override
  RoomState createState() => RoomState();
}

class RoomState extends State<Room> {
  Contact myInfo = const Contact('Josh Thayer', null, 'gs3xToh8r...');
  List<SingleMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    print("got this far");
    return DefaultInterface(
      header: stackHeader(context, widget.roomName ?? "${myInfo.name}'s Room"),
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
      //bumper: messageInput(),
    );
  }
}
