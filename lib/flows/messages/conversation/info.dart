import 'package:flutter/material.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/test_classes.dart';

import 'package:orange/components/header.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/tabular.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/messages/profile/user_profile.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class MessageInfo extends StatefulWidget {
  final GlobalState globalState;
  final List<Contact> contacts;
  final Info? info;
  const MessageInfo(
    this.globalState, {
    super.key,
    this.contacts = const [
      Contact('Chris Slaughter', 'unknown', null, null),
    ],
    this.info,
  });

  @override
  MessageInfoState createState() => MessageInfoState();
}

class MessageInfoState extends State<MessageInfo> {
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
    bool isRoom = false;
    if (widget.info != null) isRoom = true;
    String roomName = getName(widget.info, isRoom);
    return DefaultInterface(
      header: stackHeader(context, roomName),
      content: Content(
        content: Column(
          children: [
            isRoom
                ? roomInfoDisplay(widget.globalState, context, widget.info!)
                : CustomText(
                    text: 'This group has ${widget.contacts.length} members',
                    textSize: TextSize.md,
                    color: ThemeColor.textSecondary,
                  ),
            const Spacing(height: AppPadding.content),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: widget.contacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return contactListItem(
                      context,
                      widget.contacts[index],
                      () {
                        navigateTo(
                            context,
                            UserProfile(widget.globalState,
                                userInfo: widget.contacts[index]));
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget roomInfoDisplay(
    GlobalState globalState, BuildContext context, Info info) {
  return Column(children: [
    ProfilePhoto(
      profilePhoto: info.photo ?? info.creator.pfp,
      size: ProfileSize.xxl,
    ),
    const Spacing(height: AppPadding.content),
    DataItem(
      title: "Description",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacing(height: AppPadding.bumper),
          CustomText(
            textSize: TextSize.md,
            alignment: TextAlign.left,
            color: ThemeColor.heading,
            text:
                info.desc ?? "A room for all of ${info.creator.name}'s friends",
          ),
          const Spacing(height: AppPadding.bumper),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.bumper),
            child: roomInfoTabular(globalState, context, info),
          ),
        ],
      ),
    ),
  ]);
}
