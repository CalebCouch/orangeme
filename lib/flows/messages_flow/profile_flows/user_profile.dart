import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/profile_info.dart';
import 'package:orange/classes/contact_info.dart';

import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/bumpers/double_button_bumper.dart';
import 'package:orange/components/profile_photo/profile_photo.dart';
import 'package:orange/components/data_item/did_item.dart';
import 'package:orange/components/data_item/address_item.dart';
import 'package:orange/components/data_item/about_me_item.dart';

import 'package:orange/flows/messages_flow/direct_message_flow/conversation.dart';

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
    return DefaultInterface(
      header: StackHeader(
        text: widget.userInfo.name,
      ),
      content: Content(
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfilePhoto(size: ProfileSize.xxl),
              const Spacing(height: AppPadding.profile),
              AboutMeItem(aboutMe: widget.userInfo.aboutMe),
              const Spacing(height: AppPadding.profile),
              DidItem(did: widget.userInfo.did),
              const Spacing(height: AppPadding.profile),
              AddressItem(address: widget.address),
            ],
          ),
        ),
      ),
      bumper: DoubleButton(
        firstText: 'Send Bitcoin',
        secondText: 'Message',
        firstOnTap: () => navigateTo(
          context,
          Conversation(
            contacts: [
              Contact(widget.userInfo.name, null, widget.userInfo.did)
            ],
          ),
        ),
        secondOnTap: () => navigateTo(context, const Conversation()),
      ),
    );
  }
}
