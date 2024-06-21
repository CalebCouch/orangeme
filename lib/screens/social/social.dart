import 'package:flutter/material.dart';
import 'package:orange/widgets/mode_navigator.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'new_message.dart';
import 'package:orange/widgets/message_history_card.dart';
import 'message.dart';
import 'group_message.dart';

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
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  void newMessage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewMessage()));
  }

  void navigateToMessage(messages) {
    if (messages['name'].length == 1) {
      List<String> recipientsList = [];
      recipientsList.add(messages['name'][0]);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Message(
                  recipients: recipientsList,
                )),
      );
    } else {
      List<String> recipientsList = messages['name'];
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MessageGroup(
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
        elevation: 0,
        title: const Text('Messages'),
        leading: Image.asset(
          AppImages.defaultProfileMD,
          width: 10,
          height: 10,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isNotEmpty
                ? ListView.builder(
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
                  )
                : Center(
                    child: Text(
                      'No chats yet.\nGet started by messaging a friend.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textMD
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: ButtonOrangeLG(
              label: "New Message",
              onTap: newMessage,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: ModeNavigator(
            navIndex: navIndex,
            onDashboardPopBack: widget.onDashboardPopBack,
            stopTimer: widget.stopTimer),
      ),
    );
  }
}
