import 'package:flutter/material.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/flows/messages/conversation/info.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/generic.dart';
// import 'package:orange/global.dart' as global;

class CurrentConversation extends GenericWidget {

    List<DartProfile>? members;
    String roomId = "";

    CurrentConversation({super.key, this.roomId = "", this.members = null});

    List<Message> messages = [];
    List<DartProfile> membersList = [];
    bool isGroup = false;

    @override
    CurrentConversationState createState() => CurrentConversationState();
}

class CurrentConversationState extends GenericState<CurrentConversation> {

    @override
    PageName getPageName() {
        return PageName.currentConversation(widget.roomId, widget.members);
    }

    @override
    int refreshInterval() { return 0; }

    @override
    void unpack_state(Map<String, dynamic> json) {
        widget.messages = List<Message>.from(json['messages'].map(
            (json) => Message(
                sender: json['sender'] as DartProfile,
                message: json['message'] as String,
                date: json['date'] as String,
                time: json['time'] as String,
                isIncoming: json['is_incoming'] as bool,
            )
        ));
        widget.members = List<DartProfile>.from(json['members'].map(
            (json) => DartProfile(
                name: json['name'] as String,
                did: json['did'] as String,
                abtMe: json['about_me'] as String?,
                pfpPath: json['pfp_path'] as String?,
            )
        ));
        widget.membersList = widget.members ?? [];
    }

    ScrollController scrollController = ScrollController();

    @override
    void initState() {
       // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        super.initState();
    }

    //_scrollToBottom() {scrollController.jumpTo(scrollController.position.maxScrollExtent);}

    toUserProfile() {/*navigateTo(UserProfile(membersList[0]));*/}

    Widget ChatRecipients() {
        bool isGroup =  widget.membersList.length > 1;
        return CustomColumn([
            isGroup ? profilePhotoStack(context, widget.membersList) : ProfilePhoto(context, widget.membersList[0].pfpPath, ProfileSize.lg, false),
            CustomText( variant: 'heading', font_size: 'h5', txt: isGroup ? 'Group Message' : widget.membersList[0].name),
        ], 8);
    }

    Widget MessageInput() {
        return Container(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: const CustomTextInput(hint: 'Message', showIcon: true),
        );
    }
    Widget MessageStack(List<DartProfile> contacts, List<Message> messages) {
        var isGroup = false;
        if (contacts.length > 1) isGroup = true;
        return ListView.builder(
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
            
        );
    }

    @override
    Widget build_with_state(BuildContext context) {
        //return Container();
        return Stack_Chat(
            header: Header_Message(
                context, 
                ChatRecipients(), 
                widget.membersList.length > 1 
                    ? InfoButton(context, ConversationInfo()) 
                    : CustomIconButton(toUserProfile, 'info', 'lg')
            ),
            content: [
                widget.messages.isNotEmpty,
                Container(color: Colors.red), //MessageStack(widget.membersList, widget.messages),
            ],
            bumper: Bumper(context, vertical: true, content: [MessageInput()]),
        );
    }
}
