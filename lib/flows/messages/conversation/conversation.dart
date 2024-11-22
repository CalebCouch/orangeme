import 'package:flutter/material.dart';
import 'package:orange/components/message_bubble.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/flows/messages/conversation/info.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/generic.dart';
// import 'package:orange/global.dart' as global;

class CurrentConversation extends GenericWidget {
    CurrentConversation({super.key});

    List<Message> messages = [];
    List<Profile> members = [];

    @override
    CurrentConversationState createState() => CurrentConversationState();
}

class CurrentConversationState extends GenericState<CurrentConversation> {
    @override
    PageName getPageName() {
        return PageName.currentConversation();
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            widget.members = []; 
            widget.messages = [];
        });
    }

    ScrollController scrollController = ScrollController();

    @override
    void initState() {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        super.initState();
    }

    _scrollToBottom() {scrollController.jumpTo(scrollController.position.maxScrollExtent);}

    toUserProfile() {/*navigateTo(UserProfile(widget.members[0]));*/}

    Widget ChatRecipients() {
        bool isGroup =  widget.members.length > 1;
        return CustomColumn([
            isGroup ? profilePhotoStack(context, widget.members) : ProfilePhoto(context, widget.members[0].pfpPath, ProfileSize.lg, false),
            CustomText( variant: 'heading', font_size: 'h5', txt: isGroup ? 'Group Message' : widget.members[0].name),
        ], 8);
    }

    Widget MessageInput() {
        return Container(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: const CustomTextInput(
                hint: 'Message',
                showIcon: true,
            ),
        );
    }

    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Chat(
            header: Header_Message(
                context, 
                ChatRecipients(), 
                widget.members.length > 1 
                    ? InfoButton(context, ConversationInfo()) 
                    : CustomIconButton(toUserProfile, 'info', 'lg')
            ),
            content: [
                widget.messages.isNotEmpty,
                messageStack(context, scrollController, widget.members, widget.messages),
            ],
            bumper: Bumper(context, content: [MessageInput()]),
        );
    }
}
