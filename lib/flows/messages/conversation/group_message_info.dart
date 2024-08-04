import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes.dart';

import 'package:orange/components/header.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/messages/profile/user_profile.dart';

import 'package:orange/util.dart';

class GroupMessageInfo extends StatefulWidget {
  final GlobalState globalState;
  final Conversation conversation;
  const GroupMessageInfo(
    this.globalState,
    this.conversation, {
    super.key,
  });

  @override
  GroupMessageInfoState createState() => GroupMessageInfoState();
}

class GroupMessageInfoState extends State<GroupMessageInfo> {
  @override
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
      header: stackHeader(context, 'Group members'),
      content: Content(
        content: Column(
          children: [
            CustomText(
              text:
                  'This group has ${widget.conversation.members.length} members',
              textSize: TextSize.md,
              color: ThemeColor.textSecondary,
            ),
            const Spacing(height: AppPadding.content),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: widget.conversation.members.length,
                  itemBuilder: (BuildContext context, int index) {
                    return contactListItem(
                      context,
                      widget.conversation.members[index],
                      navigateTo(
                        context,
                        UserProfile(
                          widget.globalState,
                          widget.conversation.members[index],
                        ),
                      ),
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
