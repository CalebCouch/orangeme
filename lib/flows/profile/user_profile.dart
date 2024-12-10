import 'package:flutter/material.dart';
import 'package:orange/components/data_item.dart';
// import 'package:orange/flows/messages/conversation/exchange.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/generic.dart';
//import 'package:orange/global.dart' as global;

class UserProfile extends GenericWidget {
    DartProfile user;
    UserProfile(this.user, {super.key});

    
    String address = '';
    String name = '';
    String did = '';
    String? abtMe;
    String? photo;

    bool init = true;
    bool sendMessage = false;
    bool sendBitcoin = false;

    @override
    UserProfileState createState() => UserProfileState();
}

class UserProfileState extends GenericState<UserProfile> {
    @override
    PageName getPageName() {
        return PageName.userProfile(widget.init, widget.user);
    }

    @override
    int refreshInterval() {
        return 0;
    }

    @override
    void unpack_state(Map<String, dynamic> json) {
        widget.init = false;
        widget.sendMessage = false;
        widget.sendBitcoin = false;

        widget.address = json['address'] as String;
        widget.name = json['name'] as String;
        widget.did = json['did'] as String;
        widget.abtMe = json['abt_me'] as String?;
        widget.photo = json['profile_picture'] as String?;
    }

    sendMessage() { setState(() => widget.sendMessage = true); }

    sendBitcoin() { setState(() => widget.sendBitcoin = true); }

    @override
    Widget build_with_state(BuildContext context) {
        print(widget.abtMe);
        return Stack_Default(
            header: Header_Stack(context, widget.name),
            content: [
                ProfilePhoto(profile_picture: widget.photo, size: 'xxl'),
                AboutMeItem(context, widget.abtMe ?? "This profile is still a mystery."),
                DidItem(context, widget.did),
                AddressItem(context, widget.address),
            ],
            bumper: Bumper(context, content: [
                CustomButton(txt: 'Message', onTap: sendMessage),
                CustomButton(txt: 'Send Bitcoin', onTap: sendBitcoin),
            ]),
        );
    }
}
