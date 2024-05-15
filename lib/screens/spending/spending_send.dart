import 'package:flutter/material.dart';

class SpendingSend extends StatefulWidget {
  const SpendingSend({super.key});

  @override
  SpendingSendState createState() => SpendingSendState();
}

class SpendingSendState extends State<SpendingSend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Spending Send',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}
