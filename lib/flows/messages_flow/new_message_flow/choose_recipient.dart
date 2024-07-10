import 'package:flutter/material.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';

import 'package:orange/components/interfaces/default_interface.dart';

import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/messages_header.dart';

import 'package:orange/components/tab_navigator/tab_navigator.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/util.dart';

class ChooseRecipient extends StatelessWidget {
  const ChooseRecipient({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultInterface(
      header: const MessagesHeader(
        profilePhoto: ThemeIcon.profile,
      ),
      content: const Content(
        content: Column(
          children: [],
        ),
      ),
      navBar: const TabNav(index: 1),
    );
  }
}
