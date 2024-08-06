import 'dart:io';

class Contact {
  final String name;
  final File? photo;
  final String did;

  const Contact(this.name, this.photo, this.did);
}

class Info {
  final String? name;
  final String? photo;
  final String? desc;
  final String creator;
  final String date;
  final int members;

  const Info(
      this.name, this.photo, this.desc, this.creator, this.date, this.members);
}
