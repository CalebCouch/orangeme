import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange/components/data_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orangeme_material/orangeme_material.dart';
import 'package:orange/generic.dart';
import 'package:orange/src/rust/api/pub_structs.dart';
import 'package:orange/flows/multi_device/pair_computer/download_desktop.dart';
//import 'package:orange/global.dart' as global;

class MyProfile extends GenericWidget {
    MyProfile({super.key});

    String address = '';
    String name = '';
    String did = '';
    String? abtMe;
    String? photo;
    String? new_name;
    String? new_abtme;
    String? new_pfp;

    bool init = true;

    @override
    MyProfileState createState() => MyProfileState();
}

class MyProfileState extends GenericState<MyProfile> {
    @override
    PageName getPageName() {
      return PageName.myProfile(widget.init);
    }

    @override
    unpack_state(Map<String, dynamic> json) {
        widget.init = false;
        widget.address = json['address'] as String;
        widget.name = json['name'] as String;
        widget.did = json['did'] as String;
        widget.abtMe = json['abt_me'] as String?;
        widget.photo = json['profile_picture'] as String?;
        widget.new_name = null;
        widget.new_abtme = null;
        widget.new_pfp = null;
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
        _aboutMe = TextEditingController(text: widget.abtMe);

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
            return CustomColumn([
                    ProfilePhoto(context, pfp: widget.photo, size: ProfileSize.xxl),
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

        Widget ConnectComputerItem() {
            return DataItem(
                title: 'Connect to a Computer',
                subtitle: 'Connect this device to a laptop or desktop computer to back up accounts or create a savings wallet',
                buttons: [CustomButton(variant: 'secondary', size: 'md', expand: false, txt: 'Connect Computer', onTap: () {navigateTo(DownloadDesktop());}, icon: 'link')],
            );
        }

        return Stack_Default(
            header: Header_Stack(context, "My profile"),
            content: [
                EditPhoto(),
                EditName(),
                EditDesc(),
                DidItem(context, widget.did),
                AddressItem(context, widget.address),
                ConnectComputerItem(),
            ],
            bumper: Bumper(context, content: [CustomButton(txt: 'Save', onTap: saveInfo, enabled: save)]),
        );
    }
}
