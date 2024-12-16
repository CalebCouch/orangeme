// import 'package:orange/flows/messages/profile/user_profile.dart';
// import 'package:material/navigation.dart';
import 'package:material/material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';

Widget bubble(Message message) {
    return Container(
        decoration: ShapeDecoration(
            color: message.isIncoming ?  Display.bg_secondary : Display.brand_primary,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: CustomText(
            variant: 'text',
            font_size: 'md',
            text_color: Display.brand_secondary,
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
                CustomText(variant: 'secondary', font_size: 'sm', txt: m.sender.name),
                CustomText(variant: 'secondary', font_size: 'sm', txt: '${String.fromCharCodes([0x0020])}·${String.fromCharCodes([0x0020])}'),
                CustomText(variant: 'secondary', font_size: 'sm', txt: m.time),
            ],
        );
    } else {
        return Row(
            mainAxisAlignment: m.isIncoming ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [CustomText(variant: 'secondary', font_size: 'sm', txt: m.time)],
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
                        child: ProfilePhoto(profile_picture: m.sender.pfpPath),
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
