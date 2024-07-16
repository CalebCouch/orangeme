import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/classes/single_message.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes/contact_info.dart';

class MessageBubble extends StatelessWidget {
  final SingleMessage message;
  final bool isGroup;
  final SingleMessage? previousMessage;
  final SingleMessage? nextMessage;

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
            //message.isReceived
            displayName(message, nextMessage, isGroup),
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

Widget displayTime(SingleMessage message, nextMessage) {
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

Widget displayName(SingleMessage message, nextMessage, isGroup) {
  bool shouldDisplay =
      nextMessage != null && nextMessage!.contact.name != message.contact.name;
  bool shouldDisplayTime =
      nextMessage != null && nextMessage!.time != message.time;

  if (isGroup) {
    if (nextMessage == null || message.isReceived && shouldDisplay) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: message.isReceived
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: CustomText(
              text: message.contact.name,
              color: ThemeColor.textSecondary,
              textSize: TextSize.sm,
            ),
          ),
          nextMessage == null || shouldDisplayTime && shouldDisplay
              ? displayDivider()
              : Container(),
        ],
      );
    } else {
      return Container();
    }
  } else {
    return Container();
  }
}

Widget displayDivider() {
  return CustomText(
    text:
        '${String.fromCharCodes([0x0020])}· ${String.fromCharCodes([0x0020])}',
    color: ThemeColor.textSecondary,
    textSize: TextSize.sm,
  );
}

Widget bubble(SingleMessage message) {
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

Widget messageStack(BuildContext context, List<Contact> contacts,
    List<SingleMessage> messages) {
  var isGroup = false;
  if (contacts.length > 1) isGroup = true;
  return SizedBox(
    height: double.infinity,
    child: ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        return MessageBubble(
          previousMessage: index >= 1 ? messages[index - 1] : null,
          nextMessage:
              index < (messages.length - 1) ? messages[index + 1] : null,
          isGroup: isGroup,
          message: messages[index],
        );
      },
    ),
  );
}
