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
import 'package:orange/classes.dart';

class MyProfile extends StatefulWidget {
  final String? profilePhoto;
  final GlobalState globalState;
  const MyProfile(this.globalState, {super.key, this.profilePhoto});

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  Widget build_screen(BuildContext context, DartState state) {
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
                //presetTxt: state.
                title: 'Profile Name',
                hint: 'Profile name...',
              ),
              const Spacing(height: AppPadding.profile),
              const CustomTextInput(
                title: 'About Me',
                hint: 'A little bit about me...',
              ),
              const Spacing(height: AppPadding.profile),
              didItem(context, 'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA'),
              const Spacing(height: AppPadding.profile),
              didItem(context, 'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA'),
            ],
          ),
        ),
      ),
      bumper: singleButtonBumper(context, 'Save', () {}, false),
    );
  }
}
