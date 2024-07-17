import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/contact_info.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/components/text_input.dart';
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
      null,
      'VZDrYz39XxuPq...r5zKQGjTA',
    ),
    const Contact(
      'Brian Winchester',
      null,
      'VZDrYz39XxuPq...r5zKQGjTA',
    ),
    const Contact(
      'Cam',
      null,
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

  _getContactsfromRecipientNames(
      List<Contact> testContacts, List<String> recipients) {
    List<Contact> returnContacts = [];
    for (var i = 0; i < recipients.length; i++) {
      for (var x = 0; x < testContacts.length; x++) {
        if (recipients[i] == testContacts[x].name) {
          print("Adding ${testContacts[x]}");
          returnContacts.add(testContacts[x]);
        }
      }
    }
    return returnContacts;
  }

  @override
  Widget build(BuildContext context) {
    List<Contact> testContacts = [
      const Contact('Ann', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('James', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('Stacy', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('Cam', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('J. Marks', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('Anthony', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('R. R. B.', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
    ];
    return DefaultInterface(
      header: stackButtonHeader(
        context,
        'New message',
        recipients.isNotEmpty ? true : false,
        'Next',
        () {
          navigateTo(
            context,
            Conversation(
              contacts:
                  _getContactsfromRecipientNames(testContacts, recipients),
            ),
          );
        },
      ),
      content: Content(
        content: Column(
          children: [
            const CustomTextInput(
              hint: 'Profile name...',
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List<Widget>.generate(recipients.length, (index) {
                  return oneTip(
                    ButtonTip(
                      recipients[index],
                      ThemeIcon.close,
                      () => removeRecipient(recipients[index]),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: testContacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return contactListItem(
                      context,
                      testContacts[index],
                      () => addRecipient(testContacts[index].name),
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
