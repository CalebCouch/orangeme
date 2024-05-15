import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SavingsReceive extends StatefulWidget {
  const SavingsReceive({super.key});

  @override
  SavingsReceiveState createState() => SavingsReceiveState();
}

//hardcoded placecholder address
String _address = "bc1qxy2k23432f2493p83kkfjhx0wlh";

class SavingsReceiveState extends State<SavingsReceive> {
  @override
  void initState() {
    super.initState();
  }

  String _getShortenedAddress() {
    if (_address.length <= 30) {
      return _address;
    } else {
      final firstPart = _address.substring(0, 15);
      final lastPart = _address.substring(_address.length - 15);
      return '$firstPart...$lastPart';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: const Icon(
                Icons.qr_code,
                size: 200,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your Address:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getShortenedAddress(),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _address));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Address copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Change Address'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
