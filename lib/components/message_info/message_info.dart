import 'package:orange/components/contact_info/contact_info.dart';

class Message {
  final String text;
  final bool isReceived;
  final String time;
  final List<Contact> contacts;

  const Message(this.text, this.isReceived, this.time, this.contacts);
}
