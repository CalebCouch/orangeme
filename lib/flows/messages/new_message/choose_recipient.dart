import 'package:flutter/material.dart';
import 'package:orange/flows/messages/new_message/visibility.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/test_classes.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';

import 'package:orange/components/list_item.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/components/text_input.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class ChooseRecipient extends StatefulWidget {
  final GlobalState globalState;
  const ChooseRecipient(
    this.globalState, {
    super.key,
  });

  @override
  ChooseRecipientState createState() => ChooseRecipientState();
}

class ChooseRecipientState extends State<ChooseRecipient> {
  List<String> recipients = [];

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
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return buildScreen(context, state);
      },
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    List<Contact> testContacts = [
      const Contact('Ann', 'VZDrYz39XxuPq...r5zKQGjTA', null, null),
      const Contact('James', 'VZDrYz39XxuPq...r5zKQGjTA', null, null),
      const Contact('Stacy', 'VZDrYz39XxuPq...r5zKQGjTA', null, null),
      const Contact('Cam', 'VZDrYz39XxuPq...r5zKQGjTA', null, null),
      const Contact('J. Marks', 'VZDrYz39XxuPq...r5zKQGjTA', null, null),
      const Contact('Anthony', 'VZDrYz39XxuPq...r5zKQGjTA', null, null),
      const Contact('R. R. B.', 'VZDrYz39XxuPq...r5zKQGjTA', null, null),
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
            MessagesVisibility(
              widget.globalState,
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
              padding: const EdgeInsets.symmetric(vertical: 8),
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
