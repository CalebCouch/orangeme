import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/widgets/message_appbar.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/screens/social/group_message_list.dart';

class MessageGroup extends StatefulWidget {
  final List<String> contactName;
  final String imagePath;
  const MessageGroup({
    super.key,
    required this.contactName,
    this.imagePath = AppImages.defaultProfileMD,
  });

  @override
  MessageGroupState createState() => MessageGroupState();
}

//  Widget _buildRecipientList() {
//     if (recipients.length == 1) {
//       return Padding(
//         padding: const EdgeInsets.only(left: 18),
//         child: Row(
//           children: [
//             ButtonSecondaryMD(
//               label: recipients[0],
//               icon: "clear",
//               onTap: () => removeRecipient(recipients[0]),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: List<Widget>.generate(recipients.length, (index) {
//           return ButtonSecondaryMD(
//             label: recipients[index],
//             icon: "clear",
//             onTap: () => removeRecipient(recipients[index]),
//           );
//         }),
//       );
//     }
//   }

class MessageGroupState extends State<MessageGroup> {
  final TextEditingController messageController = TextEditingController();
  List<String> messages = [];

  void showParticipants() {
    print("Showing message participants");
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const GroupMessageList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          MessageAppBar(
            title: "Group Message",
            imagePath: widget.imagePath,
            showParticipants: showParticipants,
          ),
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      'No messages yet.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textMD
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index]),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextInputField(
              controller: messageController,
              hint: "Message",
            ),
          ),
        ],
      ),
    );
  }
}




// body: Column(
//         children: [
//           Padding(
//             padding:
//                 const EdgeInsets.only(left: 24, right: 24, top: 18, bottom: 4),
//             child: TextInputField(
//               controller: recipientAddressController,
//               hint: "Profile Name",
//             ),
//           ),
//           _buildRecipientList(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: contacts.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ContactCard(
//                   name: contacts[index]["name"]!,
//                   onTap: () => addRecipient(contacts[index]["name"]!),
//                   // imagePath: contacts[index]["imagePath"]!,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
