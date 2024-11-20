import 'package:flutter/material.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/components/profile_photo.dart';
// import 'package:orange/flows/messages/conversation/exchange.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class UserProfile extends GenericWidget {
    UserProfile({super.key});

    String address = '';
    String name = '';
    String did = '';
    String? aboutMe;
    String? photo;

    bool init = true;

    @override
    UserProfileState createState() => UserProfileState();
}

class UserProfileState extends GenericState<UserProfile> {
    @override
    PageName getPageName() {
        return PageName.userProfile(widget.init);
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        setState(() {
            widget.init = false;

            widget.address = json['address'] as String;
            widget.name = json['name'] as String;
            widget.did = json['did'] as String;
            widget.aboutMe = json['about_me'] as String?;
            widget.photo = json['profile_picture'] as String?;
        });
    }

    sendMessage() {}

    sendBitcoin() {}

    @override
    Widget build_with_state(BuildContext context) {
        return Stack_Default(
            header: Header_Stack(context, widget.name),
            content: [
                ProfilePhoto(context, widget.photo, ProfileSize.xxl),
                aboutMeItem(context, widget.aboutMe ?? "This profile is still a mystery."),
                didItem(context, widget.did),
                addressItem(context, widget.address),
            ],
            Bumper(context, content: [
                CustomButton(txt: 'Message', onTap: sendMessage),
                CustomButton(txt: 'Send Bitcoin', onTap: sendBitcoin),
            ]),
        );
    }
}
