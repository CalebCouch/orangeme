import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/radio_selectors.dart';
import 'package:orange/flows/messages/conversation/exchange.dart';
import 'package:orange/flows/messages/conversation/room.dart';

import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/util.dart';

import 'package:orange/classes.dart';
import 'package:orange/classes/test_classes.dart';

class MessagesVisibility extends StatefulWidget {
  final GlobalState globalState;
  final List<Contact> recipients;

  const MessagesVisibility(this.globalState, this.recipients, {super.key});

  @override
  MessagesVisibilityState createState() => MessagesVisibilityState();
}

class MessagesVisibilityState extends State<MessagesVisibility> {
  int index = 0;

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
    Info dummyInfo = Info(
      null,
      'assets/images/joshThayer.png',
      null,
      'Josh Thayer',
      '8/5/24',
      widget.recipients,
    );
    return DefaultInterface(
      header: stackHeader(
        context,
        "New Message",
      ),
      content: Content(
        content: Column(children: <Widget>[
          radioButton(
            "Private",
            "This conversation will be made private.\nOnly the people you have invited can join.",
            index == 0 ? true : false,
            () {
              setState(() {
                index = 0;
              });
            },
          ),
          const Spacing(height: 16),
          radioButton(
            "Public",
            "This conversation will be made public.\nAnyone can join.",
            index == 1 ? true : false,
            () {
              setState(() {
                index = 1;
              });
            },
          ),
        ]),
      ),
      bumper: singleButtonBumper(context, "Done", () {
        if (index == 1) {
          navigateTo(
            context,
            Room(widget.globalState,
                contacts: widget.recipients, info: dummyInfo),
          );
        } else {
          navigateTo(
            context,
            Exchange(
              conversation: Conversation(widget.recipients),
            ),
          );
        }
      }),
    );
  }
}
