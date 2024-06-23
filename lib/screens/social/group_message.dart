import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/widgets/message_appbar.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/screens/social/group_message_list.dart';
import 'package:orange/widgets/text_bauble.dart';
import 'package:flutter/rendering.dart';

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
  final ScrollController scrollController = ScrollController();
  bool submitEnabled = false;
  List<Map<String, String>> messages = [
    {
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation",
      "incoming": "true",
      "sender": 'Pam Beesley',
      "timestamp": "2024-06-10 11:59:53"
    },
    {
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation",
      "incoming": "false",
      "sender": 'me',
      "timestamp": "2024-06-11 13:32:09"
    },
    {
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation",
      "incoming": "true",
      "sender": 'Michael Scott',
      "timestamp": "2024-06-11 14:01:26"
    },
    {
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation",
      "incoming": "false",
      "sender": "me",
      "timestamp": "2024-06-12 12:29:09"
    },
  ];
  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      if (messageController.text.isNotEmpty) {
        setState(() {
          if (validateMessage(messageController.text)) {
            submitEnabled = true;
          } else {
            submitEnabled = false;
          }
        });
      } else {
        setState(() {
          submitEnabled = false;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        print("scrolling");
        if (scrollController.hasClients &&
            scrollController.position.userScrollDirection ==
                ScrollDirection.forward) {
          print('scrolling up, diposing focus');
          FocusScope.of(context).unfocus();
        }
      });
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void submitMessage() {
    print("adding message");
    String formattedTimestamp = DateTime.now().toString();
    String formattedMessage = formatMessage(messageController.text);
    setState(() {
      messages.add({
        "message": formattedMessage,
        "incoming": "false",
        "sender": 'me',
        "timestamp": formattedTimestamp
      });
      messageController.text = '';
      submitEnabled = false;
      scrollToBottom();
    });
  }

  String formatMessage(String input) {
    String trimmed = input.trim();
    String normalized = trimmed.replaceAll(RegExp(r'\n+'), '\n');
    return normalized;
  }

  bool validateMessage(String input) {
    return RegExp(r'[^\s]').hasMatch(input);
  }

  void scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void showRecipients() {
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
            recipients: widget.recipients,
            showRecipients: showRecipients,
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
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MessageBauble(
                            message: messages[index]["message"]!,
                            incoming: messages[index]["incoming"]!,
                            timestamp: messages[index]["timestamp"]!,
                            name: messages[index]["sender"]!);
                      },
                    )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextInputField(
              rightIcon: true,
              controller: messageController,
              hint: "Message",
              showSubmit: true,
              onEditingComplete: submitMessage,
              showNewLine: true,
              submitEnabled: submitEnabled,
            ),
          ),
        ],
      ),
    );
  }
}
