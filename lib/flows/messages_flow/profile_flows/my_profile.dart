import 'package:flutter/material.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/interfaces/default_interface.dart';
import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/profile_photo/profile_photo_edit.dart';
import 'package:orange/components/data_item/did_item.dart';
import 'package:orange/components/data_item/address_item.dart';
import 'package:orange/components/text_input/text_input.dart';
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("image file = $_image");
    return DefaultInterface(
      header: const StackHeader(
        text: "My profile",
      ),
      content: Content(
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              const Spacing(height: AppPadding.profile),
              CustomTextInput(
                controller: nameController,
                title: 'Profile Name',
                hint: 'Profile name...',
              ),
              const Spacing(height: AppPadding.profile),
              CustomTextInput(
                controller: aboutController,
                title: 'About Me',
                hint: 'A little bit about me...',
              ),
              const Spacing(height: AppPadding.profile),
              const DidItem(did: 'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA'),
              const Spacing(height: AppPadding.profile),
              const AddressItem(
                  address: 'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA'),
            ],
          ),
        ),
      ),
      bumper: SingleButton(disabled: true, text: 'Save', onTap: () {}),
    );
  }
}
