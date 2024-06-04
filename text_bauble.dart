import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

enum MessageType {
  Send,
  Receive,
}

class MessageBauble extends StatelessWidget {
  final String message;
  final MessageType messageType;

  const MessageBauble({
    Key? key,
    required this.message,
    required this.messageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: messageType == MessageType.Send
          ? Alignment.centerRight
          : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: messageType == MessageType.Receive
          ? EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
            )
          : EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.1,
            ),
      decoration: BoxDecoration(
        color: messageType == MessageType.Send
            ? AppColors.black
            : AppColors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 16,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
