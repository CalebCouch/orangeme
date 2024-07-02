import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/components/textfield.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('My profile', style: AppTextStyles.heading4),
      ),
      body: Column(
        children: [
          Text("placeholder"),
        ],
      ),
    );
  }
}
