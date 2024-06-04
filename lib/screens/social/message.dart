import 'package:orange/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/widgets/text_bauble.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  void navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Contact Name'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'No messaages yet.',
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.textMD.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
