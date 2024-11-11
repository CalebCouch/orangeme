import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/classes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orangeme_material/orangeme_material.dart';
//import 'package:orange/global.dart' as global;

class MyProfile extends GenericWidget {
  MyProfile({super.key});

  Profile profile = Profile('', '', '', '');

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends GenericState<MyProfile> {
  @override
  String stateName() {
    return "MyProfile";
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
      widget.profile = Profile.fromJson(json);
    });
  }

  final ImagePicker _picker = ImagePicker();
  late TextEditingController _profileName = TextEditingController();
  late TextEditingController _aboutMe = TextEditingController();
  @override
  void dispose() {
    _profileName.dispose();
    _aboutMe.dispose();
    super.dispose();
  }

  bool save = false;

  @override
  Widget build(BuildContext context) {
    _profileName = TextEditingController(text: widget.profile.name);
    _aboutMe = TextEditingController(text: widget.profile.abtme);
    onEdit() {
      () async {
        HapticFeedback.heavyImpact();
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() => widget.profile.pfp = image.path);
        }
      };
    }

    saveInfo() {
      setState(() {
        save = false;
        //widget.personal.name = _profileName.text;
        //widget.personal.abtme = _aboutMe.text;
      });
      FocusScope.of(context).requestFocus(FocusNode());
    }

    enableButton() {
      setState(() {
        save = true;
      });
    }

    Widget EditName() {
      final presetText = widget.profile.name.isEmpty ? widget.profile.did : widget.profile.name;
      return CustomTextInput(
        title: 'Profile Name',
        hint: "Profile name...",
        presetTxt: presetText,
        onChanged: (String str) => enableButton(),
        controller: _profileName,
      );
    }

    Widget EditDesc() {
      return CustomTextInput(
        title: 'About Me',
        hint: 'Tell us about yourself...',
        presetTxt: widget.profile.abtme,
        onChanged: (String str) => {enableButton()},
        controller: _aboutMe,
      );
    }

    onSave() {
      if (save) saveInfo();
    }

    String enabled = save ? 'enabled' : 'disabled';
    String address = ''; //Need to generate an address
    return Stack_Default(
      Header_Stack(context, "My profile"),
      [
        EditPhoto(context, onEdit, widget.profile.pfp),
        EditName(),
        EditDesc(),
        didItem(context, widget.profile.did),
        addressItem(context, address),
      ],
      Bumper(context, [CustomButton('Save', 'primary lg expand none', onSave, enabled)]),
    );
  }
}
