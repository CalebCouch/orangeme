import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';

Widget messageBubble(BuildContext context, Message message, bool isGroup,
    [Message? previousMessage, Message? nextMessage]) {
  return Column(
    crossAxisAlignment:
        message.isIncoming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
    children: [
      bubble(message),
      Row(
        children: [
          displayName(message, nextMessage, isGroup),
          displayTime(message, nextMessage),
        ],
      ),
      Spacing(
        height:
            nextMessage != null && message.isIncoming == nextMessage.isIncoming
                ? AppPadding.message
                : AppPadding.content,
      ),
    ],
  );
}

Widget displayTime(Message message, nextMessage) {
  bool shouldDisplayTime =
      nextMessage != null && nextMessage!.time != message.time;
  if (nextMessage == null || shouldDisplayTime) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment:
            message.isIncoming ? Alignment.centerLeft : Alignment.centerRight,
        child: CustomText(
          text: message.time,
          color: ThemeColor.textSecondary,
          textSize: TextSize.sm,
        ),
      ),
    );
  } else {
    return Container();
  }
}

Widget displayName(Message message, Message? nextMessage, isGroup) {
  bool shouldDisplay =
      nextMessage != null && nextMessage.sender.name != message.sender.name;
  bool shouldDisplayTime =
      nextMessage != null && nextMessage.time != message.time;

  if (isGroup) {
    if (message.isIncoming && shouldDisplay) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: message.isIncoming
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: CustomText(
              text: message.sender.name,
              color: ThemeColor.textSecondary,
              textSize: TextSize.sm,
            ),
          ),
          shouldDisplayTime && shouldDisplay ? displayDivider() : Container(),
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

Widget bubble(Message message) {
  return Container(
    decoration: ShapeDecoration(
      color: message.isIncoming ? ThemeColor.bgSecondary : ThemeColor.bitcoin,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeBorders.messageBubble,
      ),
    ),
    constraints: const BoxConstraints(maxWidth: 300),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: CustomText(
      text: message.message,
      textSize: TextSize.md,
      alignment: TextAlign.left,
      color: message.isIncoming ? ThemeColor.text : ThemeColor.heading,
    ),
  );
}

Widget messageStack(
    BuildContext context, List<Contact> contacts, List<Message> messages) {
  var isGroup = false;
  if (contacts.length > 1) isGroup = true;
  return SizedBox(
    height: double.infinity,
    child: ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        return messageBubble(
          context,
          messages[index],
          isGroup,
          index >= 1 ? messages[index - 1] : null,
          index < (messages.length - 1) ? messages[index + 1] : null,
        );
      },
    ),
  );
}
