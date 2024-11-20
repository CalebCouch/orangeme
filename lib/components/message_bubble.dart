import 'package:flutter/material.dart';
import 'package:orange/components/profile_photo.dart';
// import 'package:orange/flows/messages/profile/user_profile.dart';
// import 'package:orangeme_material/navigation.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';

Widget bubble(Message message) {
    return Container(
        decoration: ShapeDecoration(
            color: message.isIncoming ? ThemeColor.bgSecondary : ThemeColor.primary,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: CustomText(
            variant: 'text',
            font_size: 'md',
            text_color: 'heading',
            txt: message.message,
            alignment: TextAlign.left
        ),
    );
}

Widget details(Message m, [bool showTimeOnly = false]) {
    if (!showTimeOnly) {
        return Row(
            mainAxisAlignment: m.isIncoming ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
                CustomText(variant: 'text', font_size: 'sm', text_color: 'text_secondary', txt: m.sender.name),
                CustomText(variant: 'text', font_size: 'sm', text_color: 'text_secondary', txt: '${String.fromCharCodes([0x0020])}·${String.fromCharCodes([0x0020])}'),
                CustomText(variant: 'text', font_size: 'sm', text_color: 'text_secondary', txt: m.time),
            ],
        );
    } else {
        return Row(
            mainAxisAlignment: m.isIncoming ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [CustomText(variant: 'text', font_size: 'sm', text_color: 'text_secondary', txt: m.time)],
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

Widget textMessage(BuildContext context, Message m, bool isGroup, [Message? pM, Message? nM]) {
    bool showTime = _showTime(m, isGroup, pM, nM);
    bool showName = _showName(m, isGroup, pM, nM);
    bool showDetails = showTime || showName;

    return Container(
        alignment: m.isIncoming ? Alignment.bottomLeft : Alignment.bottomRight,
        padding: EdgeInsets.only(bottom: showDetails ? 24 : 8),
        child: isGroup && m.isIncoming ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                !showDetails ? SizedBox(width: 40) : InkWell(
                    onTap: () {
                        //navigateTo(context, UserProfile(m.sender));
                    },
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(right: 8, bottom: 24),
                        child: ProfilePhoto(context, m.sender.pfp),
                    ),
                ),
                Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            bubble(m),
                            if (showDetails) details(m),
                        ],
                    ),
                ),
            ],
        ) : Column(
            crossAxisAlignment: m.isIncoming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
                bubble(m),
                const SizedBox(height: 8),
                if (showTime) details(m, true),
            ],
        ),
    );
}

Widget messageStack(BuildContext context, ScrollController controller, List<Profile> contacts, List<Message> messages) {
    var isGroup = false;
    if (contacts.length > 1) isGroup = true;
    return SizedBox(
        height: double.infinity,
        child: ListView.builder(
            controller: controller,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
                return textMessage(
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
