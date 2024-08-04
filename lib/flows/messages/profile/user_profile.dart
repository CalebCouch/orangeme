import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes.dart';
import 'package:orange/util.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/data_item.dart';

import 'package:orange/flows/messages/conversation/message_exchange.dart';

class UserProfile extends StatefulWidget {
  final GlobalState globalState;
  final Contact userInfo;

  const UserProfile(
    this.globalState,
    this.userInfo, {
    super.key,
  });

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: stackHeader(
        context,
        widget.userInfo.name,
      ),
      content: Content(
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfilePhoto(size: ProfileSize.xxl),
              const Spacing(height: AppPadding.profile),
              aboutMeItem(context, widget.userInfo.abtme ?? ''),
              const Spacing(height: AppPadding.profile),
              didItem(context, widget.userInfo.did),
            ],
          ),
        ),
      ),
      bumper: doubleButtonBumper(
        context,
        'Send Bitcoin',
        'Message',
        () => {print("send bitcoin")},
        () => navigateTo(
          context,
          MessageExchange(widget.globalState, state.conversations[0]),
        ),
      ),
    );
  }
}
