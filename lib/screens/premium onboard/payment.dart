import 'package:flutter/material.dart';
import 'equipment.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  @override
  void initState() {
    super.initState();
  }

  void navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Equipment()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Payment for premium onboarding will go here',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 30),
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
