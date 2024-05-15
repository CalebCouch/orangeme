import 'package:flutter/material.dart';
import 'package:orange/screens/spending/spending_dashboard.dart';

class OptOutSeed extends StatefulWidget {
  const OptOutSeed({super.key});

  @override
  OptOutSeedState createState() => OptOutSeedState();
}

class OptOutSeedState extends State<OptOutSeed> {
  void navigate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SpendingDashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('12 word seed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Here is your list of 12 seed words',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {navigate()},
              child: const Text(
                'Finish',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
