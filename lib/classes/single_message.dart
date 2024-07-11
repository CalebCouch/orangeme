import 'package:orange/classes/contact_info.dart';

class SingleMessage {
  final String text;
  final bool isReceived;
  final String time;
  final Contact contact;

  const SingleMessage(this.text, this.isReceived, this.time, this.contact);
}
