import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/list_item/contact_list_item.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/custom/custom_text.dart';

import 'package:orange/classes/contact_info.dart';

class GroupMessageInfo extends StatefulWidget {
  final List<Contact> contacts;
  const GroupMessageInfo({
    this.contacts = const [Contact('JOHN', null, 'con.r.null...')],
    super.key,
  });

  @override
  GroupMessageInfoState createState() => GroupMessageInfoState();
}

class GroupMessageInfoState extends State<GroupMessageInfo> {
  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const StackHeader(text: 'Group members'),
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
                    return ContactListItem(
                      contact: widget.contacts[index],
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
