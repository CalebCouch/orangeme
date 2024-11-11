import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/components/profile_photo.dart';
// import 'package:orange/flows/messages/conversation/exchange.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/classes.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class UserProfile extends GenericWidget {
  final Profile user;
  UserProfile(this.user, {super.key});

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends GenericState<UserProfile> {
  @override
  PageName getPageName() {
    return PageName.userProfile;
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {});
  }

  onMessage() {
    /*navigateTo(
      Exchange(
        //needs to check if a conversation has already been created with this person
        Conversation(
          [Contact(widget.user.name, widget.user.did, widget.user.pfp, widget.user.abtme)],
          [],
        ),
      ), 
    ); */
  }

  onBitcoin() {}

  String address = ''; //Need to generate an address

  @override
  Widget build_with_state(BuildContext context) {
    return Stack_Default(
      Header_Stack(
        context,
        widget.user.name.isNotEmpty
            ? widget.user.name
            : widget.user.did != ''
                ? widget.user.did
                : 'Unknown User',
      ),
      [
        ProfilePhoto(context, widget.user.pfp, ProfileSize.xxl),
        aboutMeItem(context, widget.user.abtme ?? "This profile is still a mystery."),
        didItem(context, widget.user.did),
        addressItem(context, address),
      ],
      Bumper(context, [
        CustomButton('Message', 'primary lg expand none', onMessage, 'enabled'),
        CustomButton('Send Bitcoin', 'primary lg expand none', onBitcoin, 'enabled'),
      ]),
    );
  }
}
