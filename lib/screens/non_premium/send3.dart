import 'package:flutter/material.dart';
import 'package:orange/screens/spending/spending_dashboard.dart';

class Send3 extends StatefulWidget {
  final double amount;
  final String address;

  const Send3({super.key, required this.amount, required this.address});

  @override
  Send3State createState() => Send3State();
}

class Send3State extends State<Send3> {
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
              'Place holder screen for fee selection.',
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
