import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

import 'dart:async';

enum MessageType {
  Send,
  Receive,
}

class MessageBauble extends StatefulWidget {
  final String message;
  final MessageType messageType;

  const MessageBauble({
    Key? key,
    required this.message,
    required this.messageType,
  }) : super(key: key);

  @override
  _MessageBaubleState createState() => _MessageBaubleState();
}

class _MessageBaubleState extends State<MessageBauble> {
  String? timeStamp;

  @override
  void initState() {
    super.initState();
    // Start a timer to add a timestamp after 10 seconds
    if (widget.messageType == MessageType.Send || widget.messageType == MessageType.Receive) {
      Timer(Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            timeStamp = _getCurrentTime();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.messageType == MessageType.Send ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 300), // Maximum width set to 300
          decoration: BoxDecoration(
            color: widget.messageType == MessageType.Send ? AppColors.orange : AppColors.darkGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(6.0), // 6px padding around the container
          child: Padding(
            padding: const EdgeInsets.all(12.0), // 12px padding around the text
            child: Text(
              widget.message,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            timeStamp ?? '', // Display the timestamp if it's not null
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
      ],
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }
}
