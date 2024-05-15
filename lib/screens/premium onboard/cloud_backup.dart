import 'package:flutter/material.dart';
import 'package:orange/screens/premium%20onboard/desktop_install.dart';

class CloudBackUp extends StatefulWidget {
  const CloudBackUp({super.key});

  @override
  CloudBackUpState createState() => CloudBackUpState();
}

class CloudBackUpState extends State<CloudBackUp> {
  void navigate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DesktopInstall()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Back Up'),
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
