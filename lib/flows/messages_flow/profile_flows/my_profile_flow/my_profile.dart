import 'package:flutter/material.dart';
//import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
//import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/components/profile_photo/profile_photo_edit.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class MyProfile extends StatefulWidget {
  final String? profilePhoto;
  const MyProfile({super.key, this.profilePhoto});

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  @override
  Widget build(BuildContext context) {
    print("image file = $_image");
    return DefaultInterface(
      header: const StackHeader(
        text: "My profile",
      ),
      content: Content(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfilePhotoEdit(
              profilePhoto: _image,
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  print("image file = $_image");
                  setState(() => _image = File(image.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
