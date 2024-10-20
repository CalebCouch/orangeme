import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/components/profile_photo.dart';

import 'package:orange/flows/messages/conversation/exchange.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

// Displays detailed information about a user, including their profile photo,
// about me section, DID, and address, with an option to start a conversation.

class UserProfile extends StatefulWidget {
  final GlobalState globalState;
  final Contact userInfo;
  final String address;

  const UserProfile(
    this.globalState,
    this.address, {
    super.key,
    required this.userInfo,
  });

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  onMessage() {
    () => navigateTo(
          context,
          Exchange(
            widget.globalState,
            conversation: Conversation(
              [
                Contact(widget.userInfo.name, widget.userInfo.did,
                    widget.userInfo.pfp, widget.userInfo.abtme)
              ],
              [],
            ),
          ),
        );
  }

  Widget build_screen(BuildContext context, DartState state) {
    return Interface(
      widget.globalState,
      header: stackHeader(
        context,
        widget.userInfo.name,
      ),
      content: Content(
        children: [
          profilePhoto(context, widget.userInfo.pfp, ProfileSize.xxl),
          aboutMeItem(
              context, widget.userInfo.abtme ?? "There's nothing here..."),
          didItem(context, widget.userInfo.did),
          addressItem(context, widget.address),
        ],
      ),
      bumper: singleButtonBumper(context, 'Message', onMessage),
      desktopOnly: true,
      navigationIndex: 1,
    );
  }
}
