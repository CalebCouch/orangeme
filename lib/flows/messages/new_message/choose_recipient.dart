import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orange/flows/messages/conversation/exchange.dart';
import 'package:orangeme_material/orangeme_material.dart';

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
    return Stack_Default(
      Header_Button(context, "Confirm send", CustomButton('Next', 'ghost md ${recipients.isNotEmpty} hug none', () => onNext())),
      [
        Searchbar(searchController),
        SelectedContacts(recipients, removeRecipient),
        ListContacts(filteredContacts, removeRecipient),
      ],
      Bumper(context, [Container()]),
    );
  }

  //The following widgets can ONLY be used in this file

  onNext() {
    navigateTo(
      context,
      Exchange(
        widget.globalState,
        conversation: Conversation(recipients, []),
      ),
    );
  }

  List<Contact> recipients = [];
  List<Contact> filteredContacts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredContacts = widget.globalState.state.value.users;
    searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterContacts);
    searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    setState(() {
      String searchTerm = searchController.text.toLowerCase();
      if (searchTerm.isEmpty) {
        filteredContacts = widget.globalState.state.value.users;
      } else {
        filteredContacts = widget.globalState.state.value.users
            .where((contact) => contact.name.toLowerCase().startsWith(searchTerm) || contact.did.toLowerCase().startsWith(searchTerm))
            .toList();
      }
    });
  }

  void addRecipient(Contact selected) {
    setState(() {
      if (!recipients.contains(selected)) {
        recipients.add(selected);
      }
    });
  }

  void removeRecipient(Contact selected) {
    setState(() {
      recipients.remove(selected);
    });
  }
}

Widget Searchbar(controller) {
  return CustomTextInput(
    maxLines: 1,
    controller: controller,
    hint: 'Profile name...',
  );
}

Widget SelectedContacts(recipients, removeRecipient) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    alignment: Alignment.topLeft,
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List<Widget>.generate(recipients.length, (index) {
        return CustomButton(recipients[index].name, 'ghost md enabled hug close', () {
          removeRecipient(recipients[index]);
        });
      }),
    ),
  );
}

Widget ListContacts(filteredContacts, addRecipient) {
  return Expanded(
    child: ListView.builder(
      itemCount: filteredContacts.length,
      itemBuilder: (BuildContext context, int index) {
        return ContactItem(context, filteredContacts[index], () {
          HapticFeedback.heavyImpact();
          addRecipient(filteredContacts[index]);
        });
      },
    ),
  );
}
