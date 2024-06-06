import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/widgets/contact_card.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  NewMessageState createState() => NewMessageState();
}

class NewMessageState extends State<NewMessage> {
  final TextEditingController recipientAddressController =
      TextEditingController();
  List<Map<String, String>> contacts = [
    {"name": "Pam Beesley", "imagePath": "assets/images/pam.png"},
    {"name": "Dwight Schrute", "imagePath": "assets/images/dwight.png"},
    {"name": "Michael Scott", "imagePath": "assets/images/michael.png"},
    {"name": "Jim Halpert", "imagePath": "assets/images/jim.png"},
    {"name": "Ryan Howard", "imagePath": "assets/images/ryan.png"},
    {"name": "Andy Bernard", "imagePath": "assets/images/andy.png"},
    {"name": "Stanley Hudson", "imagePath": "assets/images/stanley.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('New message'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: TextInputField(
              controller: recipientAddressController,
              hint: "Profile Name",
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                return ContactCard(
                  name: contacts[index]["name"]!,
                  // imagePath: contacts[index]["imagePath"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
