import 'package:flutter/material.dart';
import 'package:orange/screens/opt%20out/opt_out_seed_display.dart';

class OptOutCloud extends StatefulWidget {
  const OptOutCloud({super.key});

  @override
  OptOutCloudState createState() => OptOutCloudState();
}

class OptOutCloudState extends State<OptOutCloud> {
  void navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const OptOutSeed()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opt Out Cloud'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cloud backup',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {},
              child: const Text(
                'ICloud Backup',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {},
              child: const Text(
                'Google cloud backup',
              ),
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
