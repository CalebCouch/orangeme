import 'package:flutter/material.dart';
import '../settings/backup.dart';
import 'opt_out_cloud.dart';

class OptOutConfirm extends StatefulWidget {
  const OptOutConfirm({super.key});

  @override
  OptOutConfirmState createState() => OptOutConfirmState();
}

class OptOutConfirmState extends State<OptOutConfirm> {
  String message = 'I AM A DUMBASS';
  final TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      isButtonEnabled = _controller.text == message;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void signUp() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const BackUp()));
  }

  void optOut() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const OptOutCloud()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Opt Out'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You really should use Premium.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {signUp()},
              child: const Text(
                'Sign up',
              ),
            ),
            const SizedBox(height: 30),
            Text('Enter $message to continue',
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isButtonEnabled ? optOut : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey[700],
                disabledForegroundColor: Colors.white,
              ),
              child: const Text(
                'Continue',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
