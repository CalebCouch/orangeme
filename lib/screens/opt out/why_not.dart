import 'package:flutter/material.dart';
import 'opt_out_confirm.dart';

class WhyNot extends StatefulWidget {
  const WhyNot({super.key});

  @override
  WhyNotState createState() => WhyNotState();
}

class WhyNotState extends State<WhyNot> {
  void navigate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const OptOutConfirm()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opt Out'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Why you should not opt of premium out and use 12 words',
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
