import 'package:flutter/material.dart';
import 'package:orange/src/rust/api/simple.dart';
import 'package:orange/util.dart';
import 'package:orange/styles/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange/screens/non_premium/dashboard.dart';
import 'package:orange/screens/social/message.dart';

class HeadingStack extends StatefulWidget {
  final String label;

  const HeadingStack({
    super.key,
    required this.label,
  });

  @override
  CustomHeadingState createState() => CustomHeadingState();
}

class CustomHeadingState extends State<HeadingStack> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align (
          alignment: Alignment.centerLeft,
          child: Padding (
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: SvgPicture.asset(AppIcons.left, width: 32, height: 32),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ),
        ),
        Container (
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: AppTextStyles.heading3
          ),
        )
      ]
    );
  }
}



class HeadingStackMessages extends StatefulWidget {
  final List<String> messages;

  const HeadingStackMessages({
    super.key,
    required this.messages,
  });

  @override
  CustomHeadingMState createState() => CustomHeadingMState();
}

class CustomHeadingMState extends State<HeadingStackMessages> {

  void navigateToMessage(messages) {
    if (messages['name'].length == 1) {
      List<String> recipientsList = [];
      recipientsList.add(messages['name'][0]);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Message(
            recipients: recipientsList,
          )
        ),
      );
    } else {
      List<String> recipientsList = messages['name'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Message(
            recipients: recipientsList,
          )
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align (
          alignment: Alignment.centerLeft,
          child: Padding (
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: SvgPicture.asset(AppIcons.left, width: 32, height: 32),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ),
        ),
        Align (
          alignment: Alignment.center,
          child: Text(
            "New message",
            style: AppTextStyles.heading3
          ),
        ),
        Align (
          alignment: Alignment.centerRight,
          child: widget.recipients.isNotEmpty ? Padding(
            padding: const EdgeInsets.only(right: 28),
            child: GestureDetector(
              onTap: () {
                navigateToMessage(widget.messages);
              },
              child: const Text("Next", style: AppTextStyles.labelMD),
            ),
          ) : SizedBox(width:0)
        ),
      ]
    );
  }
}

