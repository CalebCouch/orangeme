import 'package:flutter/material.dart';
import 'package:orange/components/list_item.dart';
import 'package:orange/flows/messages/profile/user_profile.dart';
import 'package:orange/util.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';

class MessageInfo extends StatefulWidget {
  final GlobalState globalState;
  final List<Contact> contacts;
  const MessageInfo(
    this.globalState, {
    super.key,
    required this.contacts,
  });

  @override
  MessageInfoState createState() => MessageInfoState();
}

class MessageInfoState extends State<MessageInfo> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
    return Stack_Scroll(
      Header_Stack(context, "Group members"),
      [
        Information(widget.contacts),
        ListMembers(context, widget.globalState, widget.contacts),
      ],
    );
  }
}

//The following widgets can ONLY be used in this file

Widget Information(List<Contact> contacts) {
  return CustomText('text md text_secondary', 'This group has ${contacts.length} members');
}

Widget ListMembers(BuildContext context, GlobalState globalState, contacts) {
  onPressed(index) async {
    var address = (await globalState.invoke("get_new_address", "")).data;
    navigateTo(
      context,
      UserProfile(
        globalState,
        address,
        userInfo: contacts[index],
      ),
    );
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
