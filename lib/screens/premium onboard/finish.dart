import 'package:flutter/material.dart';
import 'package:orange/screens/spending/spending_dashboard.dart';

class PremiumFinish extends StatefulWidget {
  const PremiumFinish({super.key});

  @override
  PremiumFinishState createState() => PremiumFinishState();
}

class PremiumFinishState extends State<PremiumFinish> {
  void navigate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SpendingDashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Congratulations. You have completed setup of your premium account.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {navigate()},
              child: const Text(
                'Home',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
