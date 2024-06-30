import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/widgets/message_appbar.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/widgets/text_bauble.dart';
import 'package:orange/screens/social/group_message_list.dart';

class Message extends StatefulWidget {
  final List<String> recipients;
  final String imagePath;
  const Message({
    super.key,
    required this.recipients,
    this.imagePath = AppImages.defaultProfileMD,
  });
  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool submitEnabled = false;
  String sender = '';
  List<Map<String, String>> messages = [];
  @override
  void initState() {
    super.initState();
    sender = widget.recipients.first;
    messages = [
      {
        "message":
            "Quick question – do you know any good books to read? Need a new one.",
        "incoming": "true",
        "sender": sender,
        "timestamp": "2024-06-30 11:59:53"
      },
      {
        "message": "Absolutely! What genre are you into lately?",
        "incoming": "false",
        "sender": "me",
        "timestamp": "2024-06-30 13:32:09"
      },
      {
        "message":
            "Nothing particular. Thinking of redecorating my living room. Any ideas for a new color scheme?",
        "incoming": "false",
        "sender": "me",
        "timestamp": "2024-06-30 13:32:09"
      },
    ];
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
        "sender": "me",
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
      PageRouteBuilder(
        pageBuilder: (context, __, ___) =>
            GroupMessageList(recipients: widget.recipients),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          MessageAppBar(
              title: widget.recipients.length > 1
                  ? "Group Message"
                  : widget.recipients.first,
              imagePath: widget.imagePath,
              recipients: widget.recipients,
              showRecipients:
                  widget.recipients.length > 1 ? showRecipients : null),
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
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MessageBauble(
                            message: messages[index]["message"]!,
                            incoming: messages[index]["incoming"]!,
                            timestamp: messages[index]["timestamp"]!,
                            name: widget.recipients.length > 1
                                ? messages[index]["sender"]!
                                : widget.recipients.first);
                      },
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextInputField(
              controller: messageController,
              hint: "Message",
              rightIcon: AppIcons.send,
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
