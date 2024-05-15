import 'package:flutter/material.dart';
import 'package:orange/screens/premium%20onboard/finish.dart';

class SweepFunds extends StatefulWidget {
  const SweepFunds({super.key});

  @override
  SweepFundsState createState() => SweepFundsState();
}

class SweepFundsState extends State<SweepFunds> {
  void navigate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const PremiumFinish()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sweep Funds'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Here the user will be presented with a prepoulated transaction that will sweep funds from their legacy spending wallet to their premium spending wallet',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {navigate()},
              child: const Text(
                'Proceed',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
