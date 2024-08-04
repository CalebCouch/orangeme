import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/classes.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/components/tip_buttons.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/flows/messages/conversation/message_exchange.dart';

import 'package:orange/util.dart';

class ChooseRecipient extends StatefulWidget {
  final GlobalState globalState;
  final List<Contact> users;
  const ChooseRecipient(
    this.globalState,
    this.users, {
    super.key,
  });

  @override
  ChooseRecipientState createState() => ChooseRecipientState();
}

class ChooseRecipientState extends State<ChooseRecipient> {
  List<Contact> recipients = [];

  void addRecipient(Contact cnt) {
    setState(() {
      recipients.add(cnt);
    });
  }

  void removeRecipient(Contact cnt) {
    setState(() {
      recipients.remove(cnt);
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

  Future<void> next() async {
    //await widget.globalState.invoke("create_conversation", contacts, messages);

    navigateTo(
      context,
      MessageExchange(
        widget.globalState,
        Conversation(recipients, []),
      ),
    );
  }

  Widget buildScreen(BuildContext context, DartState state) {
    return DefaultInterface(
      header: stackButtonHeader(
        context,
        'New message',
        recipients.isNotEmpty,
        'Next',
        () {
          next();
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
                  return ButtonTip(
                    recipients[index].name,
                    ThemeIcon.close,
                    () => removeRecipient(recipients[index]),
                  );
                }),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: widget.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return contactListItem(
                      context,
                      widget.users[index],
                      () => addRecipient(widget.users[index]),
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
