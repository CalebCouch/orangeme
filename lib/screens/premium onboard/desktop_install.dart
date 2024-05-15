import 'package:flutter/material.dart';
import 'package:orange/screens/opt%20out/opt_out_seed_display.dart';

class DesktopInstall extends StatefulWidget {
  const DesktopInstall({super.key});

  @override
  DesktopInstallState createState() => DesktopInstallState();
}

class DesktopInstallState extends State<DesktopInstall> {
  void navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const OptOutSeed()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Install Desktop App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Install Desktop App',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Desktop App Linker code will go here',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Install orange wallet on your laptop and enter this code when prompted',
              style: Theme.of(context).textTheme.displayMedium,
            ),
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
