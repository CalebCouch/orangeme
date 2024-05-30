import 'package:orange/widgets/mode_navigator.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:orange/screens/non_premium/dashboard.dart';

class SocialDashboard extends StatefulWidget {
  const SocialDashboard({super.key});

  @override
  SocialDashboardState createState() => SocialDashboardState();
}

class SocialDashboardState extends State<SocialDashboard> {
  int navIndex = 1;

  void navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const TextMarkLG(),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Coming Soon!',
              style: AppTextStyles.textLG,
            ),
          ],
        ),
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
