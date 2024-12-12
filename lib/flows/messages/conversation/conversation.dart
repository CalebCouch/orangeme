import 'package:flutter/material.dart';
import 'package:orange/flows/messages/conversation/info.dart';
import 'package:orange/flows/profile/user_profile.dart';
import 'package:orange/flows/messages/home.dart';
import 'package:material/material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/generic.dart';
// import 'package:orange/global.dart' as global;

class CurrentConversation extends GenericWidget {

    List<DartProfile> members;
    String roomId;

    CurrentConversation({
        super.key, 
        this.roomId = "", 
        this.members = const [],
    });

    List<Message> messages = [];
    bool isGroup = false;
    String roomName = '';
    String? newMessage;

    @override
    CurrentConversationState createState() => CurrentConversationState();
}

class CurrentConversationState extends GenericState<CurrentConversation> {

    @override
    PageName getPageName() {
        return PageName.currentConversation(widget.roomId, widget.members);
    }

    @override
    int refreshInterval() { return 10; }

    @override
    void unpack_state(Map<String, dynamic> json) {
        widget.messages = List<Message>.from(
            json['messages'].map(
                (json) => Message(
                    sender: DartProfile(
                        name: json['sender']['name'] as String,
                        did: json['sender']['did'] as String,
                        abtMe: json['sender']['abt_me'] as String?,
                        pfpPath: json['sender']['pfp_path'] as String?,
                    ),
                    message: json['message'] as String,
                    date: json['date'] as String,
                    time: json['time'] as String,
                    isIncoming: json['is_incoming'] as bool,
                ),
            ),
        );

        widget.members = List<DartProfile>.from(json['members'].map(
            (json) => DartProfile(
                name: json['name'] as String,
                did: json['did'] as String,
                abtMe: json['abt_me'] as String?,
                pfpPath: json['pfp_path'] as String?,
            )
        ));

        widget.roomName = json['room_name'] as String;
        widget.isGroup = json['is_group'] as bool;
        widget.roomId = json['room_id'] as String;
    }

    ScrollController scrollController = ScrollController();
    TextEditingController textController = TextEditingController();

    @override
    void initState() {
       // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        super.initState();
    }

    //_scrollToBottom() {scrollController.jumpTo(scrollController.position.maxScrollExtent);}

    toUserProfile() { navigateTo(UserProfile(widget.members[0])); }

    Widget ChatRecipients() {
        return CustomColumn([
            widget.isGroup 
            ? ProfilePhotoStack(context, widget.members) 
            : ProfilePhoto(profile_picture: widget.members[0].pfpPath, size: 'md'),
            CustomText( 
                variant: 'heading', 
                font_size: 'h5', 
                txt: widget.roomName,
            ),
        ], 8);
    }

    Widget MessageInput() {
        return Container(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: CustomTextInput(
                controller: textController,
                hint: 'Message...', 
                icon: SendButton(
                    onTap: () {
                        // SET RUST STATE HERE
                        //setState(() => widget.newMessage = textController.text);
                        print("Attempting to send message:: '-${textController.text}-'");
                        //setRustState("NewMessage", textController.text);
                        setState(() => textController.text = "");
                    },
                ),
            ),
        );
    }
    Widget MessageStack(List<DartProfile> contacts, List<Message> messages) {
        return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
                return textMessage(
                    context,
                    messages[index],
                    widget.isGroup,
                    index >= 1 ? messages[index - 1] : null,
                    index < (messages.length - 1) ? messages[index + 1] : null,
                );
            },
            
        );
    }

    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Chat(
            header: Header_Message(
                context, 
                left: UniBackButton(context, MessagesHome()),
                center: ChatRecipients(), 
                right: widget.members.length > 1 
                    ? InfoButton(context, ConversationInfo(widget.roomId)) 
                    : CustomIconButton(toUserProfile, icon: 'info')
            ),
            content: [
                widget.messages.isNotEmpty,
                MessageStack(widget.members, widget.messages),
            ],
            bumper: Bumper(context, vertical: true, content: [MessageInput()]),
        );
    }
}

Widget ProfilePhotoStack(BuildContext context, List<DartProfile> contacts) {
    return Container(
        width: 128,
        height: 32,
        alignment: Alignment.center,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: contacts.length < 5 ? contacts.length : 5,
            itemBuilder: (BuildContext context, int index) {
                return Align(
                    widthFactor: 0.75,
                    child: ProfilePhoto(profile_picture: contacts[index].pfpPath, size: 'md'),
                );
            },
        ),
    );
}
