import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';

import 'package:image_picker/image_picker.dart';

import 'dart:io';

class MyProfile extends StatefulWidget {
  final String? profilePhoto;
  final String initialProfileName;
  final String initialAboutMe;

  const MyProfile({
    super.key,
    this.profilePhoto,
    required this.initialProfileName,
    required this.initialAboutMe,
  });

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  late TextEditingController _profileNameController;
  late TextEditingController _aboutMeController;

  late String _profileName;
  late String _aboutMe;

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _profileName = widget.initialProfileName;
    _aboutMe = widget.initialAboutMe;

    _profileNameController = TextEditingController(text: _profileName);
    _aboutMeController = TextEditingController(text: _aboutMe);

    _updateButtonState();
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _profileName.isNotEmpty || _aboutMe.isNotEmpty;
    });
  }

  void _saveProfile() {
    print('Profile Name: $_profileName');
    print('About Me: $_aboutMe');

    FocusScope.of(context).unfocus();

    setState(() {
      _isButtonEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: stackHeader(context, "My profile"),
      content: Content(
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              editPhoto(
                context,
                () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() => _image = File(image.path));
                  }
                },
                _image,
              ),
              const Spacing(height: AppPadding.profile),
              CustomTextInput(
                title: 'Profile Name',
                hint: 'Profile name...',
                controller: _profileNameController,
                onChanged: (text) {
                  setState(() {
                    _profileName = text;
                    _updateButtonState();
                  });
                },
              ),
              const Spacing(height: AppPadding.profile),
              CustomTextInput(
                title: 'About Me',
                hint: 'A little bit about me...',
                controller: _aboutMeController,
                onChanged: (text) {
                  setState(() {
                    _aboutMe = text;
                    _updateButtonState();
                  });
                },
              ),
              const Spacing(height: AppPadding.profile),
              didItem(context, 'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA'),
              const Spacing(height: AppPadding.profile),
              didItem(context, 'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA'),
            ],
          ),
        ),
      ),
      bumper: singleButtonBumper(
        context,
        'Save',
        _isButtonEnabled ? _saveProfile : null, 
        _isButtonEnabled,
      ),
    );
  }
}
