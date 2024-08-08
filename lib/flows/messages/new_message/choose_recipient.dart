import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';

import 'package:orange/components/list_item.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/components/text_input.dart';

import 'package:orange/util.dart';
import 'package:orange/classes.dart';

import 'package:orange/flows/messages/conversation/exchange.dart';

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
  List<Contact> recipients = [];

  void addRecipient(Contact selected) {
    setState(() {
      if (recipients.contains(selected)) return;
      recipients.add(selected);
    });
  }

  void removeRecipient(Contact selected) {
    setState(() {
      recipients.remove(selected);
    });
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
    return DefaultInterface(
      header: stackButtonHeader(
        context,
        'New message',
        recipients.isNotEmpty ? true : false,
        'Next',
        () {
          navigateTo(
            context,
            Exchange(
              widget.globalState,
              conversation: Conversation(recipients, []),
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
                      recipients[index].name,
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
                  itemCount: state.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return contactListItem(
                      context,
                      state.users[index],
                      () => addRecipient(state.users[index]),
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
