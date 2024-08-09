import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/profile_info.dart';
import 'package:orange/classes/contact_info.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/bumper.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/data_item.dart';

import 'package:orange/flows/messages/conversation/conversation.dart';

import 'package:orange/util.dart';

class UserProfile extends StatefulWidget {
  final Profile userInfo;
  final String address;

  const UserProfile({
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
    return Interface(
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
            contacts: [
              Contact(widget.userInfo.name, null, widget.userInfo.did)
            ],
          ),
        ),
        () => navigateTo(context, const Conversation()),
      ),
    );
  }
}
