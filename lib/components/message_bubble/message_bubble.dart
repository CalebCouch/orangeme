import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/classes/message_info.dart';
import 'package:orange/theme/stylesheet.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isGroup;
  final Message? previousMessage;
  final Message? nextMessage;

  const MessageBubble({
    super.key,
    required this.message,
    this.isGroup = false,
    this.previousMessage,
    this.nextMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: message.isReceived
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        bubble(message),
        Row(
          children: [
            message.isReceived
                ? displayName(message, previousMessage, nextMessage, isGroup)
                : Container(),
            displayTime(message, nextMessage),
          ],
        ),
        Spacing(
          height: nextMessage != null &&
                  message.isReceived == nextMessage!.isReceived
              ? AppPadding.message
              : AppPadding.content,
        ),
      ],
    );
  }
}

Widget displayTime(Message message, nextMessage) {
  bool shouldDisplayTime =
      nextMessage != null && nextMessage!.time != message.time;
  if (nextMessage == null || shouldDisplayTime) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment:
          message.isReceived ? Alignment.centerLeft : Alignment.centerRight,
      child: CustomText(
        text: message.time,
        color: ThemeColor.textSecondary,
        textSize: TextSize.sm,
      ),
    );
  } else {
    return Container();
  }
}

Widget displayName(
    Message message, previousMessage, nextMessage, bool isGroup) {
  if (previousMessage == null || nextMessage == null) {
    return CustomText(
      text: message.contacts[0].name,
      color: ThemeColor.textSecondary,
      textSize: TextSize.sm,
    );
  }

  bool namesMatch =
      message.contacts[0].name == previousMessage!.contacts[0].name &&
          previousMessage!.isReceived == message.isReceived;
  bool shouldDisplayName = isGroup && message.isReceived;

  if (!namesMatch && shouldDisplayName) {
    return CustomText(
      text: message.contacts[0].name,
      color: ThemeColor.textSecondary,
      textSize: TextSize.sm,
    );
  } else {
    return Container();
  }
}

Widget displayDivider(isDisplayTime, isDisplayName) {
  if (isDisplayTime && isDisplayName) {
    return CustomText(
      text: '· ${String.fromCharCodes([0x0020])}',
      color: ThemeColor.textSecondary,
      textSize: TextSize.sm,
    );
  } else {
    return Container();
  }
}

Widget bubble(Message message) {
  return Container(
    decoration: ShapeDecoration(
      color: message.isReceived ? ThemeColor.bgSecondary : ThemeColor.bitcoin,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeBorders.messageBubble,
      ),
    ),
    constraints: const BoxConstraints(maxWidth: 300),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: CustomText(
      text: message.text,
      textSize: TextSize.md,
      alignment: message.isReceived ? TextAlign.left : TextAlign.right,
    ),
  );
}
