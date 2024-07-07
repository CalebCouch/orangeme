import 'package:flutter/material.dart';
import 'package:orange/theme/stylesheet.dart';

import 'package:orange/components/interfaces/default_interface.dart';

import 'package:orange/components/content/content.dart';
import 'package:orange/components/headers/stack_header.dart';
import 'package:orange/components/bumpers/single_button_bumper.dart';
import 'package:orange/components/data_item/confirm_address_item.dart';
import 'package:orange/components/custom/custom_text.dart';
import 'package:orange/util.dart';

import 'package:orange/flows/wallet_flow/send_flow/send.dart';

class ConfirmSend extends StatefulWidget {
  const ConfirmSend({super.key});

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<ConfirmSend> {
  final TextEditingController recipientAddressController =
      TextEditingController();

  Widget build(BuildContext context) {
    return DefaultInterface(
      header: const StackHeader(
        text: "Confirm send",
      ),
      content: const Content(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConfirmAddressItem(),
          ],
        ),
      ),
      bumper: SingleButton(
        text: "Confirm & Send",
        onTap: () {},
      ),
    );
  }
}
