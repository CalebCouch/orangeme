import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/message_info/message_info.dart';
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
    bool shouldDisplayName = isGroup &&
        message.isReceived &&
        previousMessage!.isReceived == message.isReceived;
    bool shouldDisplayTime =
        previousMessage != null && previousMessage!.time == message.time;
    bool shouldDisplayDivider = shouldDisplayTime && shouldDisplayName;
    return Column(
      crossAxisAlignment: message.isReceived
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        bubble(message),
        Row(
          children: [
            shouldDisplayName ? displayName(message) : Container(),
            shouldDisplayDivider ? displayDivider() : Container(),
            shouldDisplayTime ? displayTime(message) : Container(),
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

Widget displayTime(Message message) {
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
}

Widget displayName(Message message) {
  return CustomText(
    text: message.contacts[0].name,
    color: ThemeColor.textSecondary,
    textSize: TextSize.sm,
  );
}

Widget displayDivider() {
  return CustomText(
    text: '· ${String.fromCharCodes([0x0020])}',
    color: ThemeColor.textSecondary,
    textSize: TextSize.sm,
  );
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
