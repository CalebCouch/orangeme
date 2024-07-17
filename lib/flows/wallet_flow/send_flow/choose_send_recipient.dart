import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes/contact_info.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/text_input.dart';

import 'package:orange/flows/wallet_flow/send_flow/send_amount.dart';

import 'package:orange/util.dart';

class ChooseSendRecipient extends StatefulWidget {
  const ChooseSendRecipient({
    super.key,
  });

  @override
  ChooseRecipientState createState() => ChooseRecipientState();
}

class ChooseRecipientState extends State<ChooseSendRecipient> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController contactController = TextEditingController();
    List<Contact> testContacts = [
      const Contact('Ann', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('James', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('Stacy', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('Cam', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('J. Marks', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('Anthony', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
      const Contact('R. R. B.', null, 'VZDrYz39XxuPq...r5zKQGjTA'),
    ];
    print('CONTROLLER TEXT ${contactController.text}');
    return DefaultInterface(
      header: stackButtonHeader(
        context,
        'Select Recipient',
        true,
        'Next',
        () => {navigateTo(context, const SendAmount())},
      ),
      content: Content(
        content: Column(
          children: [
            CustomTextInput(
              controller: contactController,
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
