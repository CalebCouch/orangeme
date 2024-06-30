import 'package:flutter/material.dart';
import 'package:orange/widgets/mode_navigator.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'new_message.dart';
import 'package:orange/widgets/message_history_card.dart';
import 'message.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SocialDashboard extends StatefulWidget {
  final VoidCallback onDashboardPopBack;
  final VoidCallback stopTimer;

  const SocialDashboard(
      {super.key, required this.onDashboardPopBack, required this.stopTimer});

  @override
  SocialDashboardState createState() => SocialDashboardState();
}

class SocialDashboardState extends State<SocialDashboard> {
  int navIndex = 1;
  List<Map<String, dynamic>> messages = [
    {
      "name": ["Pam Beesley", "Michael Scott", "Andy Bernard"],
      "lastMessage":
          "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do elusmod tempor incid"
    },
    {
      "name": ["Pam Beesley"],
      "lastMessage":
          "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do elusmod tempor incid"
    },
    {
      "name": ["Dwight Schrute"],
      "lastMessage":
          "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do elusmod tempor incid"
    },
    {
      "name": ["Michael Scott"],
      "lastMessage":
          "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do elusmod tempor incid"
    },
    {
      "name": ["Jim Halpert"],
      "lastMessage":
          "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do elusmod tempor incid"
    },
    {
      "name": ["Ryan Howard"],
      "lastMessage":
          "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do elusmod tempor incid"
    },
    {
      "name": ["Andy Bernard"],
      "lastMessage":
          "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do elusmod tempor incid"
    },
  ];

  void navigate() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, __, ___) => const Dashboard(),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

  void newMessage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, __, ___) => const NewMessage(),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

  void navigateToMessage(messages) {
    if (messages['name'].length == 1) {
      List<String> recipientsList = [];
      recipientsList.add(messages['name'][0]);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, __, ___) => Message(
            recipients: recipientsList,
          ),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else {
      List<String> recipientsList = messages['name'];
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Message(
                  recipients: recipientsList,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        flexibleSpace: Column(children: [
          const SizedBox(height: 54),
          Stack(
            children: [
              Container(
                height: 48,
                alignment: Alignment.center,
                child: const Text('Messages', style: AppTextStyles.heading3),
              ),
              Container(
                  height: 48,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Image.asset(
                          AppImages.defaultProfileMD,
                          width: 32,
                          height: 32,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  )),
            ],
          ),
        ]),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: messages.isNotEmpty
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(messages.length);
                        var lastMessage =
                            messages[index]['lastMessage'] ?? 'No Last Message';
                        var title = messages[index]["name"][0] ?? "Unnamed";
                        var group = false;
                        if (messages[index]["name"].length > 1) {
                          print("group message found");
                          lastMessage = messages[index]['name'].join(", ");
                          title = "Group Message";
                          group = true;
                        } else {
                          print("group message not found");
                        }
                        return MessageHistoryCard(
                            name: title,
                            lastMessage: lastMessage,
                            group: group,
                            onTap: () => navigateToMessage(messages[index]));
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      'No messages yet.\nGet started by messaging a friend.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textMD
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonOrangeLG(
              label: "New Message",
              onTap: newMessage,
            ),
          ),
        ],
      ),
      bottomNavigationBar: ModeNavigator(
          navIndex: navIndex,
          onDashboardPopBack: widget.onDashboardPopBack,
          stopTimer: widget.stopTimer),
    );
  }
}
