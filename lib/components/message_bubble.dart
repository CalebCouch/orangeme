import 'package:flutter/material.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/flows/messages/profile/user_profile.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/classes.dart';
import 'package:orange/util.dart';

Widget bubble(Message message) {
  return Container(
    decoration: ShapeDecoration(
      color: message.isIncoming ? ThemeColor.bgSecondary : ThemeColor.primary,
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

Widget details(Message m, [bool showTimeOnly = false]) {
  if (!showTimeOnly) {
    return Row(
      mainAxisAlignment:
          m.isIncoming ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        CustomText(
          text: m.sender.name,
          color: ThemeColor.textSecondary,
          textSize: TextSize.sm,
        ),
        CustomText(
          text: '${String.fromCharCodes([0x0020])}· ${String.fromCharCodes([
                0x0020
              ])}',
          color: ThemeColor.textSecondary,
          textSize: TextSize.sm,
        ),
        CustomText(
          text: m.time,
          color: ThemeColor.textSecondary,
          textSize: TextSize.sm,
        )
      ],
    );
  } else {
    return Row(
      mainAxisAlignment:
          m.isIncoming ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        CustomText(
          text: m.time,
          color: ThemeColor.textSecondary,
          textSize: TextSize.sm,
        )
      ],
    );
  }
}

bool _showName(Message m, bool isGroup, [Message? pM, Message? nM]) {
  if (nM == null) return true;
  if (isGroup && m.isIncoming && m.sender.name != nM.sender.name) return true;
  return false;
}

bool _showTime(Message m, bool isGroup, [Message? pM, Message? nM]) {
  if (nM == null) return true;

  if (nM.time != m.time) return true;
  if (m.sender.name != nM.sender.name) return true;
  return false;
}

Widget textMessage(
    GlobalState globalState, BuildContext context, Message m, bool isGroup,
    [Message? pM, Message? nM]) {
  bool showTime = _showTime(m, isGroup, pM, nM);
  bool showName = _showName(m, isGroup, pM, nM);
  bool showDetails = showTime || showName;
  return Container(
    alignment: m.isIncoming ? Alignment.bottomLeft : Alignment.bottomRight,
    padding: EdgeInsets.only(bottom: showDetails ? 24 : 8),
    child: isGroup && m.isIncoming
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              showDetails
                  ? InkWell(
                      onTap: () {
                        navigateTo(context,
                            UserProfile(globalState, userInfo: m.sender));
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(right: 8, bottom: 24),
                        child: profilePhoto(context, m.sender.pfp),
                      ),
                    )
                  : Container(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bubble(m),
                  Container(
                    child: showDetails ? details(m) : Container(),
                  ),
                ],
              )
            ],
          )
        : Column(
            crossAxisAlignment: m.isIncoming
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              bubble(m),
              showTime ? details(m, true) : Container(),
            ],
          ),
  );
}

Widget messageStack(
    GlobalState globalState,
    BuildContext context,
    ScrollController controller,
    List<Contact> contacts,
    List<Message> messages) {
  var isGroup = false;
  if (contacts.length > 1) isGroup = true;
  return SizedBox(
    height: double.infinity,
    child: ListView.builder(
      controller: controller,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        return textMessage(
          globalState,
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
