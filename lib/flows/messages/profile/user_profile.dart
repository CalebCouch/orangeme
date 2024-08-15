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
import 'dart:io' show Platform;

class UserProfile extends StatefulWidget {
  final GlobalState globalState;
  final Contact userInfo;

  const UserProfile(this.globalState, {super.key, required this.userInfo});

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
    bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    return Interface(
      header: onDesktop
          ? homeDesktopHeader(
              context,
              widget.userInfo.name,
            )
          : stackHeader(
              context,
              widget.userInfo.name,
            ),
      content: Content(
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profilePhoto(context, widget.userInfo.pfp, ProfileSize.xxl),
              const Spacing(height: AppPadding.profile),
              aboutMeItem(
                  context, widget.userInfo.abtme ?? "There's nothing here..."),
              const Spacing(height: AppPadding.profile),
              didItem(context, widget.userInfo.did),
              const Spacing(height: AppPadding.profile),
              addressItem(context, "GENERATED ADDRESS"),
            ],
          ),
        ),
      ),
      bumper: doubleButtonBumper(
        context,
        'Send Bitcoin',
        'Message',
        () {
          //print('send');
        },
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
        ),
      ),
    );
  }
}
