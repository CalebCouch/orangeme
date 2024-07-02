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
      "name": "Damian Jarvis",
      "imagePath": AppImages.test1,
      "did": "fpRBLGDMsP92oqULfEvOkWDnD6sr6FtjCe9F2Q66C2pHHdWbJBeFCugTG0mtuY9U"
    },
    {
      "name": "Stephano",
      "imagePath": AppImages.test2,
      "did": "M1gITBEnk01tqi4d89gX84ByXOqHZobBFCugTG0mtuY9UtjCe9F2Q66C2pH2391"
    },
    {
      "name": "Theo M.",
      "imagePath": AppImages.test3,
      "did": "bFAULsWPfHXbUmBNMqNNBL1xjMh7Z8KR"
    },
    {
      "name": "Doug Cunningham",
      "imagePath": AppImages.test4,
      "did": "ejdH9pMtTESLgvPztC5JgUWiT00VKvdFFCugTG0mtuY9UtjCe9F2Q66C2pHHdWbJ"
    },
    {
      "name": "Scott Addams",
      "imagePath": AppImages.test5,
      "did": "FCugTG0mtuY9UtjCe9F2Q66C2pHHdWbJUtjCe9F2Q66C2pT00VKvdFF"
    },
    {
      "name": "Brit",
      "imagePath": AppImages.test6,
      "did":
          "1SBfJO1DIGAugcwj1SAKoyBDtdWgBtbDnHejdH9pMtTESLgvPztC5JgUWiT00VKvdFAow"
    },
    {
      "name": "Leo Doyle",
      "imagePath": AppImages.test7,
      "did":
          "jXX86f9I2CFchKHy0VEeXf2NlluOgipWqkV37x8WrjX5OfnkrX4nq466reeRGPIJBhYFD3WClR"
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
            icon: AppIcons.close,
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
        flexibleSpace: Container(
          padding: const EdgeInsets.only(top: 16),
          child: Stack(
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
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            TextInputField(
              controller: recipientAddressController,
              hint: "Profile Name",
            ),
            _buildRecipientList(),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ContactCard(
                    imagePath: contacts[index]["imagePath"]!,
                    name: contacts[index]["name"]!,
                    did: contacts[index]["did"]!,
                    onTap: () => addRecipient(contacts[index]["name"]!),
                    // imagePath: contacts[index]["imagePath"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
