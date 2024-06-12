import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/widgets/message_appbar.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/widgets/text_bauble.dart';

class Message extends StatefulWidget {
  final String contactName;
  final String imagePath;
  const Message({
    super.key,
    required this.contactName,
    this.imagePath = AppImages.defaultProfileMD,
  });

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message> {
  final TextEditingController messageController = TextEditingController();
  List<Map<String, String>> messages = [
    {
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation",
      "incoming": "true"
    },
    {
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation",
      "incoming": "false"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          MessageAppBar(
            title: widget.contactName,
            imagePath: widget.imagePath,
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
                      itemBuilder: (BuildContext context, int index) {
                        return MessageBauble(
                          message: messages[index]["message"]!,
                          incoming: messages[index]["incoming"]!,
                        );
                      },
                    )),
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
