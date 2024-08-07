import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes/test_classes.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/data_item.dart';

import 'package:orange/flows/messages/conversation/exchange.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class UserProfile extends StatefulWidget {
  final GlobalState globalState;
  final Contact userInfo;
  final String address;

  const UserProfile(
    this.globalState, {
    super.key,
    this.userInfo = const Contact(
      'Chris Slaughter',
      '12FWmGPUCtFeZECFydRARUzfqt7h2GBqEL',
      null,
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
        return build_screen(context, state);
      },
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
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
              ProfilePhoto(
                size: ProfileSize.xxl,
                profilePhoto: widget.userInfo.pfp,
              ),
              const Spacing(height: AppPadding.profile),
              aboutMeItem(context, widget.userInfo.abtme),
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
        () {
          print('send');
        },
        () => navigateTo(
          context,
          Exchange(widget.globalState,
              conversation: Conversation(
                [
                  Contact(
                    widget.userInfo.name,
                    widget.userInfo.did,
                    widget.userInfo.pfp,
                    widget.userInfo.abtme,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
