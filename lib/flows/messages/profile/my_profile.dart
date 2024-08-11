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
  late TextEditingController _profileName = TextEditingController();
  late TextEditingController _aboutMe = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.globalState.state,
      builder: (BuildContext context, DartState state, Widget? child) {
        return build_screen(context, state);
      },
    );
  }

  @override
  void dispose() {
    _profileName.dispose();
    _aboutMe.dispose();
    super.dispose();
  }

  bool save = false;

  Widget build_screen(BuildContext context, DartState state) {
    saveInfo() {
      setState(() {
        save = false;
        state.personal.name = _profileName.text;
        state.personal.abtme = _aboutMe.text;
      });
      FocusScope.of(context).requestFocus(FocusNode());
    }

    enableButton() {
      setState(() {
        save = true;
      });
    }

    _profileName = TextEditingController(text: state.personal.name);
    _aboutMe = TextEditingController(text: state.personal.abtme);

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
                    setState(() => state.personal.pfp = image.path);
                  }
                },
                state.personal.pfp,
              ),
              const Spacing(height: AppPadding.profile),
              CustomTextInput(
                title: 'Profile Name',
                hint: 'Profile name...',
                onChanged: (String str) => {enableButton()},
                controller: _profileName,
              ),
              const Spacing(height: AppPadding.profile),
              CustomTextInput(
                title: 'About Me',
                hint: 'A little bit about me...',
                onChanged: (String str) => {enableButton()},
                controller: _aboutMe,
              ),
              const Spacing(height: AppPadding.profile),
              didItem(context, state.personal.did),
              const Spacing(height: AppPadding.profile),
              addressItem(context, 'VZDrYz39XxuPadsBN8BklsgEhPsr5zKQGjTA'),
            ],
          ),
        ),
      ),
      bumper: singleButtonBumper(
        context,
        'Save',
        save
            ? () {
                saveInfo();
              }
            : () {},
        save,
      ),
    );
  }
}
