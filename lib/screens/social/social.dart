import 'package:flutter/material.dart';
import 'package:orange/components/tab_navigator.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'new_message.dart';
import 'package:orange/components/message_item_group.dart';
import 'message.dart';
import 'package:orange/screens/social/my_profile.dart';

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
      "name": ["Kasey Jarvis", "Ruthie", "C. Goodman"],
      "lastMessage":
          "Slowly but surely. Got stuck on one part, but I think I’ve figured it out."
    },
    {
      "name": ["Maurie Walsh"],
      "profilePath": AppImages.test4,
      "lastMessage": "you: No worries, I’ll let the team know."
    },
    {
      "name": ["Andrew Bash"],
      "profilePath": AppImages.test5,
      "lastMessage": "Sure, I’m in. Sushi place?"
    },
    {
      "name": ["Joanna Santiago"],
      "profilePath": AppImages.test6,
      "lastMessage":
          "you: Interesting approach. Might need some tweaking though."
    },
    {
      "name": ["V. Mcintyre"],
      "profilePath": AppImages.test3,
      "lastMessage": "Nice!",
    },
    {
      "name": ["Connie Saunders"],
      "profilePath": AppImages.test7,
      "lastMessage":
          "How about something bold like navy blue with gold accents?"
    },
    {
      "name": ["Martin B."],
      "profilePath": AppImages.test2,
      "lastMessage": "you: Game night sounds fun! I’ll bring snacks.",
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
        PageRouteBuilder(
          pageBuilder: (context, __, ___) =>
              Message(recipients: recipientsList),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  }

  void navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Stack(
            children: [
              const Center(
                child: Text('Messages', style: AppTextStyles.heading3),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    navigateToProfile();
                  },
                  child: Image.asset(
                    AppImages.defaultProfileMD,
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
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
                        var profile = messages[index]["profilePath"];
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
                        return MessageItemGroup(
                            imagePath: profile,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonOrangeLG(
              label: "New Message",
              onTap: newMessage,
            ),
          ),
        ],
      ),
      bottomNavigationBar: TabNavigator(
          navIndex: navIndex,
          onDashboardPopBack: widget.onDashboardPopBack,
          stopTimer: widget.stopTimer),
    );
  }
}
