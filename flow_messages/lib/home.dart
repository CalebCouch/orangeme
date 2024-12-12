import 'package:flow_messages/flow_messages.dart';
import 'package:flow_profiles/flow_profiles.dart';
import 'package:flow_bitcoin/flow_bitcoin.dart';

import 'package:material/material.dart';

class MessagesHome extends GenericWidget {
    MessagesHome({super.key});

    List<ShorthandConversation> conversations = [];
    String? profile_picture = "";
    bool noConversations = true;
    
    @override
    MessagesHomeState createState() => MessagesHomeState();
}

class MessagesHomeState extends GenericState<MessagesHome> {

    @override
    PageName getPageName() {
        return PageName.messagesHome();
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        widget.profile_picture = json["profile_picture"];
        widget.conversations = List<ShorthandConversation>.from(json['conversations'].map(
            (json) => ShorthandConversation(
                roomName: json['room_name'] as String,
                photo: json['photo_path'] as String?,
                subtext: json['subtext'] as String,
                isGroup: json['is_group'] as bool,
                roomId: json['room_id'] as String,
            )
        ));
        widget.noConversations = widget.conversations.isEmpty;
    }


    createNewMessage(){navigateTo(ChooseRecipient());}
    toProfile(){navigateTo(MyProfile());}

    Widget NoConversations() {
        return const CustomText(
            variant:'text',
            font_size: 'md',
            text_color: 'text_secondary', 
            txt: 'No messages yet.\nGet started by messaging a friend.'
        );
    }

    Widget ConversationsList() {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.conversations.length,
            itemBuilder: (context, i) {
                return ConversationItem(
                    widget.conversations[i].photo,
                    widget.conversations[i].isGroup,
                    widget.conversations[i].roomName,
                    widget.conversations[i].subtext,
                    (){ navigateTo(CurrentConversation(roomId: widget.conversations[i].roomId)); },
                );
            },
        );
    }

    Widget ConversationItem(photo, isGroup, roomName, subtext, onTap) {
        return ListItem(
            onTap: onTap,
            title: roomName,
            desc: subtext,
            visual: isGroup 
                ? ProfilePhoto(display_icon: 'group') 
                : ProfilePhoto(profile_picture: photo),
        );
    }

    @override
    Widget build_with_state(BuildContext context) {
        return Root_Home(
            header: Header_Home(context, "Messages", widget.profile_picture, toProfile),
            content: [widget.noConversations ? NoConversations() : ConversationsList()],
            bumper: Bumper(context, content: [CustomButton(txt: 'New Message', onTap: createNewMessage)]),
            tabNav: TabNav(1, [ TabInfo(BitcoinHome(), 'wallet'), TabInfo(MessagesHome(), 'message')]),
            alignment: widget.noConversations ? Alignment.center : Alignment.topCenter,
            scroll: !widget.noConversations,
        );
    }
}
