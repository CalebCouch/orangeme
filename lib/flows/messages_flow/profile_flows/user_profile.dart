import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/profile_info.dart';
import 'package:orange/classes/contact_info.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/data_item.dart';

import 'package:orange/flows/messages_flow/direct_message_flow/conversation.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class UserProfile extends StatefulWidget {
  final Profile userInfo;
  final String address;
  final GlobalState globalState;

  const UserProfile(
    this.globalState, {
    super.key,
    this.userInfo = const Profile(
      'Chris Slaughter',
      null,
      '12FWmGPUCtFeZECFydRARUzfqt7h2GBqEL',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    ),
    this.address = 'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA',
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
        return buildScreen(context, state);
      },
    );
  }

  buildScreen(BuildContext context, DartState state) {
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
              aboutMeItem(context, widget.userInfo.aboutMe),
              const Spacing(height: AppPadding.profile),
              didItem(context, widget.userInfo.did),
              const Spacing(height: AppPadding.profile),
              addressItem(context, widget.address),
            ],
          ),
        ),
      ),
      bumper: doubleButtonBumper(
        context,
        'Send Bitcoin',
        'Message',
        () => navigateTo(
          context,
          Conversation(
            widget.globalState,
            contacts: [
              Contact(widget.userInfo.name, null, widget.userInfo.did)
            ],
          ),
        ),
        () => navigateTo(context, Conversation(widget.globalState)),
      ),
    );
  }
}
