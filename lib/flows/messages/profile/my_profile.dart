import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/data_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
//import 'package:orange/global.dart' as global;

class MyProfile extends GenericWidget {
  MyProfile({super.key});

  String address = '';
  String name = '';
  String did = '';
  String? aboutMe;
  String? photo;
  String? new_name;
  String? new_abtme;
  String? new_pfp;

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends GenericState<MyProfile> {
    
  @override
  PageName getPageName() {
    return PageName.myProfile(widget.new_name, widget.new_abtme, widget.new_pfp);
  }

  @override
  void unpack_state(Map<String, dynamic> json) {
    setState(() {
        widget.address = json['address'] as String;
        widget.name = json['name'] as String;
        widget.did = json['did'] as String;
        widget.aboutMe = json['about_me'] as String?;
        widget.photo = json['profile_picture'] as String?;
        widget.new_name = null;
        widget.new_abtme = null;
        widget.new_pfp = null;
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
  Widget build_with_state(BuildContext context) {
        _profileName = TextEditingController(text: widget.name);
        _aboutMe = TextEditingController(text: widget.aboutMe);

        saveInfo(){
            setState(() {
                save = false;
                widget.new_name = _profileName.text;
                widget.new_abtme = _aboutMe.text;
            });
            FocusScope.of(context).requestFocus(FocusNode());
            super.getState();
        }

        Widget EditName() {
            return CustomTextInput(
                title: 'Profile Name',
                hint: "Profile name...",
                onChanged: (String str) => setState(() => save = true),
                controller: _profileName,
            );
        }

        Widget EditDesc() {
            return CustomTextInput(
                title: 'About Me',
                hint: 'Tell us about yourself...',
                onChanged: (String str) => setState(() => save = true),
                controller: _aboutMe,
            );
        }

        void onPhotoChange() async {
            HapticFeedback.heavyImpact();
            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
                setState(() {
                    print(image.path);
                    widget.photo = widget.new_pfp = image.path;
                });
            }
        }

        Widget EditPhoto() {
            print(widget.photo);
            return CustomColumn([
                    ProfilePhoto(context, widget.photo, ProfileSize.xxl),
                    CustomButton(
                        txt: 'Photo', 
                        variant: 'secondary', 
                        size: 'md', 
                        expand: false, 
                        icon: 'edit', 
                        onTap: onPhotoChange,
                    ),
                ], AppPadding.header,
            );
        }

        return Stack_Default(
            header: Header_Stack(context, "My profile"),
            content: [
                EditPhoto(),
                EditName(),
                EditDesc(),
                didItem(context, widget.did),
                addressItem(context, widget.address),
            ],
            bumper: Bumper(context, content: [
                CustomButton(
                    txt: 'Save', 
                    onTap: saveInfo,
                    enabled: save
                )
            ]),
        );
    }
}
