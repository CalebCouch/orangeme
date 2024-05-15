import 'package:flutter/material.dart';
import 'package:orange/screens/spending/spending_dashboard.dart';

class DuplicateComplete extends StatefulWidget {
  const DuplicateComplete({super.key});

  @override
  DuplicateCompleteState createState() => DuplicateCompleteState();
}

class DuplicateCompleteState extends State<DuplicateComplete> {
  void navigate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SpendingDashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duplicate Complete'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have successfully duplicated your wallet.',
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
