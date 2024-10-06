import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/classes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orangeme_material/orangeme_material.dart';

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
    _profileName = TextEditingController(text: state.personal.name);
    _aboutMe = TextEditingController(text: state.personal.abtme);
    onEdit() {
      () async {
        HapticFeedback.heavyImpact();
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() => state.personal.pfp = image.path);
        }
      };
    }

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

    Widget EditName() {
      return CustomTextInput(
        title: 'Profile Name',
        hint: 'Profile name...',
        onChanged: (String str) => {enableButton()},
        controller: _profileName,
      );
    }

    Widget EditDesc() {
      return CustomTextInput(
        title: 'About Me',
        hint: 'A little bit about me...',
        onChanged: (String str) => {enableButton()},
        controller: _aboutMe,
      );
    }

    onSave() {
      if (save) saveInfo();
    }

    return Stack_Default(
      Header_Stack(context, "My profile"),
      [
        EditPhoto(context, onEdit, state.personal.pfp),
        EditName(),
        EditDesc(),
        didItem(context, state.personal.did),
        addressItem(context, widget.address),
      ],
      Bumper([CustomButton('Save', 'primary lg $save expand none', onSave())]),
    );
  }
}
