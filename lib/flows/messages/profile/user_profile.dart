import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/components/profile_photo.dart';

import 'package:orange/flows/messages/conversation/exchange.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';

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
    navigateTo(
      context,
      Exchange(
        widget.globalState,
        conversation: Conversation(
          [Contact(widget.userInfo.name, widget.userInfo.did, widget.userInfo.pfp, widget.userInfo.abtme)],
          [],
        ),
      ),
    );
  }

  onBitcoin() {}

  Widget build_screen(BuildContext context, DartState state) {
    return Stack_Default(
      Header_Stack(context, widget.userInfo.name),
      [
        ProfilePhoto(context, widget.userInfo.pfp, ProfileSize.xxl),
        aboutMeItem(context, widget.userInfo.abtme ?? "This profile is still a mystery."),
        didItem(context, widget.userInfo.did),
        addressItem(context, widget.address),
      ],
      Bumper(context, [
        CustomButton('Message', 'primary lg enabled expand none', onMessage),
        CustomButton('Send Bitcoin', 'primary lg enabled expand none', onBitcoin),
      ]),
    );
  }
}
