import 'package:flutter/material.dart';
import 'backup.dart';
import 'import_cloud.dart';
import 'duplicate_phone.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  void navigateBackUp() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const BackUp()));
  }

  void navigateDuplicate() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DuplicatePhone()));
  }

  void navigateImportOptOut() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ImportCloud()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  navigateDuplicate();
                },
                child: const Text('Duplicate', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  navigateImportOptOut();
                },
                child:
                    const Text('Import Wallet', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  navigateBackUp();
                },
                child: const Text('Back Up', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
