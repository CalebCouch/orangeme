import 'package:orange/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/components/textfield.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  NewMessageState createState() => NewMessageState();
}

class NewMessageState extends State<NewMessage> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  void navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  void newMessage() {
    print("new message button selected");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('New message'),
      ),
      body: TextInputField(
        controller: recipientAddressController,
        hint: "Profile Name",
      ),
    );
  }
}
