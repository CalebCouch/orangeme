import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/widgets/message_appbar.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/screens/social/group_message_list.dart';

class MessageGroup extends StatefulWidget {
  final List<String> recipients;
  final String imagePath;
  const MessageGroup({
    super.key,
    required this.recipients,
    this.imagePath = AppImages.defaultProfileMD,
  });

  @override
  MessageGroupState createState() => MessageGroupState();
}

class MessageGroupState extends State<MessageGroup> {
  final TextEditingController messageController = TextEditingController();
  List<String> messages = [];

  void showParticipants() {
    print("Showing message participants");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GroupMessageList(recipients: widget.recipients)));
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
