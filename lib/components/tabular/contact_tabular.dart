import 'package:flutter/material.dart';
import 'package:orange/components/tabular/single_tab.dart';

class ContactTabular extends StatelessWidget {
  final String name;
  final String did;

  const ContactTabular({
    super.key,
    required this.name,
    required this.did,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleTab(title: "Profile name", subtitle: name),
        SingleTab(title: "Digital ID", subtitle: did),
      ],
    );
  }
}
