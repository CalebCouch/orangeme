import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/widgets/message_appbar.dart';
import 'package:orange/components/textfield.dart';

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
  List<String> messages = [];

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
