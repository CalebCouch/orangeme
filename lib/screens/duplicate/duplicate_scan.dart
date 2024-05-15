import 'package:flutter/material.dart';
import 'package:orange/screens/duplicate/duplicate_completed.dart';

class DuplicateScanner extends StatefulWidget {
  const DuplicateScanner({super.key});

  @override
  DuplicateScannerState createState() => DuplicateScannerState();
}

class DuplicateScannerState extends State<DuplicateScanner> {
  void navigate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DuplicateComplete()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duplicate Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Here the user will be shown a QR code scanner and prompted to scan the code displayed on their old phone',
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
