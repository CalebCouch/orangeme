import 'package:flutter/material.dart';

import 'package:orange/components/interfaces/default_interface.dart';

import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/messages_header.dart';
import 'package:orange/components/bumpers/double_button_bumper.dart';

import 'package:orange/flows/wallet_flow/send_flow/send.dart';
import 'package:orange/flows/wallet_flow/receive_flow/receive.dart';

import 'package:orange/util.dart';

class MessagesHome extends StatelessWidget {
  const MessagesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const MessagesHeader(
        profilePhoto: '',
      ),
      content: const Content(
        content: Column(
          children: [],
        ),
      ),
      bumper: DoubleButton(
        firstText: "Receive",
        secondText: "Send",
        firstOnTap: () {
          navigateTo(context, const Receive());
        },
        secondOnTap: () {
          navigateTo(context, const Send());
        },
      ),
      navBar: const TabNav(),
    );
  }
}
