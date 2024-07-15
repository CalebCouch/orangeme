import 'dart:io';

class Profile {
  final String name;
  final File? photo;
  final String did;
  final String aboutMe;

  const Profile(this.name, this.photo, this.did, this.aboutMe);
}
