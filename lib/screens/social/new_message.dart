import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/components/textfield.dart';
import 'package:orange/widgets/contact_card.dart';
import 'package:orange/screens/social/message.dart';
import 'package:orange/components/buttons/secondary_md.dart';

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
        MaterialPageRoute(
            builder: (context) => Message(
                  recipients: recipientsList,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Message(
                  recipients: recipients,
                )),
      );
    }
  }

  Widget _buildRecipientList() {
    if (recipients.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          children: [
            ButtonSecondaryMD(
              label: recipients[0],
              icon: AppIcons.close,
              onTap: () => removeRecipient(recipients[0]),
            ),
          ],
        ),
      );
    } else {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List<Widget>.generate(recipients.length, (index) {
          return ButtonSecondaryMD(
            label: recipients[index],
            icon: AppIcons.close,
            onTap: () => removeRecipient(recipients[index]),
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text("New Message", style: AppTextStyles.heading4),
            Spacer(flex: recipients.isNotEmpty ? 1 : 2),
            if (recipients.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    navigateToMessage();
                  },
                  child: const Text("Next", style: AppTextStyles.labelMD),
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: TextInputField(
              controller: recipientAddressController,
              hint: "Profile Name",
            ),
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
    );
  }
}
