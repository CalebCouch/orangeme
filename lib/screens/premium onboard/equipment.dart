import 'package:flutter/material.dart';
import 'package:orange/screens/premium%20onboard/cloud_backup.dart';

class Equipment extends StatefulWidget {
  const Equipment({super.key});

  @override
  EquipmentState createState() => EquipmentState();
}

class EquipmentState extends State<Equipment> {
  void navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const CloudBackUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Initial premium setup instructions including a list of required equipment will go here',
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
