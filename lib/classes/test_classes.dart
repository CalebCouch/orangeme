class Contact {
  final String name;
  final String did;
  final String? pfp;
  final String? abtme;

  const Contact(this.name, this.did, this.pfp, this.abtme);
}

class Info {
  final String? name;
  final String? photo;
  final String? desc;
  final Contact creator;
  final String date;
  final List<Contact> members;
  final List<Message>? messages;

  const Info(
      this.name, this.photo, this.desc, this.creator, this.date, this.members,
      [this.messages]);
}

class Conversation {
  final List<Contact> members;
  final List<Message>? messages;
  final Info? info;

  const Conversation(this.members, [this.messages, this.info]);
}

class Message {
  final Contact sender;
  final String message;
  final String date;
  final String time;
  final bool isIncoming;

  const Message(
      this.sender, this.message, this.date, this.time, this.isIncoming);
}
