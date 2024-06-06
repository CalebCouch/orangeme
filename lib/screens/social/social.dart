import 'package:flutter/material.dart';
import 'package:orange/widgets/mode_navigator.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/components/buttons/orange_lg.dart';
import 'new_message.dart';

class SocialDashboard extends StatefulWidget {
  const SocialDashboard({super.key});

  @override
  SocialDashboardState createState() => SocialDashboardState();
}

class SocialDashboardState extends State<SocialDashboard> {
  int navIndex = 1;
  bool messageHistory = false;

  void navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  void newMessage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewMessage()));
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
            child: messageHistory
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Scrollable message content goes here.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.textMD
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
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
        ),
      ),
    );
  }
}
