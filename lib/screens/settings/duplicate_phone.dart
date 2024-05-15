import 'package:flutter/material.dart';

class DuplicatePhone extends StatefulWidget {
  const DuplicatePhone({super.key});

  @override
  DuplicatePhoneState createState() => DuplicatePhoneState();
}

class DuplicatePhoneState extends State<DuplicatePhone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duplicate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Duplicate Phone flow will go here',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}
