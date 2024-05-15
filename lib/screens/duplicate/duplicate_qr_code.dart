import 'package:flutter/material.dart';
import 'package:orange/screens/spending/spending_dashboard.dart';

class DuplicateQRCode extends StatefulWidget {
  const DuplicateQRCode({super.key});

  @override
  DuplicateQRCodeState createState() => DuplicateQRCodeState();
}

class DuplicateQRCodeState extends State<DuplicateQRCode> {
  void navigate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SpendingDashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duplicate QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'A QR code will be displayed here on the users old phone which will be scanned with the new phone',
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
