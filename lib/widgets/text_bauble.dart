import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

import 'dart:async';

class MessageBauble extends StatefulWidget {
  final String message;
  final String incoming;
  final String timestamp;
  final String name;

  const MessageBauble(
      {super.key,
      required this.message,
      required this.incoming,
      required this.name,
      required this.timestamp});

  @override
  MessageBaubleState createState() => MessageBaubleState();
}

class MessageBaubleState extends State<MessageBauble> {
  @override
  void initState() {
    super.initState();
  }

  String formatTimestamp(String timestamp) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(timestamp);

    if (widget.incoming == "true") {
      return "${widget.name} · ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.incoming == "false"
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          constraints:
              const BoxConstraints(maxWidth: 300), // Maximum width set to 300
          decoration: BoxDecoration(
            color: widget.incoming == "false"
                ? AppColors.orange
                : AppColors.darkGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          padding:
              const EdgeInsets.all(6.0), // 6px padding around the container
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
            formatTimestamp(
                widget.timestamp), // Display the timestamp if it's not null
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
}
