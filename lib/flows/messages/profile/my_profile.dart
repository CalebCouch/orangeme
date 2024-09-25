import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';

import 'package:orange/classes.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io' show Platform;

// rovides a user interface for viewing and editing personal profile details,
// including updating profile photo, name, and about me section.

class MyProfile extends StatefulWidget {
  final GlobalState globalState;
  final String? profilePhoto;
  final String address;
  const MyProfile(
    this.globalState,
    this.address, {
    super.key,
    this.profilePhoto,
  });

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

    bool onDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    return Interface(
      widget.globalState,
      header: onDesktop
          ? homeDesktopHeader(context, "My profile")
          : stackHeader(context, "My profile"),
      content: Content(
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              editPhoto(
                context,
                () async {
                  HapticFeedback.heavyImpact();
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
              addressItem(context, widget.address),
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
      desktopOnly: true,
      navigationIndex: 2,
    );
  }
}
