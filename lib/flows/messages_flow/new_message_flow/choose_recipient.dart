import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/contact_info/contact_info.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_button_header.dart';
import 'package:orange/components/list_item/message_list_item.dart';
import 'package:orange/components/buttons/icon_text_button.dart';
import 'package:orange/components/text_input/text_input.dart';

import 'package:orange/flows/messages_flow/new_message_flow/choose_recipient.dart';
import 'package:orange/flows/messages_flow/direct_message_flow/conversation.dart';

import 'package:orange/util.dart';

class ChooseRecipient extends StatefulWidget {
  const ChooseRecipient({
    super.key,
  });

  @override
  ChooseRecipientState createState() => ChooseRecipientState();
}

class ChooseRecipientState extends State<ChooseRecipient> {
  List<String> recipients = [];
  List<Contact> testContacts = [
    const Contact(
      'Chris Slaughter',
      ThemeIcon.profile,
      'VZDrYz39XxuPq...r5zKQGjTA',
    ),
    const Contact(
      'Brian Winchester',
      ThemeIcon.profile,
      'VZDrYz39XxuPq...r5zKQGjTA',
    ),
    const Contact(
      'Cam',
      ThemeIcon.profile,
      'VZDrYz39XxuPq...r5zKQGjTA',
    ),
  ];

  void addRecipient(String name) {
    if (recipients.contains(name)) {
      removeRecipient(name);
      return;
    }
    setState(() {
      recipients.add(name);
    });
  }

  void removeRecipient(String name) {
    setState(() {
      recipients.remove(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController contactController = TextEditingController();
    return DefaultInterface(
      header: StackButtonHeader(
        text: 'New message',
        rightEnabled: recipients.isNotEmpty ? true : false,
        rightOnTap: () {
          navigateTo(context, const NewConversation());
        },
      ),
      content: Content(
        content: Column(
          children: [
            CustomTextInput(
              controller: contactController,
              hint: 'Profile name...',
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List<Widget>.generate(recipients.length, (index) {
                  return IconTextButton(
                    text: recipients[index],
                    icon: ThemeIcon.close,
                    onTap: () => removeRecipient(recipients[index]),
                  );
                }),
              ),
            ),
            Container(
              height: 250,
              child: testContacts.isNotEmpty
                  ? ListView.builder(
                      itemCount: testContacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MessageListItem(
                          profilePhoto: testContacts[index].photo,
                          name: testContacts[index].name,
                          recentMessage: testContacts[index].did,
                          onTap: () => addRecipient(testContacts[index].name),
                        );
                      },
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
