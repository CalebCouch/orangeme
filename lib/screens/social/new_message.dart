import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/widgets/contact_card.dart';
import 'package:orange/screens/social/message.dart';
import 'package:orange/components/buttons/secondary_md.dart';

import 'package:flutter_svg/flutter_svg.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  NewMessageState createState() => NewMessageState();
}

class NewMessageState extends State<NewMessage> {
  final TextEditingController recipientAddressController =
      TextEditingController();
  List<String> recipients = [];
  List<Map<String, String>> contacts = [
    {
      "name": "Pam Beesley",
      "imagePath": "assets/images/pam.png",
      "did": "VfsXfhUthJitNlfGtinjKKlpoNklUyGfdesWWszxcvbFgytnWikjhg32h58uthnc"
    },
    {
      "name": "Dwight Schrute",
      "imagePath": "assets/images/dwight.png",
      "did": "VfsXfhUthJitNlfGtinjKKlpoNklUyGfdesWWszxcvbFgytnWikjhg32h58uthnc"
    },
    {
      "name": "Michael Scott",
      "imagePath": "assets/images/michael.png",
      "did": "VfsXfhUthJitNlfGtinjKKlpoNklUyGfdesWWszxcvbFgytnWikjhg32h58uthnc"
    },
    {
      "name": "Jim Halpert",
      "imagePath": "assets/images/jim.png",
      "did": "VfsXfhUthJitNlfGtinjKKlpoNklUyGfdesWWszxcvbFgytnWikjhg32h58uthnc"
    },
    {
      "name": "Ryan Howard",
      "imagePath": "assets/images/ryan.png",
      "did": "VfsXfhUthJitNlfGtinjKKlpoNklUyGfdesWWszxcvbFgytnWikjhg32h58uthnc"
    },
    {
      "name": "Andy Bernard",
      "imagePath": "assets/images/andy.png",
      "did": "VfsXfhUthJitNlfGtinjKKlpoNklUyGfdesWWszxcvbFgytnWikjhg32h58uthnc"
    },
    {
      "name": "Stanley Hudson",
      "imagePath": "assets/images/stanley.png",
      "did": "VfsXfhUthJitNlfGtinjKKlpoNklUyGfdesWWszxcvbFgytnWikjhg32h58uthnc"
    },
  ];

  void addRecipient(String name) {
    if (recipients.contains(name)) return;

    setState(() {
      recipients.add(name);
    });
  }

  void removeRecipient(String name) {
    setState(() {
      recipients.remove(name);
    });
  }

  void navigateToMessage() {
    if (recipients.length == 1) {
      List<String> recipientsList = [];
      recipientsList.add(recipients.first);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, __, ___) => Message(
            recipients: recipientsList,
          ),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, __, ___) => Message(
            recipients: recipients,
          ),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  }

  Widget _buildRecipientList() {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List<Widget>.generate(recipients.length, (index) {
          return ButtonSecondaryMD(
            label: recipients[index],
            icon: "clear",
            onTap: () => removeRecipient(recipients[index]),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Column(children: [
          const SizedBox(height: 54),
          Stack(
            children: [
              Container(
                height: 48,
                alignment: Alignment.center,
                child: const Text('New Message', style: AppTextStyles.heading4),
              ),
              Container(
                height: 48,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: IconButton(
                  icon: SvgPicture.asset(
                    AppIcons.left,
                    width: 32,
                    height: 32,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              if (recipients.isNotEmpty)
                Container(
                  height: 48,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      navigateToMessage();
                    },
                    child: const Text("Next", style: AppTextStyles.labelMD),
                  ),
                ),
            ],
          ),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Column(
          children: [
            TextInputField(
              controller: recipientAddressController,
              hint: "Profile Name",
            ),
            _buildRecipientList(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ContactCard(
                      name: contacts[index]["name"]!,
                      did: contacts[index]["did"]!,
                      onTap: () => addRecipient(contacts[index]["name"]!),
                      // imagePath: contacts[index]["imagePath"]!,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
