import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/header.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/messages/profile/user_profile.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class MessageInfo extends StatefulWidget {
  final GlobalState globalState;
  final List<Contact> contacts;
  const MessageInfo(
    this.globalState, {
    super.key,
    required this.contacts,
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
    return DefaultInterface(
      header: stackHeader(context, "Group members"),
      content: Content(
        content: Column(
          children: [
            CustomText(
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
                          UserProfile(
                            widget.globalState,
                            userInfo: widget.contacts[index],
                          ),
                        );
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
