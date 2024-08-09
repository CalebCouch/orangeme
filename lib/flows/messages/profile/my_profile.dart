import 'package:flutter/material.dart';
import 'package:orange/components/data_item.dart';
import 'package:orange/theme/stylesheet.dart';
import 'package:orange/components/default_interface.dart';
import 'package:orange/components/content.dart';
import 'package:orange/components/header.dart';
import 'package:orange/components/profile_photo.dart';
import 'package:orange/components/text_input.dart';
import 'package:orange/components/bumper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:orange/flows/messages/profile/my_profile.dart'; // Import the correct MyProfile class
import 'package:orange/classes.dart'; // Import GlobalState

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  MyProfilePageState createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  late TextEditingController _profileNameController;
  late TextEditingController _aboutMeController;

  late GlobalState _globalState;
  late MyProfile _profile;

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _globalState = GlobalState.init(); 

    _profile = MyProfile(
      name: _globalState.state.value.users.isNotEmpty
          ? _globalState.state.value.users.first.name
          : '',
      about: _globalState.state.value.users.isNotEmpty
          ? _globalState.state.value.users.first.abtme ?? ''
          : '',
    );

    _profileNameController = TextEditingController(text: _profile.name);
    _aboutMeController = TextEditingController(text: _profile.about);

    _profileNameController.addListener(_updateButtonState);
    _aboutMeController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _profileNameController.text.isNotEmpty ||
          _aboutMeController.text.isNotEmpty;
    });
  }

  void _saveProfile() {
    setState(() {
      _profile = MyProfile(
        name: _profileNameController.text,
        about: _aboutMeController.text,
      );

      if (_globalState.state.value.users.isNotEmpty) {
        var user = _globalState.state.value.users.first;
        user.name = _profile.name;
        user.abtme = _profile.about;

        _globalState.state.value = DartState(
          _globalState.state.value.currentPrice,
          _globalState.state.value.usdBalance,
          _globalState.state.value.btcBalance,
          _globalState.state.value.transactions,
          _globalState.state.value.fees,
          _globalState.state.value.conversations,
          _globalState.state.value.users,
        );
        _globalState.state.notifyListeners();  
      }

      _isButtonEnabled = false;
    });

    FocusScope.of(context).unfocus();
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
              ),
              const Spacing(height: AppPadding.profile),
              CustomTextInput(
                title: 'About Me',
                hint: 'A little bit about me...',
                controller: _aboutMeController,
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
