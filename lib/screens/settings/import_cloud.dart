import 'package:flutter/material.dart';
import 'import_seed.dart';

class ImportCloud extends StatefulWidget {
  const ImportCloud({super.key});

  @override
  ImportCloudState createState() => ImportCloudState();
}

class ImportCloudState extends State<ImportCloud> {
  void seedPhrase() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ImportSeed()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Import flow',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            ElevatedButton(
              onPressed: () => {},
              child: const Text(
                'icloud import',
              ),
            ),
            ElevatedButton(
              onPressed: () => {},
              child: const Text(
                'google import',
              ),
            ),
            ElevatedButton(
              onPressed: () => {seedPhrase()},
              child: const Text(
                'seed import',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
