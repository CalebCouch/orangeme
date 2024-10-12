import 'package:flutter/material.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/flows/messages/profile/user_profile.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';

class MessageInfo extends GenericWidget {
  final List<Contact> contacts;
  MessageInfo(this.contacts, {super.key});

  @override
  MessageInfoState createState() => MessageInfoState();
}

class MessageInfoState extends GenericState<MessageInfo> {
  @override
  String stateName() {
    return "MessageInfo";
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack_Scroll(
      Header_Stack(context, "Group members"),
      [
        Information(widget.contacts),
        ListMembers(context, widget.contacts),
      ],
    );
  }
}

//The following widgets can ONLY be used in this file

Widget Information(List<Contact> contacts) {
  return CustomText('text md text_secondary', 'This group has ${contacts.length} members');
}

Widget ListMembers(BuildContext context, contacts) {
  onPressed(index) async {
    //Generate an address
    navigateTo(context, UserProfile(contacts[index]));
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const ScrollPhysics(),
    itemCount: contacts.length,
    itemBuilder: (BuildContext context, int index) {
      return ContactItem(context, contacts[index], () => onPressed(index));
    },
  );
}
