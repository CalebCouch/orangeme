import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class GroupMessageList extends StatefulWidget {
  const GroupMessageList({super.key});

  @override
  GroupMessageListState createState() => GroupMessageListState();
}

class GroupMessageListState extends State<GroupMessageList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Message'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}



// Widget _buildRecipientList() {
  //   if (recipients.length == 1) {
  //     return Padding(
  //       padding: const EdgeInsets.only(left: 18),
  //       child: Row(
  //         children: [
  //           ButtonSecondaryMD(
  //             label: recipients[0],
  //             icon: "clear",
  //             onTap: () => removeRecipient(recipients[0]),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     return Wrap(
  //       spacing: 8,
  //       runSpacing: 8,
  //       children: List<Widget>.generate(recipients.length, (index) {
  //         return ButtonSecondaryMD(
  //           label: recipients[index],
  //           icon: "clear",
  //           onTap: () => removeRecipient(recipients[index]),
  //         );
  //       }),
  //     );
  //   }
  // }
 
 
 
 
  //  body: Column(
  //       children: [
  //         Padding(
  //           padding:
  //               const EdgeInsets.only(left: 24, right: 24, top: 18, bottom: 4),
  //           child: TextInputField(
  //             controller: recipientAddressController,
  //             hint: "Profile Name",
  //           ),
  //         ),
  //         _buildRecipientList(),
  //         Expanded(
  //           child: ListView.builder(
  //             itemCount: contacts.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return ContactCard(
  //                 name: contacts[index]["name"]!,
  //                 onTap: () => addRecipient(contacts[index]["name"]!),
  //                 // imagePath: contacts[index]["imagePath"]!,
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),