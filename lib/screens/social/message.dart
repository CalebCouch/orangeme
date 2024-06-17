import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final ScrollController scrollController = ScrollController();
  bool showSubmitButton = false;
  List<Map<String, String>> messages = [
    {
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation",
      "incoming": "true",
      "timestamp": "2024-06-10 11:59:53"
    },
    {
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation",
      "incoming": "false",
      "timestamp": "2024-06-11 13:32:09"
    },
    {
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation",
      "incoming": "false",
      "timestamp": "2024-06-12 12:29:09"
    },
  ];
  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      if (messageController.text.isNotEmpty) {
        setState(() {
          showSubmitButton = true;
        });
      } else {
        setState(() {
          showSubmitButton = false;
        });
      }
    });
    scrollController.addListener(() {
      print("scrolling");
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        print("Scrolling up");
        FocusScope.of(context).unfocus();
      }
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
    setState(() {
      messages.add({
        "message": messageController.text,
        "incoming": "false",
        "timestamp": formattedTimestamp
      });
      messageController.text = '';
      showSubmitButton = false;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

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
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MessageBauble(
                            message: messages[index]["message"]!,
                            incoming: messages[index]["incoming"]!,
                            timestamp: messages[index]["timestamp"]!,
                            name: widget.contactName);
                      },
                    )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextInputField(
              controller: messageController,
              hint: "Message",
              showSubmit: showSubmitButton,
              onEditingComplete: submitMessage,
              showNewLine: true,
            ),
          ),
        ],
      ),
    );
  }
}
