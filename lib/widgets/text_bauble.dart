import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:intl/intl.dart';

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
    String namePrefix = "";
    //only show the name prefix if the message is receieved from another
    if (widget.incoming == "true") {
      namePrefix = "${widget.name} · ";
    }
    int dayDifference = now.difference(time).inDays.abs();
    bool isSameDay =
        now.year == time.year && now.month == time.month && now.day == time.day;
    DateTime yesterday = now.subtract(const Duration(days: 1));
    bool isYesterday = yesterday.year == time.year &&
        yesterday.month == time.month &&
        yesterday.day == time.day;
    String dayResult = '';
    if (isSameDay) {
      dayResult = '';
    } else if (isYesterday) {
      dayResult = "Yesterday, ";
    } else if (dayDifference <= 7) {
      dayResult = "${truncateDayName(time.weekday)} ";
    } else {
      dayResult = "${time.month} ${time.day}, ${time.year}, ";
    }

    String timeFormatted = DateFormat('h:mm a').format(time);

    String timeResult = "$dayResult$timeFormatted";

    return "$namePrefix$timeResult";
  }

  String truncateDayName(int weekday) {
    if (weekday == 1) {
      return "Mon";
    } else if (weekday == 2) {
      return "Tues";
    } else if (weekday == 3) {
      return "Wed";
    } else if (weekday == 4) {
      return "Thurs";
    } else if (weekday == 5) {
      return "Fri";
    } else if (weekday == 6) {
      return "Sat";
    } else if (weekday == 7) {
      return "Sun";
    } else {
      return '';
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
