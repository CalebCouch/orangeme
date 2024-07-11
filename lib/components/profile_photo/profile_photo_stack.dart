import 'package:flutter/material.dart';
import 'package:orange/components/profile_photo/profile_photo.dart';
import 'package:orange/classes/contact_info.dart';

class ProfilePhotoStack extends StatelessWidget {
  final List<Contact> contacts;

  const ProfilePhotoStack({
    super.key,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 32,
      alignment: Alignment.center,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: (contacts.length),
        itemBuilder: (BuildContext context, int index) {
          return Align(
            widthFactor: 0.8,
            child: ProfilePhoto(outline: true, profilePhoto: contacts[0].photo),
          );
        },
      ),
    );
  }
}
