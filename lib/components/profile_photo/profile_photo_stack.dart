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
    return Center(
      child: Stack(
        children: [
          ProfilePhoto(
            profilePhoto: contacts[0].photo,
          ),
        ],
      ),
    );
  }
}
