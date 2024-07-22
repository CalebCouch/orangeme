import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/contact_info.dart';

import 'package:orange/components/header.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/flows/messages_flow/profile_flows/user_profile.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class GroupMessageInfo extends StatefulWidget {
  final GlobalState globalState;
  final List<Contact> contacts;
  const GroupMessageInfo(
    this.globalState, {
    this.contacts = const [Contact('JOHN', null, 'con.r.empt...')],
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

  buildScreen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: stackHeader(context, 'Group members'),
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
                      navigateTo(context, UserProfile(widget.globalState)),
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
