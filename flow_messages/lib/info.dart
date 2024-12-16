import 'package:material/material.dart';

import 'package:flow_profiles/flow_profiles.dart';

class ConversationInfo extends GenericWidget {
    String roomId = "";
    ConversationInfo(this.roomId, {super.key});

    List<DartProfile> members = [];

    @override
    ConversationInfoState createState() => ConversationInfoState();
}

class ConversationInfoState extends GenericState<ConversationInfo> {
    @override
    PageName getPageName() {return PageName.conversationInfo(widget.roomId);}

    @override
    int refreshInterval() {return 0;}

    @override
    void unpack_state(Map<String, dynamic> json) {
        widget.members = List<DartProfile>.from(json['members'].map(
            (json) => DartProfile(
                name: json['name'] as String,
                did: json['did'] as String,
                abtMe: json['about_me'] as String?,
                pfpPath: json['pfp_path'] as String?,
            )
        ));
    }

    Widget Information() {
        return CustomText(
            variant: 'secondary', 
            font_size: 'md',
            txt: 'This group has ${widget.members.length} members'
        );
    }

    Widget ListMembers() {
        onPressed(DartProfile user) {navigateTo(UserProfile(user));}

        return ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: widget.members.length,
            itemBuilder: (BuildContext context, int index) {
                return ContactItem(
                    context, 
                    widget.members[index], 
                    () => onPressed(widget.members[index]),
                );
            },
        );
    }
    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Scroll(
            header: Header_Stack(context, "Group members"),
            content: [
                Information(),
                ListMembers(),
            ],
        );  
    }
}