import 'package:flutter/material.dart';
import 'package:orange/classes/test_classes.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/text_input.dart';

import 'package:orange/flows/wallet/send/amount.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

class ChooseSendRecipient extends StatefulWidget {
  final GlobalState globalState;
  const ChooseSendRecipient(
    this.globalState, {
    super.key,
  });

  @override
  ChooseRecipientState createState() => ChooseRecipientState();
}

class ChooseRecipientState extends State<ChooseSendRecipient> {
  @override
  Widget build(BuildContext context) {
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
        'Select Recipient',
        true,
        'Next',
        () => {
          navigateTo(
              context,
              SendAmount(
                widget.globalState,
              ))
        },
      ),
      content: Content(
        content: Column(
          children: [
            const CustomTextInput(
              hint: 'Profile name...',
            ),
            Expanded(
              child: /*contactController.text == ''
                  ? const Center(
                      child: CustomText(
                          text: 'Search by profile name.',
                          textSize: TextSize.md,
                          color: ThemeColor.textSecondary),
                    )
                  :*/
                  SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: testContacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return contactListItem(
                      context,
                      testContacts[index],
                      () {},
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
