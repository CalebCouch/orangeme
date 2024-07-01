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
      dayResult =
          "${stringifyMonthName(time.month)} ${time.day}, ${time.year}, ";
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

  String stringifyMonthName(int month) {
    if (month == 1) {
      return "Jan";
    } else if (month == 2) {
      return "Feb";
    } else if (month == 3) {
      return "Mar";
    } else if (month == 4) {
      return "Apr";
    } else if (month == 5) {
      return "May";
    } else if (month == 6) {
      return "Jun";
    } else if (month == 7) {
      return "Jul";
    } else if (month == 8) {
      return "Aug";
    } else if (month == 9) {
      return "Sept";
    } else if (month == 10) {
      return "Oct";
    } else if (month == 11) {
      return "Nov";
    } else if (month == 12) {
      return "Dec";
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
                : AppColors.offBlack,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(6.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
            formatTimestamp(widget.timestamp),
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
