import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/widgets/contact_card.dart';

class GroupMessageList extends StatefulWidget {
  final List<String> recipients;
  const GroupMessageList({super.key, required this.recipients});

  @override
  GroupMessageListState createState() => GroupMessageListState();
}

class GroupMessageListState extends State<GroupMessageList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 18, bottom: 24),
            child: Text('This group has ${widget.recipients.length} members',
                style: AppTextStyles.textMD
                    .copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: ListView.builder(
                itemCount: widget.recipients.length,
                itemBuilder: (BuildContext context, int index) {
                  return ContactCard(
                      name: widget.recipients[index],
                      did:
                          "VfsXfhUthJitNlfGtinjKKlpoNklUyGfdesWWszxcvbFgytnWikjhg32h58uthnc",
                      onTap: () => ());
                  // imagePath: contacts[index]["imagePath"]!,
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
