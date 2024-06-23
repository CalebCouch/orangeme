import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';
import 'package:orange/widgets/contact_card.dart';
import 'package:orange/components/headings/stack.dart';

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
      appBar: PreferredSize (
        preferredSize: Size.fromHeight(64.0),
        child: HeadingStack(label: "Group message"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('This group has ${widget.recipients.length} members',
              style: AppTextStyles.textSM.copyWith(color: AppColors.textSecondary)
            ),
          ),
          Expanded(
            child: Padding (
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView.builder(
                itemCount: widget.recipients.length,
                itemBuilder: (BuildContext context, int index) {
                  return ContactCard(
                      name: widget.recipients[index], onTap: () => ());
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
