import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/classes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
//import 'package:orange/global.dart' as global;

class MyProfile extends GenericWidget {
  MyProfile({super.key});

  Profile profile = Profile('null', 'nulla', '', 'nulled');
  String address = '';

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends GenericState<MyProfile> {

  String name = '';
  String did = '';
  String? aboutMe = null;
  String? photo = null;
    
  @override
  PageName getPageName() {
    return PageName.myProfile();
  }

  @override
  int refreshInterval() {
    return 0;
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
        widget.profile = Profile.fromJson(json['profile']);
        widget.address = json['address'];
        did = widget.profile.did;
        name = widget.profile.name;
        aboutMe = widget.profile.abtme;
        photo = widget.profile.pfp;
    });
  }


  void initState() {
    super.initState();
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
  Widget build_with_state(BuildContext context) {
    _profileName = TextEditingController(text: name);
    _aboutMe = TextEditingController(text: aboutMe);

    void onEdit() async {
      HapticFeedback.heavyImpact();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          photo = image.path;
        });
      }
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
      return CustomTextInput(
        title: 'Profile Name',
        hint: "Profile name...",
        onChanged: (String str) => enableButton(),
        controller: _profileName,
      );
    }

    Widget EditDesc() {
      return CustomTextInput(
        title: 'About Me',
        hint: 'Tell us about yourself...',
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
        EditPhoto(context, onEdit, photo),
        EditName(),
        EditDesc(),
        didItem(context, did),
        addressItem(context, widget.address),
      ],
      Bumper(context, [CustomButton('Save', 'primary lg expand none', onSave, save)]),
    );
  }
}
